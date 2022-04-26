CLASS lhc_Actor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Actor RESULT result.
    METHODS calculateage FOR DETERMINE ON SAVE
      IMPORTING keys FOR actor~calculateage.
    METHODS validatename FOR VALIDATE ON SAVE
      IMPORTING keys FOR actor~validatename.
    METHODS validatedate FOR VALIDATE ON SAVE
      IMPORTING keys FOR actor~validatedate.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Actor RESULT result.

ENDCLASS.

CLASS lhc_Actor IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD calculateAge.

    READ ENTITIES OF ymdb_i_actor IN LOCAL MODE
        ENTITY Actor
            FIELDS ( Age BirthDay ) WITH CORRESPONDING #( keys )
    RESULT DATA(actors).

    DELETE actors WHERE BirthDay IS INITIAL.

*    CALL FUNCTION "FIMA_DAYS_AND_MONTHS_AND_YEARS".

    data curr_date type DATS.
    curr_date = cl_abap_context_info=>get_system_date(  ).


    LOOP AT actors into data(act).

        act-age = act-BirthDay(4) - curr_date(4).
        actors[ ActorId = act-ActorId ]-Age = act-BirthDay(4) - curr_date(4).

        IF act-BirthDay+4(2) > curr_date+4(2) OR ( act-BirthDay+4(2) = curr_date+4(2) AND act-BirthDay+6(2) > curr_date+6(2) ).
            actors[ ActorId = act-ActorId ]-Age = act-age - 1.
        endif.

    endloop.

    MODIFY ENTITIES OF ymdb_i_actor IN LOCAL MODE
    ENTITY Actor
        UPDATE
        FIELDS ( Age )
        WITH VALUE #( FOR actor IN actors
                      ( %tky         = actor-%tky
*                        Age = substring( val = cl_abap_context_info=>get_system_date( ) off = 0 len = 4 )
*                        Age = substring( val = actor-BirthDay off = 0 len = 4 ) - substring( val = cl_abap_context_info=>get_system_date( ) off = 0 len = 4 )
*                        Age = ( actor-BirthDay - cl_abap_context_info=>get_system_date( ) ) / 365
*                        Age = actor-BirthDay / 365 - cl_abap_context_info=>get_system_date( ) / 365
*                        Age = CALL FUNCTION "FIMA_DAYS_AND_MONTHS_AND_YEARS"
                         Age = actor-Age
) )
    reported DATA(update_reported).

  ENDMETHOD.

  METHOD validateName.

      READ ENTITY IN LOCAL MODE ymdb_i_actor FROM VALUE #(
      FOR <root_key> IN keys ( %tky-ActorId = <root_key>-ActorId
                               %control = VALUE #( LastName = if_abap_behv=>mk-on ) ) )
      RESULT DATA(actors).

      LOOP AT actors assigning field-symbol(<actor>) .
        IF <actor>-LastName is initial.
            append value #( %tky = <actor>-%tky
                            actorid = <actor>-ActorId ) TO failed-actor.
            append value #( %tky = <actor>-%tky
                            %msg = new_message( id = 'YMDB_MSG'
                                                number = '007'
                                                severity = if_abap_behv_message=>severity-error
                                                )
                            %element-LastName = if_abap_behv=>mk-on
                           ) to reported-actor.
        ENDIF.
      ENDLOOP.

  ENDMETHOD.

  METHOD validateDate.

      READ ENTITY IN LOCAL MODE ymdb_i_actor FROM VALUE #(
      FOR <root_key> IN keys ( %tky-ActorId = <root_key>-ActorId
                               %control = VALUE #( BirthDay = if_abap_behv=>mk-on ) ) )
      RESULT DATA(actors).

      LOOP AT actors assigning field-symbol(<actor>) .
        IF <actor>-BirthDay > cl_abap_context_info=>get_system_date( ) and <actor> is not initial.
            append value #( %tky = <actor>-%tky
                            actorid = <actor>-ActorId ) TO failed-actor.
            append value #( %tky = <actor>-%tky
                            %msg = new_message( id = 'YMDB_MSG'
                                                number = '012'
                                                v1 = |{ <actor>-BirthDay DATE = ISO }|
                                                severity = if_abap_behv_message=>severity-error
                                                )
                            %element-BirthDay = if_abap_behv=>mk-on
                           ) to reported-actor.
        ENDIF.
      ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

  ENDMETHOD.

ENDCLASS.
