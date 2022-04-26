@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Definition Country'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity YMDB_I_COUNTRY_T as select from ymdb_country_t 
association to parent YMDB_I_COUNTRY as _Country on $projection.CountryId = _Country.CountryId
{
    @ObjectModel.text.element: ['CountryName']
    key country_id as CountryId,
    
    @Semantics.language: true
    key language_code as LanguageCode,
    
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    @Semantics.text: true
    country_name as CountryName,
    
    _Country
}
