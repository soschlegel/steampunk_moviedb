@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chart for Ratings of User'

define view entity YMDB_I_WLIST_MOVIE_CHART as select from ymdb_wlist {
    key movie_id as MovieId,
    sum( case rating when '1' then 1 else 0 end) as Rating1,
    sum( case rating when '2' then 1 else 0 end) as Rating2,
    sum( case rating when '3' then 1 else 0 end) as Rating3,
    sum( case rating when '4' then 1 else 0 end) as Rating4,
    sum( case rating when '5' then 1 else 0 end) as Rating5
}
group by movie_id
