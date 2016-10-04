include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type createUsersWithArrayInputRequest: void {
.body[0,*]:User
}
type createUsersWithArrayInputResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	createUsersWithArrayInput@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}