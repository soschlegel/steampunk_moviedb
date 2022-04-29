@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'My Movies'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity YMDB_C_MOVIE_MY
  as projection on YMDB_I_MOVIE
{
  key MovieId,
      Title,
      ReleaseDate,
      LastChangedAt,
      Category,
      PEGI,
      LinkToImdb,
      MoviePicURL,
      Runtime,
      _Opinion[1: Uname = $session.user ].Opinion as Opinion

}
