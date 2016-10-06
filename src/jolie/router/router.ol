/*
The MIT License (MIT)
Copyright (c) 2016 Claudio Guidi <guidiclaudio@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

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
