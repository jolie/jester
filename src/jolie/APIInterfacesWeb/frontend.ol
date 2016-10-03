include "public/interfaces/FrontendInterface.iol"
include "file.iol"
include "console.iol"
include "string_utils.iol"

execution{ concurrent }

inputPort Frontend {
  Location: "local"
  Interfaces: FrontendInterface
}

constants {
  RESOURCE_COLLECTION_FOLDER_NAME = "../router/resource_collections"
}


main {
  [ getInterfaces( request )( response ) {
    lrq.directory = RESOURCE_COLLECTION_FOLDER_NAME;
    lrq.regex = ".*\\.json";
    list@File( lrq )( resource_list );
    __import = "";
    for( i = 0, i < #resource_list.result, i++ ) {
        response.name[ i ] = resource_list.result[ i ]
    }
  }]
}
