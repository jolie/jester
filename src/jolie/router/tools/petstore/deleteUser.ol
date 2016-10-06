include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type deleteUserRequest: void {
.username:string
}
type deleteUserResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	deleteUser@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}