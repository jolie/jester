include "console.iol"
include "string_utils.iol"
include "../public/interfaces/RouterAdminInterface.iol"

include "../locations.iol"

outputPort RouterAdmin {
  Location: ROUTER_ADMIN
  Protocol: sodep
  Interfaces: RouterAdminInterface
}
