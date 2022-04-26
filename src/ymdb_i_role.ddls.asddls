//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Definition Role'
@Metadata.allowExtensions: true
define view entity YMDB_I_ROLE as select from ymdb_role as Role
association to parent YMDB_I_ACTOR as _Actor
    on $projection.ActorId = _Actor.ActorId 
association [1] to YMDB_I_MOVIE as _Movie 
    on $projection.MovieId = _Movie.MovieId
association [0..1] to YMDB_IMPORTANCY_VH as _Importancy
    on $projection.Importancy = _Importancy.value_low
association [0..1] to YMDB_TYPE_OF_ACTING_VH as _TypeofActing
    on $projection.TypeofActing = _TypeofActing.value_low{
    
    key role_id as RoleId,
    actor_id as ActorId,
    movie_id as MovieId,
    role_name as RoleName,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'YMDB_IMPORTANCY_VH', element: 'value_low'} }]
    importancy as Importancy,
    @Consumption.valueHelpDefinition: [{ entity:{name: 'YMDB_TYPE_OF_ACTING_VH', element: 'value_low'} }]
    type_of_acting as TypeofActing,
    concat_with_space(_Actor.FirstName, _Actor.LastName, 1) as ActorName,
    last_changed_at as LastChangedAt,
    
    _Actor,
    _Movie,
    _Importancy,
    _TypeofActing
}
