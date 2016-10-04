include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type getOrderByIdRequest: void {
.orderId:long
}
type getOrderByIdResponse:Order

*/
	with( request ) {
	// fill here the request message
	};
	getOrderById@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}