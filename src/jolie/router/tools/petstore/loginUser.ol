include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type loginUserRequest: void {
.username:string
.password:string
}
type loginUserResponse:string

*/
	with( request ) {
	// fill here the request message
	};
	loginUser@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}