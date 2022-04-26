CLASS zcl_calculateage_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    class-methods calc_age
    importing
        input           type dats
    returning
        value(result)   type i.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_calculateage_user IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA lt_original_data TYPE STANDARD TABLE OF ymdb_c_person WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

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
