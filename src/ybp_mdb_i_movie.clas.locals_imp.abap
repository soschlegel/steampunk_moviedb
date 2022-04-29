CLASS lhc_movies DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movies~validateDate.
    METHODS validateTitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movies~validateTitle.

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

ENDCLASS.
