CLASS lhc_movies DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movies~validateDate.
    METHODS validateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movies~validateTitle.
    METHODS get_features FOR FEATURES
      IMPORTING keys   REQUEST requested_features FOR Movies
      RESULT    result.
*    METHODS signup FOR MODIFY
*      IMPORTING keys FOR ACTION movies~signup.
*    METHODS delete_user FOR MODIFY
*      IMPORTING keys FOR ACTION movies~delete_user.
*    METHODS signin FOR MODIFY
*      IMPORTING keys FOR ACTION movies~signin.
*    METHODS signout FOR MODIFY
*      IMPORTING keys FOR ACTION movies~signout.

ENDCLASS.

CLASS lhc_movies IMPLEMENTATION.

  METHOD validateDate.

    READ ENTITY IN LOCAL MODE ymdb_i_movie FROM VALUE #(
      FOR <root_key> IN keys ( %tky-MovieId = <root_key>-MovieId
                               %control = VALUE #( ReleaseDate = if_abap_behv=>mk-on ) ) )
      RESULT DATA(movies).

    LOOP AT movies ASSIGNING FIELD-SYMBOL(<movie>) .
      IF <movie>-ReleaseDate > cl_abap_context_info=>get_system_date( ) AND <movie> IS NOT INITIAL.
        APPEND VALUE #( %tky = <movie>-%tky
                        movieid = <movie>-MovieId ) TO failed-movies.
        APPEND VALUE #( %tky = <movie>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '002'
                                            v1 = |{ <movie>-ReleaseDate DATE = ISO }|
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-ReleaseDate = if_abap_behv=>mk-on
                       ) TO reported-movies.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateTitle.

    READ ENTITY IN LOCAL MODE ymdb_i_movie FROM VALUE #(
    FOR <root_key> IN keys ( %tky-MovieId = <root_key>-MovieId
                             %control = VALUE #( Title = if_abap_behv=>mk-on ) ) )
    RESULT DATA(movies).

    LOOP AT movies ASSIGNING FIELD-SYMBOL(<movie>) .
      IF <movie>-Title IS INITIAL.
        APPEND VALUE #( %tky = <movie>-%tky
                        movieid = <movie>-MovieId ) TO failed-movies.
        APPEND VALUE #( %tky = <movie>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '004'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-ReleaseDate = if_abap_behv=>mk-on
                       ) TO reported-movies.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

  ENDMETHOD.

*  METHOD signup.
*
*    TYPES: BEGIN OF config,
*             user_name TYPE c LENGTH 30,
*             api_key   TYPE c LENGTH 20,
*           END OF config.
*
*    DATA: config TYPE config.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
*
**        IF <fs_key>-%param-api_key IS INITIAL or <fs_key>-%param-user_name IS INITIAL.
**
**            APPEND VALUE #( %tky                = <fs_key>-%tky ) TO failed-movies.
**
**            APPEND VALUE #( %tky                = <fs_key>-%tky
**                            %msg                = new_message(  id       = 'YMDB_MSG'
**                                                                number   = '013'
**                                                                severity = if_abap_behv_message=>severity-error )
**                            %element-MovieId = if_abap_behv=>mk-on ) TO reported-movies.
**
**        ELSE.
*
*      DATA(user_name) = <fs_key>-%param-user_name.
*      DATA(api_key) = <fs_key>-%param-api_key.
*
**        ENDIF.
*
*    ENDLOOP.
*
*    CHECK keys IS NOT INITIAL.
*
*    config-user_name = user_name.
*    config-api_key = api_key.
*
*    INSERT ymdb_config FROM @config.
*
*    DELETE FROM ymdb_cur_user.
*
*    INSERT ymdb_cur_user FROM @user_name.
*
*  endmethod.
*
*    METHOD delete_user.
*
*      CHECK keys IS NOT INITIAL.
*
*      LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
*
*        DATA(user_name) = <fs_key>-%param-user_name.
*
*      ENDLOOP.
*
*      DELETE FROM ymdb_config WHERE user_name EQ @user_name.
*      DELETE FROM ymdb_cur_user.
*      user_name = ''.
*      INSERT INTO ymdb_cur_user VALUES @user_name .
*
*    ENDMETHOD.
*
*  METHOD signin.
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
*
*        DATA(user_name) = <fs_key>-%param-user_name.
*
*    ENDLOOP.
*
*    CHECK keys IS NOT INITIAL.
*
*    DELETE FROM ymdb_cur_user.
*
*    INSERT ymdb_cur_user FROM @user_name.
*
*  ENDMETHOD.
*
*  METHOD signout.
*
*      DELETE FROM ymdb_cur_user.
*      DATA: user_name TYPE C LENGTH 30.
*      INSERT INTO ymdb_cur_user VALUES @user_name .
*
*  ENDMETHOD.

ENDCLASS.
