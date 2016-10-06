include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type createUsersWithListInputRequest: void {
.body[0,*]:User
}
type createUsersWithListInputResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	createUsersWithListInput@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}