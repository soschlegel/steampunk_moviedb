CLASS zcl_sdf_movie_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
             ty_result_set TYPE STANDARD TABLE OF ymdb_s_movie WITH NON-UNIQUE KEY title.

    METHODS:
      constructor
        RAISING
          cx_web_http_client_error
          cx_http_dest_provider_error,
      set_request
        IMPORTING
          io_request TYPE REF TO if_rap_query_request
        RAISING
          cx_rap_query_filter_no_range,
      execute
        RETURNING
          VALUE(r_result) TYPE zcl_sdf_movie_api=>ty_result_set.
  PROTECTED SECTION.
    METHODS:
      execute_request
        IMPORTING
          i_search_string TYPE string.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ts_result,
        search       TYPE ty_result_set,
        totalResults TYPE int4,
      END OF ts_result.

    CONSTANTS:
               base_url TYPE string VALUE 'http://www.omdbapi.com'.

    DATA: http_client      TYPE REF TO if_web_http_client,
          name_mapping     TYPE /ui2/cl_json=>name_mappings,
          filter_condition TYPE if_rap_query_filter=>tt_name_range_pairs,
          filter_string    TYPE string,
          result_set       TYPE ty_result_set.

    METHODS cleanup_result.

ENDCLASS.



CLASS zcl_sdf_movie_api IMPLEMENTATION.

  METHOD constructor.

    http_client = cl_web_http_client_manager=>create_by_http_destination(
      i_destination = cl_http_destination_provider=>create_by_url( base_url ) ).

    INSERT VALUE #( abap = 'IMDB_ID' json = 'imdbID') INTO TABLE name_mapping.
    INSERT VALUE #( abap = 'POSTER_URL' json = 'Poster') INTO TABLE name_mapping.
    INSERT VALUE #( abap = 'RELEASE_YEAR' json = 'Year') INTO TABLE name_mapping.

  ENDMETHOD.

  METHOD execute_request.

    CHECK i_search_string IS NOT INITIAL.

    DATA: result_table TYPE ts_result.

    DATA(request) = http_client->get_http_request( ).

    DATA(uname) = cl_abap_context_info=>get_user_technical_name(  ).

    SELECT SINGLE api_key
    FROM ymdb_config
*    WHERE cur_user = 'X'
    WHERE uname = @uname
    INTO @DATA(api_keys).

    request->set_uri_path(
*      i_uri_path = |{ base_url }/?s={ i_search_string }&apikey={ lif_apikey=>api_key }&type=movie| ).
      i_uri_path = |{ base_url }/?s={ i_search_string }&apikey={ api_keys }&type=movie| ).

    TRY.
        DATA(response) = http_client->execute( i_method = if_web_http_client=>get )->get_text( ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    /ui2/cl_json=>deserialize(
      EXPORTING
        json          = response
        name_mappings = name_mapping
      CHANGING
        data          = result_table
    ).

    APPEND LINES OF result_table-search TO result_set.

  ENDMETHOD.


  METHOD set_request.

    filter_condition = io_request->get_filter( )->get_as_ranges( ).
    filter_string = io_request->get_search_expression( ).

  ENDMETHOD.


  METHOD execute.
    LOOP AT filter_condition ASSIGNING FIELD-SYMBOL(<cond>)
                            WHERE name EQ 'TITLE'.
      LOOP AT <cond>-range ASSIGNING FIELD-SYMBOL(<value>).

        execute_request( i_search_string = <value>-low ).

      ENDLOOP.

    ENDLOOP.

    execute_request( i_search_string = filter_string ).

    cleanup_result( ).

    r_result = result_set.

  ENDMETHOD.


  METHOD cleanup_result.

    SORT result_set BY title.
    DELETE ADJACENT DUPLICATES FROM result_set.

    LOOP AT filter_condition ASSIGNING FIELD-SYMBOL(<cond>).

      CASE <cond>-name.

        WHEN 'TITLE'.

          DELETE result_set WHERE title NOT IN <cond>-range.

        WHEN 'RELEASEYEAR'.

          DELETE result_set WHERE release_year NOT IN <cond>-range.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
