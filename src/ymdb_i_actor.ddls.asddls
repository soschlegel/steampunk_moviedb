@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Definition Actor'
@Metadata.allowExtensions: true
define root view entity YMDB_I_ACTOR as select from ymdb_actor as Actor
 composition [0..*] of YMDB_I_ROLE as _Role
 association [1..*] to YMDB_I_COUNTRY_T as _Country on $projection.BirthCountryId = _Country.CountryId 
 {
    
    key actor_id as ActorId,
    first_name as FirstName,
    last_name as LastName,
    birth_day as BirthDay,
    birth_place as BirthPlace,
    birth_country_id as BirthCountryId,
    age as Age,
    link_to_imdb as LinkToImdb,
    @Semantics.imageUrl: true
    actor_pic_url as ActorPicURL,
    last_changed_at as LastChangedAt,
    
    _Role,
    _Country
}
