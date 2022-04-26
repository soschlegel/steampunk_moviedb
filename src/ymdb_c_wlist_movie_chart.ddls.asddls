@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chart for Ratings of Movies'
@UI.chart: [{
 title: 'Distribution of Votes',
 description: 'Line-chart displaying the distribution of ratings',
 chartType: #BAR,
 dimensions: [ 'MovieId' ], -- Reference to one element
 measures: [ 'Rating1', 'Rating2', 'Rating3', 'Rating4', 'Rating5' ]
}]
define view entity YMDB_C_WLIST_MOVIE_CHART as select from YMDB_I_WLIST_MOVIE_CHART {
    @EndUserText.label: 'Quantity of votes'
    @UI.hidden: true
    key MovieId,
    @DefaultAggregation: #SUM
    @EndUserText.label: '1'
    Rating1,
    @DefaultAggregation: #SUM
    @EndUserText.label: '2'
    Rating2,
    @DefaultAggregation: #SUM
    @EndUserText.label: '3'
    Rating3,
    @DefaultAggregation: #SUM
    @EndUserText.label: '4'
    Rating4,
    @DefaultAggregation: #SUM
    @EndUserText.label: '5'
    Rating5
}
