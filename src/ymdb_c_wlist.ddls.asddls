@EndUserText.label: 'Projection View Watchlist'
@AccessControl.authorizationCheck: #CHECK
@UI.headerInfo : {
    typeName : 'Movie',
    typeNamePlural : 'Entries',
    title : {
    type : #STANDARD , value : 'Title'
    },
    description : {value : 'Category'},
    imageUrl: 'Pic'
}

@UI.chart: [
  {
    title: 'Product Width Specification',
    description: 'No navigation with qualifier',
    chartType: #DONUT,
    measures: [
      'WatchPercent'
    ],
    measureAttributes: [
      {
        measure: 'WatchPercent',
//        role: #AXIS_1,
        asDataPoint: true
      }
    ],
    qualifier: 'SpecificationWidthRadialChart'
  }
]

define view entity YMDB_C_WLIST
  as projection on YMDB_I_WLIST
//  association [1..1] to YMDB_C_MOVIE         as _Movie  on $projection.MovieId = _Movie.MovieId
{
  key WListUuid,
      PersonId,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ymdb_c_movie', element: 'MovieId'} }]
      MovieId,
      @UI.selectionField: [{position: 0 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'YMDB_C_MOVIE', element: 'Title'  } }]
      _Movie.Title       as Title,
      @UI.selectionField: [{position: 2 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'YMDB_C_MOVIE', element: 'Category'  } }]
      _Movie.Category    as Category,
      @UI.selectionField: [{position: 4 }]
      _Movie.ReleaseDate as ReleaseDate,
      Rating,        
      @UI.lineItem: [{ position: 55,
                   type: #AS_CHART,
                   valueQualifier: 'SpecificationWidthRadialChart',
                   label: 'Progress' }]
      @UI.dataPoint.maximumValue: 100
      WatchPercent,
      @EndUserText.label: 'Watchtime'
      @UI.fieldGroup: [{ qualifier: 'tqMyData', position: 15 }]
      Watchtime,
      WatchStatus,
      WatchStatusCriticallity,
      LastChangedAt,
      @UI.hidden: true
      _Movie.MoviePicURL as Pic,
      /* Associations */
      _Person : redirected to parent YMDB_C_PERSON,
      _Movie
}
