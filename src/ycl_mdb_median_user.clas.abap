CLASS ycl_mdb_median_user DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_mdb_median_user IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_original_data TYPE STANDARD TABLE OF ymdb_c_person WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT it_requested_calc_elements INTO DATA(calc_elem).

      IF calc_elem EQ 'MEDIAN'.


        SELECT FROM ymdb_i_wlist AS wlist
        INNER JOIN @lt_original_data AS orig
        ON wlist~PersonId EQ orig~PersonId
        FIELDS MEDIAN( CAST( rating AS fltp ) )  AS median,
        wlist~PersonId
        WHERE wlist~Rating <> 0
        GROUP BY wlist~PersonId
        INTO TABLE @DATA(user_score).



        LOOP AT lt_original_data REFERENCE INTO DATA(orig).

          orig->Median = VALUE #( user_score[ PersonId = orig->PersonId ]-median OPTIONAL ).

        ENDLOOP.
      ENDIF.

    ENDLOOP.


    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

ENDCLASS.
