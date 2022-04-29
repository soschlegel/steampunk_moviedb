@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Movies CDS'
@Metadata.allowExtensions: true
define root view entity YMDB_I_MOVIE
  as select from ymdb_movie as Movies
  composition [0..*] of ymdb_i_Movie_Opinion     as _Opinion
  association [0..*] to YMDB_I_WLIST             as _WList on $projection.MovieId = _WList.MovieId
  association [0..*] to YMDB_I_ROLE              as _Role  on $projection.MovieId = _Role.MovieId
  association [0..*] to YMDB_I_WLIST_MOVIE_CHART as _Chart on $projection.MovieId = _Chart.MovieId
{

      @EndUserText.label: 'Movie ID'
  key movie_id        as MovieId,
      title           as Title,
      release_date    as ReleaseDate,
      @EndUserText.label: 'Last Changed'
      last_changed_at as LastChangedAt,
      category        as Category,
      pegi            as PEGI,
      link_to_imdb    as LinkToImdb,
      @Semantics.imageUrl: true
      movie_pic_url   as MoviePicURL,
      run_time        as Runtime,

      _WList,
      _Role,
      _Chart,
      _Opinion

}
