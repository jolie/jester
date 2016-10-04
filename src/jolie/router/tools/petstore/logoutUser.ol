include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type logoutUserRequest: void {
}
type logoutUserResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	logoutUser@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}