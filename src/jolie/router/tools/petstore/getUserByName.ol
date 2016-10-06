include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type getUserByNameRequest: void {
.username:string
}
type getUserByNameResponse:User

*/
	with( request ) {
	// fill here the request message
	};
	getUserByName@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}