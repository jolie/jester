include "file.iol"
include "console.iol"
include "string_utils.iol"

include "public/interfaces/RouterAdminInterface.iol"
include "../tools/Jolie2RestServiceInterface.iol"

include "locations.iol"
include "../router/dependencies.iol"

execution{ concurrent }

inputPort RouterAdmin {
  Location: ROUTER_ADMIN
  Protocol: sodep
  Interfaces: RouterAdminInterface
}

constants {
  RESOURCE_COLLECTION_FOLDER_NAME = "resource_collections"
}

outputPort Jolie2RestService {
  Interfaces: Jolie2RestServiceInterface
}

embedded {
  Jolie:
    "../tools/jolie2rest_service.ol" in Jolie2RestService
}

init {
  if ( #args > 0 ) {
    ROUTER_FOLDER = args[0]
  } else {
    ROUTER_FOLDER = "."
  };
  println@Console( "RouterAdmin: Router folder set to " + ROUTER_FOLDER )();
  RESOURCE_COLLECTION_FOLDER = ROUTER_FOLDER + "/" + RESOURCE_COLLECTION_FOLDER_NAME;
  println@Console("RouterAdmin is running...")();
  install( ResourceCollectionNameAlreadyExists => nullProcess )
}

main {

  [ getRegisteredResourceCollections( request )( response ) {
      lrq.directory = RESOURCE_COLLECTION_FOLDER;
      lrq.regex = ".*\\.ol";
      list@File( lrq )( resource_list );
      __import = "";
      for( i = 0, i < #resource_list.result, i++ ) {
          undef( file );
          file.filename = RESOURCE_COLLECTION_FOLDER + "/" + resource_list.result[ i ];
          readFile@File( file )( content );
          split_rq = resource_list.result[ i ];
          split_rq.regex = "\\.";
          split@StringUtils( split_rq )( split_res );
          response.resource_collection[ i ].name = split_res.result[ 0 ];
          split_rq = content;
          split_rq.regex = "init \\{";
          split@StringUtils( split_rq )( split_res );
          response.resource_collection[ i ].surface = split_res.result[ 0 ]
      }
  }]

  [ addResourceCollection( request )( response ) {

      exists@File( RESOURCE_COLLECTION_FOLDER + "/" + request.name + ".ol" )( name_exists );
      if ( name_exists ) {
        throw( ResourceCollectionNameAlreadyExists )
      }
      ;

      wkdir = new;
      mkdir@File( wkdir )();
      FILENAME = "stmp.ol";
      /* creating fake service to be analyzed by the jolie2rest tool */
      file.filename = wkdir + "/" + FILENAME;
      file.content = request.interface + "\n"
                  + "inputPort " + request.name + "{\n"
                  + "Location: \"" + request.location + "\"\n"
                  + "Protocol: sodep\n"
                  + "Interfaces:" + request.interface_name + "\n}\n"
                  + "main { nullProcess }";
      writeFile@File( file )();

      with( j2r ) {
        .router_host = JDEP_API_ROUTER;
        .swagger_enable = true;
        .easy_interface = false;
        .wkdir = "./" + wkdir;
        .service.filename = wkdir + "/" + FILENAME;
        .service.input_port = request.name
      };
      run@Jolie2RestService( j2r )();

      undef( file );
      file.filename = wkdir + "/" + request.name + ".json";
      readFile@File( file )( file.content );
      file.filename = RESOURCE_COLLECTION_FOLDER + "/" + request.name + ".json";
      writeFile@File( file )();

      undef( file );
      file.filename = wkdir + "/router_import.ol";
      readFile@File( file )( file.content );
      file.filename = RESOURCE_COLLECTION_FOLDER + "/" + request.name + ".ol";
      writeFile@File( file )();

      deleteDir@File( wkdir )()
  }]

  [ removeResourceCollection( request )( response ) {
      exists@File( RESOURCE_COLLECTION_FOLDER + "/" + request.name + ".ol" )( name_exists );
      if ( name_exists ) {
          filename = RESOURCE_COLLECTION_FOLDER + "/" + request.name;
          delete@File( filename + ".ol" )();
          delete@File( filename + ".iol" )();
          delete@File( filename + ".json" )()
      } else {
          throw( ResourceCollectionNameDoesNotExist )
      }
  }]
}
