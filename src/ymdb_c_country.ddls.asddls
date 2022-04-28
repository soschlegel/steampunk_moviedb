@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Projection Country'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity YMDB_C_COUNTRY as projection on YMDB_I_COUNTRY {

    @UI.facet: [{
            id: 'idGeneralInfo',
            type: #COLLECTION,
            label: 'Country',
            position: 10 
        }, { 
            id: 'idCountryData',
            parentId: 'idGeneralInfo',
            type: #IDENTIFICATION_REFERENCE,
            label: 'Country Data',
            position: 10
        }]

    @UI.lineItem: [{ position: 0 }]
    @UI.identification: [{ position: 0 }]
    @EndUserText.label: 'Country Code'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_COUNTRY', element: 'CountryThreeLetterISOCode' } }]
    key CountryId,
    @UI.lineItem: [{ position: 10 }]
    @UI.identification: [{ position: 10 }]
    @EndUserText.label: 'Country name'
    _Country_t.CountryName as CountryName : localized,
    
    _Country_t
}
