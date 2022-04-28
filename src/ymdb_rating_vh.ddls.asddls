@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Rating value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity YMDB_RATING_VH
  as select from ymdb_value_help( DomainNameParam: 'YMDB_D_RANGE_1TO5')
{
  key DomainName,
  key ValuePos,
      value_low,
      value_high,
      Text

}
