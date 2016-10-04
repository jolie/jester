include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type updateUserRequest: void {
.username:string
.body: undefined
}
type updateUserResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	updateUser@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}