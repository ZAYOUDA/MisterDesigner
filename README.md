# MisterDesigner

Éditeur de conception pour applications IBM Planning Analytics / TM1 : cubes, axes d'analyse repliables, liens (règles, process TI, feeders, vues), vue matrice Dimensions × Cubes.

## Fonctionnalités

- Cubes typés (Saisie, Hypothèse, Transco, Calcul, Restitution, Paramètre, Source, Fichier plat, Data warehouse) et types personnalisés
- Dimensions repliables par cube, catalogue de dimensions avec surlignage des cubes qui les utilisent
- Liens entre cubes avec repère (R1, F1…), nom du flux (double-clic sur le repère) et description
- Sélection multiple (Maj + clic, Maj + glisser, Ctrl + A) : déplacer, changer le type, ajouter une dimension, aligner, supprimer
- Import d'une matrice Excel « Dims\Cubes » (.xlsx, .csv)
- Import d'un schéma dessiné avec les formes Excel (cubes, encadrés de dimensions, connecteurs, repères F1/R1, légende de couleurs)
- Export HTML autonome (partageable, s'ouvre en lecture, réimportable), export JSON et export PNG haute résolution du schéma
- Plusieurs projets enregistrés dans le navigateur (ouvrir, dupliquer, supprimer), enregistrement automatique, annuler / rétablir
- Thème clair, sombre ou automatique
- Palette et panneau de propriétés masquables, mode « Modèle seul » (Alt+1, Alt+2, Alt+0)

## SharePoint (Microsoft 365)

Quand `public/config.js` contient l'ID client et l'ID de locataire de l'inscription Entra ID « MisterDesigner », un bouton **SharePoint** apparaît : connexion avec le compte Microsoft, navigation dans les dossiers du site, ouverture et enregistrement des modélisations (`.mdesign.json`), envoi automatique des modifications, détection des conflits (eTag), historique des versions, lien de partage `#sp-<id>` qui ouvre directement le modèle pour un collègue ayant accès au dossier.

- Permissions Graph déléguées : `User.Read`, `Sites.Selected` (application autorisée sur le seul site MisterDesigner).
- Les données vont du navigateur à SharePoint ; Vercel ne sert que le code. Aucun secret.
- `config.js` vide : l'application reste entièrement locale.

## Structure

```
public/index.html   application complète (HTML + CSS + JS, sans build)
public/favicon.svg
public/config.js    configuration SharePoint (ID client, ID locataire, site)
public/vendor/      MSAL Browser 3.27.0 (connexion Microsoft), servi localement
vercel.json         sert le dossier public/
```

Dépendances chargées par CDN : SheetJS (lecture Excel), JSZip (lecture des formes Excel) et Google Fonts (IBM Plex).

## Lancer en local

Ouvrir `public/index.html` dans un navigateur, ou :

```
npx serve public
```

## Déploiement Vercel

1. Importer ce dépôt dans Vercel (New Project → Import Git Repository).
2. Framework Preset : **Other**. Aucune commande de build. Le dossier de sortie `public` est défini dans `vercel.json`.
3. Deploy. Chaque push sur la branche principale redéploie automatiquement.
