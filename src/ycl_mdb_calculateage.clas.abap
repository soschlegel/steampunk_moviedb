CLASS ycl_mdb_calculateage DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    class-methods calc_age
    importing
        input           type dats
    returning
        value(result)   type i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS ycl_mdb_calculateage IMPLEMENTATION.

  METHOD calc_age.

    IF input is initial.
     result = 0.
    else.

        data curr_date type DATS.
        curr_date = cl_abap_context_info=>get_system_date(  ).

        result = curr_date(4) - input(4).

        IF input+4(2) > curr_date+4(2) OR ( input+4(2) = curr_date+4(2) AND input+6(2) > curr_date+6(2) ).
            result -= 1.
        endif.
    endif.

  ENDMETHOD.

ENDCLASS.
