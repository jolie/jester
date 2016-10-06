include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type placeOrderRequest: void {
.body: undefined
}
type placeOrderResponse:Order

*/
	with( request ) {
	// fill here the request message
	};
	placeOrder@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}