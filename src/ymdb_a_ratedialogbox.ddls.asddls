@EndUserText.label: 'Dialogbox for the rating'
@Metadata.allowExtensions: true
define abstract entity YMDB_A_RATEDIALOGBOX 
  {
    @Consumption.valueHelpDefinition: [{ entity:{name: 'YMDB_RATING_VH', element: 'value_low'} }]
    rating : ymdb_rating;
    
}
