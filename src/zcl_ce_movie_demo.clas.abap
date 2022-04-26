CLASS zcl_ce_movie_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_movie_demo IMPLEMENTATION.
  METHOD if_rap_query_provider~select.

    DATA:
      business_data           TYPE TABLE OF ymdb_c_movie_demo,
      query_result            TYPE zcl_sdf_movie_api=>ty_result_set,
      total_number_of_records TYPE int8.

    DATA(top) = io_request->get_paging( )->get_page_size( ).
    DATA(skip) = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields) = io_request->get_requested_elements( ).
    DATA(sort_orde) = io_request->get_sort_elements( ).
    TRY.
        DATA(query) = NEW zcl_sdf_movie_api( ).

        query->set_request( io_request ).

        query_result = query->execute( ).

        business_data = CORRESPONDING #(
            query_result MAPPING
                ImdbID = imdb_id
                Title = title
                ReleaseYear = release_year
                Type = type
                PosterUrl = poster_url
                TimeLastAccess = time_last_access
        ).

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( total_number_of_records ).
        ENDIF.
        io_response->set_data( business_data ).
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_text( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
