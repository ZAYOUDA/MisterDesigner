/* Configuration de déploiement de MisterDesigner.
   Laisser clientId vide désactive la connexion SharePoint (l'application reste 100 % locale).
   Les deux identifiants viennent de l'inscription Entra ID « MisterDesigner » (page Vue d'ensemble) ; ils ne sont pas secrets. */
window.MISTERDESIGNER_CONFIG = {
  sharepoint: {
    clientId: '',   // ID d'application (client)
    tenantId: '',   // ID de l'annuaire (locataire)
    siteUrl: 'https://datatiltfr.sharepoint.com/sites/MisterDesigner'
  }
};
