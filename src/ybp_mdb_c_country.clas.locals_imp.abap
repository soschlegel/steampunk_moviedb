CLASS lhc_Country DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment FOR MODIFY
      IMPORTING entities_create FOR CREATE Country
                entities_update FOR UPDATE Country.

ENDCLASS.

CLASS lhc_Country IMPLEMENTATION.

  METHOD augment.

    DATA: countrytext_for_new_suppl      TYPE TABLE FOR CREATE ymdb_i_country\_Country_t,
          countrytext_for_existing_suppl TYPE TABLE FOR CREATE ymdb_i_country\_Country_t,
          countrytext_update             TYPE TABLE FOR UPDATE ymdb_i_country_t.
    DATA: relates_create TYPE abp_behv_relating_tab,
          relates_update TYPE abp_behv_relating_tab,
          relates_cba    TYPE abp_behv_relating_tab.
    DATA: country_text_tky_link TYPE STRUCTURE FOR READ LINK ymdb_i_country\\Country\_Country_t,
          country_text_tky      LIKE country_text_tky_link-target.

    "Handle create requests including SupplementDescription
    LOOP AT entities_create INTO DATA(country_create).
      "Count Table index for uniquely identifiably %cid on creating supplementtext
      APPEND sy-tabix TO relates_create.

      "Direct the Supplement Create to the corresponding SupplementText Create-By-Association using the current language
      APPEND VALUE #( %cid_ref           = country_create-%cid
                      %key     = country_create-%key
                      %target            = VALUE #( ( %cid              = |CREATETEXTCID{ sy-tabix }|
                                                      languagecode      = sy-langu
                                                      CountryName       = country_create-CountryName
                                                      %control          = VALUE #( languagecode = if_abap_behv=>mk-on
                                                                                   CountryName  = country_create-%control-CountryName )
                                                   ) )
                     ) TO countrytext_for_new_suppl.
    ENDLOOP.

    MODIFY AUGMENTING ENTITIES OF ymdb_i_country
      ENTITY Country
        CREATE BY \_Country_t
        FROM countrytext_for_new_suppl
        RELATING TO entities_create BY relates_create.

    IF entities_update IS NOT INITIAL.

      READ ENTITIES OF ymdb_i_country
        ENTITY Country BY \_Country_t
        FROM CORRESPONDING #( entities_update )
      LINK DATA(link).

      "Handle update requests
      LOOP AT entities_update INTO DATA(country_update).
        DATA(tabix) = sy-tabix.

        "Create variable for %tky for target entity instances
        country_text_tky = CORRESPONDING #( country_update-%tky )  .
        country_text_tky-LanguageCode = sy-langu.

        "If a suppl_text with sy-langu already exists, perform an update. Else perform a create-by-association.
        IF line_exists( link[ source-%tky  = CORRESPONDING #( country_update-%tky )
                              target-%tky  = CORRESPONDING #( country_text_tky ) ] ).

          APPEND tabix TO relates_update.

          APPEND VALUE #( %tky             = country_text_tky
                          %cid_ref         = country_update-%cid_ref
                          CountryName      = country_update-CountryName
                          %control         = VALUE #( CountryName = country_update-%control-CountryName )
                        ) TO countrytext_update.

          "If suppl_text was created in the current LUW, perform an update based on %cid
        ELSEIF line_exists(  countrytext_for_new_suppl[ KEY cid %cid_ref  = country_update-%cid_ref ] ).
          APPEND tabix TO relates_update.

          APPEND VALUE #( %tky             = country_text_tky
                          %cid_ref         = countrytext_for_new_suppl[ %cid_ref  = country_update-%cid_ref ]-%target[ 1 ]-%cid
                          CountryName      = country_update-CountryName
                          %control         = VALUE #( CountryName = country_update-%control-CountryName )
                        ) TO countrytext_update.

          "If suppl_text with sy-langu does not exist yet for corresponding supplement
        ELSE.
          APPEND tabix TO relates_cba.

          "Direct the Supplement Update to the corresponding SupplementText Create-By-Association using the current language
          APPEND VALUE #( %tky     = CORRESPONDING #( country_update-%tky )
                          %cid_ref = country_update-%cid_ref
                          %target  = VALUE #( ( %cid          = |UPDATETEXTCID{ tabix }|
                                                languagecode  = sy-langu
                                                CountryName   = country_update-CountryName
                                                %control      = VALUE #( languagecode = if_abap_behv=>mk-on
                                                                         CountryName   = country_update-%control-CountryName )
                                             ) )
                         ) TO countrytext_for_existing_suppl.
        ENDIF.

      ENDLOOP.
    ENDIF.

    MODIFY AUGMENTING ENTITIES OF ymdb_i_country
      ENTITY Country_t
        UPDATE FROM countrytext_update
        RELATING TO entities_update BY relates_update
      ENTITY Country
        CREATE BY \_Country_t
        FROM countrytext_for_existing_suppl
        RELATING TO entities_update BY relates_cba.

  ENDMETHOD.

ENDCLASS.
