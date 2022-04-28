@EndUserText.label: 'Projection View Role'
@AccessControl.authorizationCheck: #CHECK
@UI: {
    headerInfo: {
    typeName: 'Role',
    typeNamePlural: 'Roles',
    title: { type: #STANDARD, value:'RoleName' },
    description: { value: 'Title' }
    }
}
define view entity YMDB_C_ROLE as projection on YMDB_I_ROLE {
    key RoleId,
    @UI.hidden: true
    ActorId,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ymdb_c_movie', element: 'MovieId'} }]
    MovieId,
    _Movie.Title,
    RoleName,
    ActorName,
    @ObjectModel.text.element: ['TextImportancy']
    @UI.textArrangement: #TEXT_ONLY
    Importancy,
    _Importancy.Text as TextImportancy,
    @ObjectModel.text.element: ['TextTypeofActing']
    @UI.textArrangement: #TEXT_ONLY
    TypeofActing,
    _TypeofActing.Text as TextTypeofActing,
    LastChangedAt,
    /* Associations */
    _Actor : redirected to parent YMDB_C_ACTOR,
    _Movie,
    _Importancy,
    _TypeofActing
}
