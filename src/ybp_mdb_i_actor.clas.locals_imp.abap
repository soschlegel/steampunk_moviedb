CLASS lhc_Actor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Actor RESULT result.
    "! This method calculates Age for a given Birthday.
    METHODS calculateage FOR DETERMINE ON SAVE
      IMPORTING keys FOR actor~calculateage.
    "! This method validates that LastName is not empty.
    METHODS validatename FOR VALIDATE ON SAVE
      IMPORTING keys FOR actor~validatename.
    "! This method validates that Birthday is before the system date.
    METHODS validatedate FOR VALIDATE ON SAVE
      IMPORTING keys FOR actor~validatedate.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Actor RESULT result.

ENDCLASS.

CLASS lhc_Actor IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD calculateAge.

    READ ENTITY IN LOCAL MODE ymdb_i_actor
    FIELDS ( Age BirthDay ) WITH CORRESPONDING #( keys )
    RESULT DATA(actors).

    DELETE actors WHERE BirthDay IS INITIAL.

    DATA(curr_date) = cl_abap_context_info=>get_system_date(  ).


    LOOP AT actors INTO DATA(act).

      act-age = act-BirthDay(4) - curr_date(4).
      actors[ ActorId = act-ActorId ]-Age = act-BirthDay(4) - curr_date(4).

      IF act-BirthDay+4(2) > curr_date+4(2) OR ( act-BirthDay+4(2) = curr_date+4(2) AND act-BirthDay+6(2) > curr_date+6(2) ).
        actors[ ActorId = act-ActorId ]-Age = act-age - 1.
      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF ymdb_i_actor IN LOCAL MODE
    ENTITY Actor
        UPDATE
        FIELDS ( Age )
        WITH VALUE #( FOR actor IN actors
                      ( %tky = actor-%tky
                         Age = actor-Age ) )
    REPORTED DATA(update_reported).

  ENDMETHOD.

  METHOD validateName.

    READ ENTITY IN LOCAL MODE ymdb_i_actor FROM VALUE #(
    FOR <root_key> IN keys ( %tky-ActorId = <root_key>-ActorId
                             %control = VALUE #( LastName = if_abap_behv=>mk-on ) ) )
    RESULT DATA(actors).

    LOOP AT actors ASSIGNING FIELD-SYMBOL(<actor>) .
      IF <actor>-LastName IS INITIAL.
        APPEND VALUE #( %tky = <actor>-%tky
                        actorid = <actor>-ActorId ) TO failed-actor.
        APPEND VALUE #( %tky = <actor>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '007'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-LastName = if_abap_behv=>mk-on
                       ) TO reported-actor.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDate.

    READ ENTITY IN LOCAL MODE ymdb_i_actor FROM VALUE #(
    FOR <root_key> IN keys ( %tky-ActorId = <root_key>-ActorId
                             %control = VALUE #( BirthDay = if_abap_behv=>mk-on ) ) )
    RESULT DATA(actors).

    LOOP AT actors ASSIGNING FIELD-SYMBOL(<actor>) .
      IF <actor>-BirthDay > cl_abap_context_info=>get_system_date( ) AND <actor> IS NOT INITIAL.
        APPEND VALUE #( %tky = <actor>-%tky
                        actorid = <actor>-ActorId ) TO failed-actor.
        APPEND VALUE #( %tky = <actor>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '012'
                                            v1 = |{ <actor>-BirthDay DATE = ISO }|
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-BirthDay = if_abap_behv=>mk-on
                       ) TO reported-actor.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

  ENDMETHOD.

ENDCLASS.
