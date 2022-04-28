@EndUserText.label: 'Projection View Actor'
@AccessControl.authorizationCheck: #CHECK
@UI.headerInfo : {
    typeName : 'Actor',
    typeNamePlural : 'Actors',
    title : {
    type : #STANDARD , value : 'LastName'
    },
    description: { value: 'FirstName' },
    imageUrl: 'ActorPicURL'
}
define root view entity YMDB_C_ACTOR as projection on YMDB_I_ACTOR {
    key ActorId,
    FirstName,
    LastName,
    BirthDay,
    BirthPlace,
    @ObjectModel.text.element: ['CountryName']
    @UI.textArrangement: #TEXT_ONLY
    @Consumption.valueHelpDefinition: [{ entity:{name: 'YMDB_C_COUNTRY', element: 'CountryId'} }]
    BirthCountryId,
    _Country.CountryName as CountryName : localized,
    Age,
    LinkToImdb,
    @Semantics.imageUrl: true
    @UI.lineItem: [{ importance: #HIGH, position: 05}]
    ActorPicURL,
    LastChangedAt,
    
    _Role : redirected to composition child YMDB_C_ROLE,
    _Country
}
