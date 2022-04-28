@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chart for Ratings of User'
@UI.chart: [{
 title: 'Distribution of Votes',
 description: 'Line-chart displaying the distribution of ratings',
 chartType: #BAR,
 dimensions: [ 'PersonId' ],
 measures: [ 'Rating1', 'Rating2', 'Rating3', 'Rating4', 'Rating5' ]
}]
define view entity YMDB_C_WLIST_PERSON_CHART as select from YMDB_I_WLIST_PERSON_CHART {
    @UI.lineItem: [{ position:10 }]
    @UI.hidden: true
    key PersonId,
    @UI.lineItem: [{ position:20 }]
    @DefaultAggregation: #SUM
    @EndUserText.label: '1'
    Rating1,
    @UI.lineItem: [{ position:30 }]
    @DefaultAggregation: #SUM
    @EndUserText.label: '2'
    Rating2,
    @UI.lineItem: [{ position:40 }]
    @DefaultAggregation: #SUM
    @EndUserText.label: '3'
    Rating3,
    @UI.lineItem: [{ position:50 }]
    @DefaultAggregation: #SUM
    @EndUserText.label: '4'
    Rating4,
    @UI.lineItem: [{ position:60 }]
    @DefaultAggregation: #SUM
    @EndUserText.label: '5'
    Rating5
}
