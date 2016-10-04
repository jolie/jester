include "file.iol"
include "runtime.iol"
include "locations.iol"

constants {
  RESOURCE_COLLECTION_FOLDER_NAME = "resource_collections"
}

init {
  exists@File( RESOURCE_COLLECTION_FOLDER_NAME )( exist_resource_folder );
  if ( !exist_resource_folder ) {
      mkdir@File( RESOURCE_COLLECTION_FOLDER_NAME )()
  };
  lrq.directory = RESOURCE_COLLECTION_FOLDER_NAME;
  lrq.regex = ".*\\.ol";
  list@File( lrq )( resource_list );
  __import = "";
  for( i = 0, i < #resource_list.result, i++ ) {
      __import = __import + "include \"" + RESOURCE_COLLECTION_FOLDER_NAME + "/" + resource_list.result[ i ] + "\"\n"
  }
  ;
  file.filename = "__import.iol";
  file.content = __import;
  writeFile@File( file )()
  ;
  exists@File( "dependencies.iol")( dep_exists );
  if ( !dep_exists ) {
      undef( file );
      file.filename = "dependencies.iol";
      file.content = "constants { JDEP_API_ROUTER=\"" + API_ROUTER + "\" }";
      writeFile@File( file )()
  }
}

main {
  f.filepath = "__router.ol";
  f.type = "Jolie";
  loadEmbeddedService@Runtime( f )();

  f.filepath = "./router_admin/router_admin.ol";
  f.type = "Jolie";
  loadEmbeddedService@Runtime( f )();

  copyDir@File( { .from="./webapp/META-INF", .to="./META-INF"})();
  f.filepath = "./webapp/leonardo.ol";
  f.type = "Jolie";
  loadEmbeddedService@Runtime( f )();

  linkIn( dummy )
}
