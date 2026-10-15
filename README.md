# MS-Designer

Éditeur de conception pour applications IBM Planning Analytics / TM1 : cubes, axes d'analyse repliables, liens (règles, process TI, feeders, vues), vue matrice Dimensions × Cubes.

## Fonctionnalités

- Cubes typés (Saisie, Hypothèse, Transco, Calcul, Restitution, Paramètre, Source, Fichier plat, Data warehouse) et types personnalisés
- Dimensions repliables par cube, catalogue de dimensions avec surlignage des cubes qui les utilisent
- Liens entre cubes avec repère (R1, F1…), nom du flux (double-clic sur le repère) et description
- Sélection multiple (Maj + clic, Maj + glisser, Ctrl + A) : déplacer, changer le type, ajouter une dimension, aligner, supprimer
- Import d'une matrice Excel « Dims\Cubes » (.xlsx, .csv)
- Import d'un schéma dessiné avec les formes Excel (cubes, encadrés de dimensions, connecteurs, repères F1/R1, légende de couleurs)
- Un seul bouton **Exporter** : page HTML de consultation (le schéma et la matrice seuls, sans boutons ni outils de modification, fonctionne hors ligne, polices intégrées, réimportable dans MS-Designer), image PNG haute résolution, fichier JSON, sauvegarde de tous les projets du profil
- Profils sur le PC : chacun crée le sien (nom, couleur) et retrouve ses projets, son thème et sa disposition ; auteur et dernier modificateur enregistrés dans chaque projet ; sauvegarde / restauration pour changer de PC
- Plusieurs projets enregistrés dans le navigateur (ouvrir, dupliquer, supprimer), enregistrement automatique, annuler / rétablir
- Thème clair, sombre ou automatique
- Palette et panneau de propriétés masquables, mode « Modèle seul » (Alt+1, Alt+2, Alt+0)

## En ligne (Supabase)

Quand `public/config.js` contient l'URL et la clé anon d'un projet Supabase, un bouton **En ligne** apparaît :

- connexion par lien magique envoyé par e-mail (ou code à 6 chiffres), sans mot de passe ;
- mise en ligne d'un projet, liste « mes modèles et ceux partagés avec moi », ouverture sur n'importe quel PC ;
- partage par modèle : le propriétaire invite un collègue par e-mail, en **lecture seule** ou **peut modifier** ; lien direct `#m-<id>` ;
- modifications partagées dans les deux sens : les siennes partent 4 s après chaque changement, celles des autres arrivent toutes seules (vérification toutes les 10 s et au retour sur l'onglet) ; un vrai conflit (les deux côtés modifiés) demande quoi faire ;
- les projets en ligne se retrouvent dans n'importe quel navigateur ou PC après connexion (liste « Projets ») ; un navigateur vierge ouvre directement le dernier projet en ligne ;
- historique des versions (une par séance de travail, 50 max) ;
- hors ligne, les modifications restent sur le PC et partent au retour du réseau.

Les droits sont appliqués par la base (Row Level Security) : la clé anon est publique sans risque. `config.js` vide : l'application reste entièrement locale.

### Mise en place

1. Créer un projet sur [supabase.com](https://supabase.com), région UE (Paris ou Francfort).
2. **SQL Editor** : coller et exécuter [`supabase/schema.sql`](supabase/schema.sql).
3. **Authentication → URL Configuration** : *Site URL* `https://misterdesigner.vercel.app`, *Redirect URLs* `https://misterdesigner.vercel.app/**` (et `http://localhost:3000/**` pour les tests locaux).
4. **Authentication → Emails → Magic Link** : ajouter le code au modèle d'e-mail, par exemple `<p>Ou saisissez ce code dans MS-Designer : <b>{{ .Token }}</b></p>`.
5. **Authentication → Emails → SMTP Settings** : brancher un serveur SMTP (Brevo, Resend, Office 365…). Sans SMTP personnalisé, Supabase n'envoie les e-mails qu'aux membres de l'équipe du projet, quelques-uns par heure.
6. **Project Settings → API** : recopier *Project URL* et la clé *anon* dans `public/config.js`, puis pousser.

## Structure

```
public/index.html   application complète (HTML + CSS + JS, sans build)
public/favicon.svg
public/config.js    configuration du mode en ligne (URL et clé anon Supabase)
public/fonts/       IBM Plex Sans et Mono (woff2, licence OFL), servies localement et intégrées aux exports HTML
public/vendor/      supabase-js 2.117.2 (mode en ligne), servi localement
supabase/schema.sql tables, droits et historique à exécuter dans Supabase
vercel.json         sert le dossier public/
```

Dépendances chargées par CDN dans l'application : SheetJS (lecture Excel) et JSZip (lecture des formes Excel). La page HTML exportée n'en a pas besoin.

## Lancer en local

Ouvrir `public/index.html` dans un navigateur, ou :

```
npx serve public
```

## Déploiement Vercel

1. Importer ce dépôt dans Vercel (New Project → Import Git Repository).
2. Framework Preset : **Other**. Aucune commande de build. Le dossier de sortie `public` est défini dans `vercel.json`.
3. Deploy. Chaque push sur la branche principale redéploie automatiquement.
