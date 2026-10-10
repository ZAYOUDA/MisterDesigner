/* Configuration de déploiement de MisterDesigner.
   clientId vide = connexion SharePoint désactivée : l'application reste 100 % locale.

   SharePoint en attente des droits administrateur Entra ID (consentement + autorisation du site).
   Inscription déjà créée « MisterDesigner » :
     ID d'application (client) : 9278a600-f3b4-4915-8da7-8f72ab33be5d
     ID de l'annuaire (locataire) : 01ac8da3-5c95-4ca3-abc9-4c4d93f4d023
   Pour réactiver : recopier ces deux valeurs ci-dessous. */
window.MISTERDESIGNER_CONFIG = {
  sharepoint: {
    clientId: '',   // ID d'application (client)
    tenantId: '',   // ID de l'annuaire (locataire)
    siteUrl: 'https://datatiltfr.sharepoint.com/sites/MisterDesigner'
  }
};
