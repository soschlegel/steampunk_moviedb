CLASS lhc_person DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateName FOR VALIDATE ON SAVE
      IMPORTING keys FOR Person~validateName.
    METHODS validateBirtDay FOR VALIDATE ON SAVE
      IMPORTING keys FOR Person~validateBirtDay.
    METHODS get_features FOR FEATURES
      IMPORTING keys   REQUEST requested_features FOR Person
      RESULT    result.

ENDCLASS.

CLASS lhc_person IMPLEMENTATION.

  METHOD validateName.

    READ ENTITY IN LOCAL MODE ymdb_i_person FROM VALUE #(
    FOR <root_key> IN keys ( %tky-PersonId = <root_key>-PersonId
                             %control = VALUE #( LastName = if_abap_behv=>mk-on ) ) )
    RESULT DATA(persons).

    LOOP AT persons ASSIGNING FIELD-SYMBOL(<person>) .
      IF <person>-LastName IS INITIAL.
        APPEND VALUE #( %tky = <person>-%tky
                        personid = <person>-PersonId ) TO failed-person.
        APPEND VALUE #( %tky = <person>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '007'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-LastName = if_abap_behv=>mk-on
                       ) TO reported-person.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateBirtDay.

    READ ENTITY IN LOCAL MODE ymdb_i_person FROM VALUE #(
    FOR <root_key> IN keys ( %tky-PersonId = <root_key>-PersonId
                             %control = VALUE #( BirthDay = if_abap_behv=>mk-on ) ) )
    RESULT DATA(persons).

    LOOP AT persons ASSIGNING FIELD-SYMBOL(<person>) .
      IF <person>-BirthDay > cl_abap_context_info=>get_system_date( ) AND <person> IS NOT INITIAL.
        APPEND VALUE #( %tky = <person>-%tky
                        personid = <person>-PersonId ) TO failed-person.
        APPEND VALUE #( %tky = <person>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '012'
                                            v1 = |{ <person>-BirthDay DATE = ISO }|
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-BirthDay = if_abap_behv=>mk-on
                       ) TO reported-person.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

  ENDMETHOD.

ENDCLASS.
