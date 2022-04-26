@EndUserText.label: 'Generic Helperclass'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ymdb_value_help_t
  with parameters
    DomainNameParam : abap.char(30)
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name : $parameters.DomainNameParam )
{
  key domain_name    as DomainName,
  key value_position as ValuePosition,
  key language       as Language,
      value_low      as ValueLow,
      text           as Text
}
