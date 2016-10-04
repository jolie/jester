include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type getInventoryRequest: void {
}
type getInventoryResponse:undefined

*/
	with( request ) {
	// fill here the request message
	};
	getInventory@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}