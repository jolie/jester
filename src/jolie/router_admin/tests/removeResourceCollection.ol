include "head.iol"
include "file.iol"

main {
  with( rq ) {
      .name = "demo2"
  };
  removeResourceCollection@RouterAdmin( rq )()

}
