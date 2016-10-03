include "head.iol"
include "file.iol"

main {
  with( rq ) {
      .name = "demo";
      .location = "socket://localhost:8000";
      .interface_name = "DemoInterface"
  };
  readFile@File( { .filename="../../tools/demo/DemoInterface.iol" })( rq.interface );
  addResourceCollection@RouterAdmin( rq )()

}
