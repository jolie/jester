include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type getPetByIdRequest: void {
.petId:long
}
type getPetByIdResponse:Pet

*/
	with( request ) {
	// fill here the request message
	};
	getPetById@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}