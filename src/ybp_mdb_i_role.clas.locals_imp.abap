CLASS lhc_role DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateImportancy FOR VALIDATE ON SAVE
      IMPORTING keys FOR Role~validateImportancy.

    METHODS validateTypeofActing FOR VALIDATE ON SAVE
      IMPORTING keys FOR Role~validateTypeofActing.
    METHODS validateMoviId FOR VALIDATE ON SAVE
      IMPORTING keys FOR Role~validateMoviId.
    METHODS validateRoleName FOR VALIDATE ON SAVE
      IMPORTING keys FOR Role~validateRoleName.

ENDCLASS.

CLASS lhc_role IMPLEMENTATION.

  METHOD validateImportancy.

    READ ENTITY IN LOCAL MODE ymdb_i_role FROM VALUE #( FOR key IN keys ( %tky-RoleId = key-RoleId
                                                                          %control = VALUE #( Importancy = if_abap_behv=>mk-on ) ) )
    RESULT DATA(roles).

    LOOP AT roles ASSIGNING FIELD-SYMBOL(<role>).
      IF <role>-Importancy <> 'LEAD' AND <role>-Importancy <> 'SUPPORT' AND <role>-Importancy <> 'BACKGROUND' AND <role>-Importancy IS NOT INITIAL.
        APPEND VALUE #( %tky = <role>-%tky
                        roleid = <role>-RoleId ) TO failed-role.
        APPEND VALUE #( %tky = <role>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '009'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-Importancy = if_abap_behv=>mk-on
                       ) TO reported-role.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateTypeofActing.

    READ ENTITY IN LOCAL MODE ymdb_i_role FROM VALUE #( FOR key IN keys ( %tky-RoleId = key-RoleId
                                                                          %control = VALUE #( TypeofActing = if_abap_behv=>mk-on ) ) )
    RESULT DATA(roles).

    LOOP AT roles ASSIGNING FIELD-SYMBOL(<role>).
      IF <role>-TypeofActing <> 'VOICE' AND <role>-TypeofActing <> 'SCREEN' AND <role>-TypeofActing IS NOT INITIAL.
        APPEND VALUE #( %tky = <role>-%tky
                        roleid = <role>-RoleId ) TO failed-role.
        APPEND VALUE #( %tky = <role>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '008'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-TypeofActing = if_abap_behv=>mk-on
                       ) TO reported-role.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateMoviId.

    READ ENTITY IN LOCAL MODE ymdb_i_role
    FROM VALUE #( FOR <root_key> IN keys ( %tky-RoleId = <root_key>-RoleId
                     %control = VALUE #( MovieId = if_abap_behv=>mk-on ) ) )
        RESULT DATA(roles).

    READ ENTITIES OF ymdb_i_movie
    ENTITY Movies
    FIELDS ( MovieId )
    WITH VALUE #( FOR role_item IN roles
                    ( %tky-MovieId = role_item-MovieId ) )
    RESULT DATA(existing_movies).

    LOOP AT roles ASSIGNING FIELD-SYMBOL(<role>).

      IF NOT line_exists( existing_movies[ movieid = <role>-MovieId ] ).
        APPEND VALUE #( %tky = <role>-%tky
                        roleid = <role>-RoleId ) TO failed-role.
        APPEND VALUE #( %tky = <role>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '003'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-MovieId = if_abap_behv=>mk-on
                       ) TO reported-role.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateRoleName.

    READ ENTITY IN LOCAL MODE ymdb_i_role FROM VALUE #( FOR key IN keys (
                                                            %tky-RoleId = key-RoleId
                                                            %control = VALUE #( RoleName = if_abap_behv=>mk-on ) ) )
    RESULT DATA(roles).

    LOOP AT roles ASSIGNING FIELD-SYMBOL(<role>).

      IF <role>-RoleName IS INITIAL.

        APPEND VALUE #( %tky = <role>-%tky
                        roleid = <role>-RoleId ) TO failed-role.
        APPEND VALUE #( %tky = <role>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '010'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-RoleName = if_abap_behv=>mk-on
                        ) TO reported-role.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
