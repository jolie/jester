include "head.iol"
include "file.iol"

main {
  with( rq ) {
      .name = "demo"
  };
  removeResourceCollection@RouterAdmin( rq )()

}
