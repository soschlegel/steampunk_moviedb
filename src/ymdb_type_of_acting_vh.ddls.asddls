@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Type of Acting value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity YMDB_TYPE_OF_ACTING_VH
  as select from ymdb_value_help( DomainNameParam: 'YMDB_TYPE_OF_ACTING')
{
  key DomainName,
  key ValuePos,
      @ObjectModel.text.element: ['Text']
      value_low,
      value_high,
      Text

}
