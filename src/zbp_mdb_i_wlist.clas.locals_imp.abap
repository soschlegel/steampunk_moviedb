CLASS lhc_WList DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR WList~validateRating.
    METHODS validateMovieId FOR VALIDATE ON SAVE
      IMPORTING keys FOR WList~validateMovieId.
    METHODS validateDuplicate FOR VALIDATE ON SAVE
      IMPORTING keys FOR WList~validateDuplicate.
    METHODS numRatings FOR DETERMINE ON SAVE
      IMPORTING keys FOR WList~numRatings.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR WList RESULT result.

    METHODS mark_as_watched FOR MODIFY
      IMPORTING keys FOR ACTION WList~mark_as_watched RESULT result.
    METHODS numRatings_delete FOR DETERMINE ON SAVE
      IMPORTING keys FOR WList~numRatings_delete.
    METHODS validateWatchStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR WList~validateWatchStatus.
    METHODS changeRating FOR MODIFY
      IMPORTING keys FOR ACTION WList~changeRating RESULT result.

ENDCLASS.

CLASS lhc_WList IMPLEMENTATION.

  METHOD validateRating.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist FROM VALUE #(
        FOR <root_key> IN keys ( %tky-WListUuid = <root_key>-WListUuid
                                 %control = VALUE #( Rating = if_abap_behv=>mk-on
                                                     WatchStatus = if_abap_behv=>mk-on ) ) )
        RESULT DATA(wlists).

    LOOP AT wlists ASSIGNING FIELD-SYMBOL(<wlist>) .
      IF ( <wlist>-Rating > 5 OR <wlist>-Rating < 1 ) AND <wlist>-WatchStatus = 'X' AND <wlist>-Rating IS NOT INITIAL.
        APPEND VALUE #( %tky = <wlist>-%tky
                        wlistuuid = <wlist>-WListUuid ) TO failed-wlist.
        APPEND VALUE #( %tky = <wlist>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '001'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-Rating = if_abap_behv=>mk-on
                       ) TO reported-wlist.
      ENDIF.

      IF <wlist>-Rating IS NOT INITIAL AND <wlist>-WatchStatus <> 'X'.
        APPEND VALUE #( %tky = <wlist>-%tky
                        wlistuuid = <wlist>-WListUuid ) TO failed-wlist.
        APPEND VALUE #( %tky = <wlist>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '006'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-Rating = if_abap_behv=>mk-on
                       ) TO reported-wlist.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateMovieId.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist
    FROM VALUE #( FOR <root_key> IN keys ( %tky-WListUuid = <root_key>-WListUuid
                     %control = VALUE #( MovieId = if_abap_behv=>mk-on ) ) )
        RESULT DATA(wlists).

*            LOOP AT wlists ASSIGNING FIELD-SYMBOL(<wlist>) .


    READ ENTITIES OF ymdb_i_movie
    ENTITY Movies
    FIELDS ( MovieId )
    WITH VALUE #( FOR wlist_item IN wlists
                    ( %tky-MovieId = wlist_item-MovieId ) )
    RESULT DATA(existing_movies).

    LOOP AT wlists ASSIGNING FIELD-SYMBOL(<wlist>).

      IF NOT line_exists( existing_movies[ movieid = <wlist>-MovieId ] ).
        APPEND VALUE #( %tky = <wlist>-%tky
                        wlistuuid = <wlist>-WListUuid ) TO failed-wlist.
        APPEND VALUE #( %tky = <wlist>-%tky
                        %msg = new_message( id = 'YMDB_MSG'
                                            number = '003'
                                            severity = if_abap_behv_message=>severity-error
                                            )
                        %element-MovieId = if_abap_behv=>mk-on
                       ) TO reported-wlist.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateDuplicate.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist
        FROM VALUE #( FOR <root_key> IN keys ( %tky-WListUuid = <root_key>-WListUuid
                                               %control = VALUE #( MovieId = if_abap_behv=>mk-on
                                                                   PersonId = if_abap_behv=>mk-on
                                                                   WListUuid = if_abap_behv=>mk-on ) ) )
        RESULT DATA(wlists).

    SELECT FROM ymdb_i_wlist AS org
    FIELDS org~MovieId, org~PersonId, org~WListUuid
    INTO TABLE @DATA(existing_wlists).

*    READ TABLE ymdb_i_wlist INTO existing_wlists.

    LOOP AT wlists INTO DATA(wlist).

      LOOP AT existing_wlists INTO DATA(wlist2).

        IF wlist-MovieId = wlist2-MovieId AND wlist-PersonId = wlist2-PersonId AND wlist-WListUuid <> wlist2-WListUuid.

          APPEND VALUE #( %tky = wlist-%tky
                          wlistuuid = wlist-WListUuid ) TO failed-wlist.
          APPEND VALUE #( %tky = wlist-%tky
                          %msg = new_message( id = 'YMDB_MSG'
                                              number = '005'
                                              severity = if_abap_behv_message=>severity-error
                                              )
                          %element-MovieId = if_abap_behv=>mk-on
                         ) TO reported-wlist.

        ENDIF.

      ENDLOOP.

    ENDLOOP.



  ENDMETHOD.

  METHOD numRatings.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist
    FROM VALUE #( FOR <root_key> IN keys ( %tky-WListUuid = <root_key>-WListUuid
                                           %control = VALUE #( PersonId = if_abap_behv=>mk-on ) ) )
    RESULT DATA(wlist_create).

    SELECT *
    FROM ymdb_i_wlist as exist
    APPENDING corresponding fields of table @wlist_create.

*    data: wlist_ratings type Table of
*
*    select * from ymdb_i_wlist into table @wlist_ratings.
*
*    loop at wlist_ratings into data(element).
*     Append element to wlist_create.
*    Endloop.

    SELECT FROM @wlist_create AS org
    FIELDS COUNT( * ) AS TotalRatings, org~PersonId AS PersonId
    where org~Rating is not initial
    GROUP BY org~PersonId
    INTO TABLE @DATA(existing_wlists).

    MODIFY ENTITIES OF ymdb_i_person IN LOCAL MODE
        ENTITY Person
            UPDATE
            FIELDS ( PersonId TotalRatings )
            WITH CORRESPONDING #( existing_wlists ).


  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist FROM VALUE #(  FOR keyval IN keys (
            %tky = keyval-%tky
            %control-WatchStatus = if_abap_behv=>mk-on ) )
    RESULT DATA(wlists).

    result = VALUE #( FOR wlist IN wlists (
                        %tky = wlist-%tky
                        %features-%action-mark_as_watched = COND #( WHEN wlist-WatchStatus = 'X'
                                                                    THEN if_abap_behv=>fc-o-disabled
                                                                    ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD mark_as_watched.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist FROM VALUE #(  FOR keyval IN keys (
            %tky = keyval-%tky
            %control-WListUuid = if_abap_behv=>mk-on
            %control-PersonId = if_abap_behv=>mk-on
            %control-MovieId = if_abap_behv=>mk-on ) )
    RESULT DATA(wlists_result).

    select from ymdb_i_person as person
    inner join @wlists_result as orig
    On orig~PersonId = person~PersonId
    inner join ymdb_i_movie as movie
    on orig~MovieId = movie~MovieId
    fields orig~WListUuid as WListUuid, movie~pegi as PEGI, person~BirthDay as BirthDay
    into table @data(watching).

    loop at watching into data(lines).
        data(status) = 'X'.
        IF lines-pegi > zcl_calculateage_user=>calc_age( lines-birthday ).
            status = ''.

            APPEND VALUE #(
                %msg = new_message( id = 'YMDB_MSG'
                                    number = '011'
                                    severity = if_abap_behv_message=>severity-error
                                  )
                %element-MovieId = if_abap_behv=>mk-on
                ) TO reported-wlist.
        endif.
    endloop.

    MODIFY ENTITIES OF YMDB_I_PERSON IN LOCAL MODE
        ENTITY WList
            UPDATE FIELDS ( WatchStatus )
            WITH VALUE #( FOR wlist IN wlists_result (
                                %tky = wlist-%tky
                                WatchStatus = status ) )
    REPORTED DATA(lt_reported).

    result = VALUE #( FOR wlist IN wlists_result (
                            %tky = wlist-%tky
                            %param = wlist ) ).

  ENDMETHOD.

  METHOD numRatings_delete.

    select * from ymdb_i_wlist as orig
    into table @DATA(existing_wlist).

    LOOP AT keys into data(keyval).
        delete existing_wlist where WListUuid = keyval-WListUuid.
    Endloop.

    SELECT FROM @existing_wlist AS org
    FIELDS COUNT( * ) AS TotalRatings, org~PersonId AS PersonId
    WHERE org~Rating is not initial
    GROUP BY org~PersonId
    INTO TABLE @DATA(wlists).

    MODIFY ENTITIES OF ymdb_i_person IN LOCAL MODE
        ENTITY Person
            UPDATE
            FIELDS ( PersonId TotalRatings )
            WITH CORRESPONDING #( wlists ).

  ENDMETHOD.

  METHOD validateWatchStatus.

    READ ENTITY IN LOCAL MODE ymdb_i_wlist FROM VALUE #(  FOR keyval IN keys (
            %tky = keyval-%tky
            %control-WListUuid = if_abap_behv=>mk-on
            %control-PersonId = if_abap_behv=>mk-on
            %control-MovieId = if_abap_behv=>mk-on
            %control-WatchStatus = if_abap_behv=>mk-on ) )
    RESULT DATA(wlists_result).

    select from ymdb_i_person as person
    inner join @wlists_result as orig
    On orig~PersonId = person~PersonId
    inner join ymdb_i_movie as movie
    on orig~MovieId = movie~MovieId
    fields orig~WListUuid as WListUuid, movie~pegi as PEGI, person~BirthDay as BirthDay
    into table @data(watching).

     loop at wlists_result into data(wlist).
        loop at watching into data(lines).
            IF lines-wlistuuid = wlist-WListUuid and wlist-WatchStatus = 'X' and lines-pegi > zcl_calculateage_user=>calc_age( lines-birthday ).

                APPEND VALUE #( %tky = wlist-%tky
                    wlistuuid = wlist-WListUuid ) TO failed-wlist.
                APPEND VALUE #( %tky = wlist-%tky
                    %msg = new_message( id = 'YMDB_MSG'
                                              number = '011'
                                              severity = if_abap_behv_message=>severity-error
                                      )
                    %element-MovieId = if_abap_behv=>mk-on
                ) TO reported-wlist.

            endif.
        endloop.
     endloop.

  ENDMETHOD.

  METHOD changeRating.

    DATA : lt_update_doc  TYPE TABLE FOR UPDATE ymdb_i_wlist.
    DATA(lt_keys) = keys.

    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      IF not <fs_key>-%param-rating between 1 and 5.

        APPEND VALUE #( %tky                = <fs_key>-%tky ) TO failed-wlist.

        APPEND VALUE #( %tky                = <fs_key>-%tky
                        %msg                = new_message(  id       = 'YMDB_MSG'
                                                            number   = '001'
                                                            severity = if_abap_behv_message=>severity-error )
                        %element-Rating = if_abap_behv=>mk-on ) TO reported-wlist.

        DELETE lt_keys.


      ELSE.
        DATA(lv_rating) = <fs_key>-%param-rating.
      ENDIF.

    ENDLOOP.

    CHECK lt_keys IS NOT INITIAL.

    READ ENTITIES OF ymdb_i_person IN LOCAL MODE
        ENTITY WList
        FIELDS ( Rating )
        WITH CORRESPONDING #( keys )
        RESULT DATA(wlist_rating).


    CHECK wlist_rating IS NOT INITIAL.

    LOOP AT wlist_rating ASSIGNING FIELD-SYMBOL(<fs_wlist>).

              <fs_wlist>-Rating = lv_rating.

    ENDLOOP.

    MODIFY ENTITIES OF ymdb_i_person IN LOCAL MODE
        ENTITY WList
        UPDATE FIELDS ( Rating )
        WITH CORRESPONDING #( wlist_rating )
    REPORTED DATA(report).

    reported = CORRESPONDING #( DEEP report ).

    " Return result to UI
    READ ENTITIES OF ymdb_i_person IN LOCAL MODE
        ENTITY WList
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT wlist_rating.

    result = VALUE #( FOR <fs_doc_head> IN wlist_rating ( %tky = <fs_doc_head>-%tky
    %param = <fs_doc_head> ) ).

  ENDMETHOD.

ENDCLASS.
