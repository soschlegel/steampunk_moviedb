@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Person Table'
@Metadata.allowExtensions: true
define root view entity YMDB_I_PERSON as select from ymdb_person
    composition [0..*] of YMDB_I_WLIST as _WList
    association [0..*] to YMDB_I_WLIST_PERSON_CHART as _Chart on $projection.PersonId = _Chart.PersonId{
    key person_id as PersonId,
    first_name as FirstName,
    last_name as LastName,
    birth_day as BirthDay,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    total_ratings as TotalRatings,
    
    case Substring(birth_day, 5, 4)
    when Substring($session.system_date, 5, 4) then 3
    else 0
    end as BirthDayCriticallity,
    
    case 
    when birth_day is initial
        then 0
    else case
         when Substring($session.system_date, 5, 4) < Substring(birth_day, 5, 4)
            then cast( Substring($session.system_date, 1, 4) as abap.int2) -  cast( Substring(birth_day, 1, 4) as abap.int2) - 1
            else cast( Substring($session.system_date, 1, 4) as abap.int2) - cast( Substring(birth_day, 1, 4) as abap.int2)
         end
    end as age,
    
    _WList,
    _Chart
}
