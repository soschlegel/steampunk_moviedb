@EndUserText.label: 'Sign up'
define abstract entity YMDB_A_SIGNUPDIALOGBOX {
    @EndUserText.label: 'New User:'
    user_name : abap.char( 30 );
    @EndUserText.label: 'API KEY:'
    api_key  : abap.char( 20 );
}
