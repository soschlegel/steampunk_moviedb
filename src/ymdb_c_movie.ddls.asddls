@EndUserText.label: 'Projection View Movies'
@AccessControl.authorizationCheck: #CHECK
@UI.headerInfo : {
    typeName : 'Movie',
    typeNamePlural : 'Movies',
    title : {
    type : #STANDARD , value : 'Title'
    },
    description : {value : 'Category'},
    imageUrl: 'MoviePicURL'
}
define root view entity YMDB_C_MOVIE
  as projection on YMDB_I_MOVIE
   association [0..*] to YMDB_I_WLIST as _WList on $projection.MovieId = _WList.MovieId
   association [0..*] to YMDB_C_ROLE as _Role on $projection.MovieId = _Role.MovieId
   association [0..*] to YMDB_C_WLIST_MOVIE_CHART as _Chart on $projection.MovieId = _Chart.MovieId
{
  
  key     MovieId,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ymdb_c_movie_demo', element: 'Title' } }]
          Title,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ymdb_c_movie_demo', element: 'ReleaseYear' }, 
                                               additionalBinding: [{ element: 'Title', localElement: 'Title' }] }]
          ReleaseDate,
          Runtime,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_CALCULATESCORE_MOVIE'
          @EndUserText.label: 'Overall Score'
          @UI.fieldGroup: [ { qualifier: 'tqStatistic', position: 10 } ]
          @UI.lineItem:[{type: #AS_DATAPOINT}]
          @UI.dataPoint.visualization: #RATING
          @UI.dataPoint.targetValue: 5
          @UI.dataPoint.title: 'OverallScore'
  virtual OverallScore : abap.dec(3,2),

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_NUMVOTES'
          @EndUserText.label: 'Number of Votes'
          @UI.fieldGroup: [ { qualifier: 'tqStatistic', position: 20 } ]
          @UI.lineItem:[{ position: 70 }]
  virtual numVotes     : abap.numc(3),
  
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_MEDIAN'
          @EndUserText.label: 'Median of Votes'
          @UI.fieldGroup: [ { qualifier: 'tqStatistic', position: 30 } ]
  virtual Median     : abap.fltp,

          LastChangedAt,
          Category,
          @EndUserText.label: 'PEGI'
          PEGI,
          LinkToImdb,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ymdb_c_movie_demo', element: 'PosterUrl' }, 
                                               additionalBinding: [{ element: 'Title', localElement: 'Title' }] }]
          @Semantics.imageUrl: true
          MoviePicURL,

          _WList,
          _Role,
          _Chart


}
