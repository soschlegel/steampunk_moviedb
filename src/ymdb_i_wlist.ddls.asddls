@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Definition Watchlist'
@Metadata.allowExtensions: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity YMDB_I_WLIST
  as select from ymdb_wlist
  association        to parent YMDB_I_PERSON as _Person on $projection.PersonId = _Person.PersonId
  association [1..1] to YMDB_I_MOVIE         as _Movie  on $projection.MovieId = _Movie.MovieId
{

  key wlist_uuid   as WListUuid,
      person_id    as PersonId,
      movie_id     as MovieId,     
      rating       as Rating,
      watch_time   as Watchtime,
      watch_status as WatchStatus,
      case watch_status
        when 'X' then 3 -- 'Yes' | 3: green colour
        when ''  then 1 -- 'No'  | 1: red colour
                 else 0 -- ''    | 0: unknown
      end        as WatchStatusCriticallity,   
      division(cast(watch_time as abap.int2), cast(_Movie.Runtime as abap.int2), 2) * 100 as WatchPercent,
      last_changed_at as LastChangedAt,
      
      _Person,
      _Movie
}
