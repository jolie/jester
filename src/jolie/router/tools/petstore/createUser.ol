include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type createUserRequest: void {
.body: undefined
}
type createUserResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	createUser@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}