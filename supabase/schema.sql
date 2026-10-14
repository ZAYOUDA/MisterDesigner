-- MS-Designer : stockage et partage des modélisations dans Supabase.
-- À exécuter une fois dans Supabase → SQL Editor. Le script peut être relancé sans risque.

-- E-mail de l'utilisateur connecté (vérifié par le lien magique), en minuscules.
create or replace function public.my_email() returns text
language sql stable as $$ select lower(coalesce(auth.jwt() ->> 'email', '')) $$;

-- ---------- tables ----------
create table if not exists public.models (
  id               uuid primary key default gen_random_uuid(),
  owner            uuid not null default auth.uid() references auth.users(id) on delete cascade,
  owner_email      text not null default public.my_email(),
  name             text not null default 'Modélisation',
  data             jsonb not null,
  version          integer not null default 1,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  updated_by_email text not null default public.my_email()
);
create index if not exists models_owner_idx on public.models(owner);

create table if not exists public.model_shares (
  model_id   uuid not null references public.models(id) on delete cascade,
  email      text not null check (email = lower(email) and position('@' in email) > 1),
  role       text not null default 'read' check (role in ('read', 'edit')),
  created_at timestamptz not null default now(),
  primary key (model_id, email)
);
create index if not exists model_shares_email_idx on public.model_shares(email);

create table if not exists public.model_versions (
  id             bigint generated always as identity primary key,
  model_id       uuid not null references public.models(id) on delete cascade,
  version        integer not null,
  name           text not null,
  data           jsonb not null,
  saved_at       timestamptz not null,
  saved_by_email text not null
);
create index if not exists model_versions_model_idx on public.model_versions(model_id, version desc);

-- ---------- droits (security definer : évite la récursion entre les règles des deux tables) ----------
create or replace function public.model_role(mid uuid) returns text
language sql stable security definer set search_path = public as $$
  select case
    when m.owner = auth.uid() then 'owner'
    else (select s.role from public.model_shares s where s.model_id = m.id and s.email = public.my_email())
  end
  from public.models m where m.id = mid
$$;

alter table public.models         enable row level security;
alter table public.model_shares   enable row level security;
alter table public.model_versions enable row level security;

drop policy if exists models_select on public.models;
drop policy if exists models_insert on public.models;
drop policy if exists models_update on public.models;
drop policy if exists models_delete on public.models;
-- « owner = auth.uid() » en premier : pendant un INSERT … RETURNING, model_role() ne voit pas encore la nouvelle ligne.
create policy models_select on public.models for select to authenticated using (owner = auth.uid() or public.model_role(id) is not null);
create policy models_insert on public.models for insert to authenticated with check (owner = auth.uid());
create policy models_update on public.models for update to authenticated using (public.model_role(id) in ('owner', 'edit'));
create policy models_delete on public.models for delete to authenticated using (owner = auth.uid());

drop policy if exists shares_select on public.model_shares;
drop policy if exists shares_write  on public.model_shares;
create policy shares_select on public.model_shares for select to authenticated
  using (email = public.my_email() or public.model_role(model_id) = 'owner');
create policy shares_write on public.model_shares for all to authenticated
  using (public.model_role(model_id) = 'owner') with check (public.model_role(model_id) = 'owner');

drop policy if exists versions_select on public.model_versions;
create policy versions_select on public.model_versions for select to authenticated using (public.model_role(model_id) is not null);
-- pas de règle d'écriture : seules les fonctions ci-dessous écrivent l'historique.

-- ---------- version, auteur et historique à chaque enregistrement ----------
create or replace function public.models_before_update() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  new.owner := old.owner;              -- le propriétaire ne change jamais
  new.owner_email := old.owner_email;
  new.created_at := old.created_at;
  new.version := old.version + 1;      -- l'application compare ce numéro pour détecter les conflits
  new.updated_at := now();
  new.updated_by_email := public.my_email();
  -- Une entrée d'historique par séance de travail : à chaque changement d'auteur
  -- ou après 10 minutes sans enregistrement (l'envoi automatique est fréquent).
  if old.updated_by_email <> new.updated_by_email or old.updated_at < now() - interval '10 minutes' then
    insert into public.model_versions(model_id, version, name, data, saved_at, saved_by_email)
    values (old.id, old.version, old.name, old.data, old.updated_at, old.updated_by_email);
    delete from public.model_versions v where v.model_id = old.id and v.id not in (
      select id from public.model_versions where model_id = old.id order by version desc limit 50);
  end if;
  return new;
end $$;

drop trigger if exists models_before_update on public.models;
create trigger models_before_update before update on public.models
  for each row execute function public.models_before_update();

-- ---------- liste avec le rôle de l'utilisateur ----------
create or replace view public.models_list with (security_invoker = true) as
  select m.id, m.name, m.owner_email, m.version, m.created_at, m.updated_at, m.updated_by_email, public.model_role(m.id) as role
  from public.models m;

grant select, insert, update, delete on public.models, public.model_shares to authenticated;
grant select on public.model_versions, public.models_list to authenticated;
revoke all on public.models, public.model_shares, public.model_versions, public.models_list from anon;
