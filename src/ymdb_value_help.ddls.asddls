@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Helperclass'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ymdb_value_help
  with parameters
    DomainNameParam : abap.char(30)
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name : $parameters.DomainNameParam )
  association [0..1] to ymdb_value_help_t as _Text on  _Text.ValuePosition = $projection.ValuePos

{
  key domain_name                                                                          as DomainName,
  key value_position                                                                       as ValuePos,
      value_low,
      value_high,
      coalesce( _Text(DomainNameParam:$parameters.DomainNameParam )[1:Language=$session.system_language ].Text,
                _Text(DomainNameParam:$parameters.DomainNameParam )[1:Language='E'].Text ) as Text
}
