/* Configuration de déploiement de MisterDesigner.
   Laisser clientId vide désactive la connexion SharePoint (l'application reste 100 % locale).
   Les deux identifiants viennent de l'inscription Entra ID « MisterDesigner » (page Vue d'ensemble) ; ils ne sont pas secrets. */
window.MISTERDESIGNER_CONFIG = {
  sharepoint: {
    clientId: '9278a600-f3b4-4915-8da7-8f72ab33be5d',   // ID d'application (client)
    tenantId: '01ac8da3-5c95-4ca3-abc9-4c4d93f4d023',   // ID de l'annuaire (locataire)
    siteUrl: 'https://datatiltfr.sharepoint.com/sites/MisterDesigner'
  }
};
