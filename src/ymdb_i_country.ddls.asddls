@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Definition Country'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity YMDB_I_COUNTRY as select from ymdb_country 
composition [0..*] of YMDB_I_COUNTRY_T as _Country_t
{
    key country_id as CountryId,
    
    _Country_t
}
