@EndUserText.label: 'Projection View Person'
@AccessControl.authorizationCheck: #CHECK
@UI: {
    headerInfo: {
    typeName: 'User',
    typeNamePlural: 'Users',
    title: { type: #STANDARD, value:'LastName' },
    description: { value: 'FirstName' }
    }
}

define root view entity YMDB_C_PERSON as projection on YMDB_I_PERSON 
association [0..*] to YMDB_C_WLIST_PERSON_CHART as _Chart on $projection.PersonId = _Chart.PersonId{
  
    key PersonId,
    FirstName,
    LastName,
    BirthDay,
    age,
    BirthDayCriticallity,
    LastChangedAt,
    
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_CALCNUMRATINGS_USER'
          @EndUserText.label: 'Number of Ratings'
          @UI.lineItem: [{ position: 50 }]
          @UI.fieldGroup: [{ qualifier:'tqStatistic', position: 10 }]
          @UI.selectionField: [{ position: 30 }]
    virtual TotalRatings : abap.numc( 5 ),    
    
    @UI.facet: [{
        id : 'idChart',
        type: #CHART_REFERENCE,
        label : 'Chart',
        targetElement: '_Chart',
        position: 40
    }]    
 
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_CALCULATESCORE_USER'
          @EndUserText.label: 'Average Score'
          @UI.fieldGroup: [ { qualifier: 'tqStatistic', position: 20 } ]
          @UI.lineItem:[{type: #AS_DATAPOINT}]
          @UI.dataPoint.visualization: #RATING
          @UI.dataPoint.targetValue: 5
          @UI.dataPoint.title: 'Average Score'
    virtual OverallScore : abap.dec(3,2),
    
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_MDB_MEDIAN_USER'
          @EndUserText.label: 'Median of Votes'
          @UI.fieldGroup: [ { qualifier: 'tqStatistic', position: 30 } ]
    virtual Median     : abap.fltp,
    
    _WList : redirected to composition child YMDB_C_WLIST,
    _Chart
    
}
