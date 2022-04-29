@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Opinion about the Movie'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ymdb_i_Movie_Opinion
  as select from ymdb_movie_opn
  association to parent YMDB_I_MOVIE as _Movie on $projection.MovieId = _Movie.MovieId
{
  key movie_id        as MovieId,
  key uname           as Uname,
      opinion         as Opinion,
      @Semantics.systemDateTime.lastChangedAt: true

      last_changed_at as LastChangedAt,
      _Movie

}
