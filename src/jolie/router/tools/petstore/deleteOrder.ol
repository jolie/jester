include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type deleteOrderRequest: void {
.orderId:long
}
type deleteOrderResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	deleteOrder@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}