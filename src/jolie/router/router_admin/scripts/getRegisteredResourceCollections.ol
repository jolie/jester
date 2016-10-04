include "head.iol"
include "file.iol"


main {
  getRegisteredResourceCollections@RouterAdmin(  )( res );
  valueToPrettyString@StringUtils( res )( s );
  println@Console( s )()
}
