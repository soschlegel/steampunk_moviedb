@EndUserText.label: 'Custom Entity for Movie API'
@ObjectModel.query.implementedBy: 'ABAP:YCL_MDB_CE_MOVIE_DEMO'
@UI: {
    headerInfo: {
        typeName: 'Movie',
        typeNamePlural: 'Movies',
        title: {
            type: #STANDARD,
            label: 'Movies',
            value: 'ImdbID'
        }
    }
}
define root custom entity YMDB_C_MOVIE_DEMO
{
      @UI.facet      : [{
        id           : 'idCollection',
        type         : #COLLECTION,
        label        : 'Movies',
        position     : 10
      }, {
        id           : 'idIdentification',
        parentId     : 'idCollection',
        type         : #IDENTIFICATION_REFERENCE,
        label        : 'General Information',
        position     : 10
      } ]
      @UI.lineItem   : [{
        position     : 10,
        importance   : #HIGH,
        label        : 'Title'
      }]
      @UI.selectionField: [{
        position     : 10
      }]
      @EndUserText.label: 'Title'
  key Title          : abap.strg;
      @UI.lineItem   : [{
        position     : 20,
        importance   : #HIGH,
        label        : 'ImdbID'
      }]
      @UI.identification: [{
        position     : 20,
        label        : 'ImdbID'
      }]
      @EndUserText.label: 'ImdbID'
      ImdbID         : abap.char( 10 );
      @UI.lineItem   : [{
        position     : 30,
        importance   : #HIGH,
        label        : 'PosterUrl'
      }]
      @UI.identification: [{
        position     : 30,
        label        : 'PosterUrl'
      }]
      @EndUserText.label: 'PosterUrl'
      PosterUrl      : abap.char( 50 );
      @UI.lineItem   : [{
        position     : 40,
        importance   : #HIGH,
        label        : 'RealeaseYear'
      }]
      @UI.identification: [{
        position     : 40,
        label        : 'ReleaseYear'
      }]
      @EndUserText.label: 'Release Year'
      ReleaseYear   : abap.char( 4 );
      @UI.lineItem   : [{
        position     : 50,
        importance   : #HIGH
      }]
      @UI.identification: [{
        position     : 50
      }]
      @EndUserText.label: 'Last Access'
      TimeLastAccess : timestamp;
      @UI.lineItem   : [{
        position     : 60,
        importance   : #HIGH,
        label        : 'Type'
      }]
      @UI.identification: [{
        position     : 60,
        label        : 'Type'
      }]
      @EndUserText.label: 'Type'
      Type           : abap.char( 10 );
}
