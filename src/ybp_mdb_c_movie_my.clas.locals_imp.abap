CLASS lhc_YMDB_C_MOVIE_MY DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_update FOR MODIFY
      IMPORTING movie_updates FOR UPDATE ymdb_c_movie_my.

ENDCLASS.

CLASS lhc_YMDB_C_MOVIE_MY IMPLEMENTATION.

  METHOD augment_update.

    DATA: Opinion_read   TYPE TABLE FOR READ IMPORT ymdb_i_movie\\Opinion,
          opinion_cba    TYPE TABLE FOR CREATE ymdb_i_movie\_Opinion,
          opinion_update TYPE TABLE FOR UPDATE ymdb_i_movie\\Opinion,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.

    LOOP AT movie_updates  INTO DATA(movie_update).

      DATA(tabix) = sy-tabix.

      DATA(uname) = cl_abap_context_info=>get_user_technical_name( ).

      opinion_read = VALUE #( ( MovieId = movie_update-MovieId
                                Uname   = uname ) ).

      READ ENTITIES OF ymdb_i_movie
        ENTITY Opinion
        ALL FIELDS
        WITH opinion_read
        RESULT DATA(result_read)
        FAILED DATA(failed_read).

      IF result_read IS INITIAL.

        APPEND tabix TO relates_cba.

        APPEND VALUE #( %tky = CORRESPONDING #( movie_update-%tky )
                        %cid_ref = movie_update-%cid_ref
                        %target = VALUE #( ( %cid = |UPDATETEXTCID{ tabix }|
                                              movieid = movie_update-MovieId
                                              uname   = uname
                                             opinion = movie_update-Opinion
                                             %control = VALUE #( uname = if_abap_behv=>mk-on
                                                                opinion = movie_update-%control-Opinion ) ) )
                      ) TO opinion_cba.
      ELSE.
        DATA(opinion) = result_read[ 1 ].

        APPEND tabix TO relates_update.
*
        APPEND VALUE #( %tky = opinion-%key
                        %cid_ref = movie_update-%cid_ref
                        opinion = movie_update-Opinion
                        %control = VALUE #( opinion = movie_update-%control-Opinion )
                      ) TO opinion_update.
      ENDIF.

      CLEAR: failed_read, result_read.

    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF ymdb_i_movie
      ENTITY Opinion
        UPDATE FROM opinion_update
        RELATING TO movie_updates BY relates_update
      ENTITY Movies
        CREATE BY \_opinion
        FROM opinion_cba
        RELATING TO movie_updates BY relates_cba.



  ENDMETHOD.

ENDCLASS.
