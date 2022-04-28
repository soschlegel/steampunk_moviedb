@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Importancy search help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity YMDB_IMPORTANCY_VH
  as select from ymdb_value_help( DomainNameParam: 'YMDB_IMPORTANCY')
{
  key DomainName,
  key ValuePos,
      @ObjectModel.text.element: ['Text']
      value_low,
      value_high,
      Text

}
