/* Configuration de déploiement de MS-Designer.
   url ou anonKey vide = mode en ligne désactivé : l'application reste 100 % locale.

   Supabase → Project Settings → API :
     url     : Project URL (https://xxxx.supabase.co)
     anonKey : clé « anon » / « publishable ». Elle est publique par conception :
               les droits sont appliqués par la base (voir supabase/schema.sql). */
window.MSDESIGNER_CONFIG = {
  supabase: {
    url: '',
    anonKey: ''
  }
};
