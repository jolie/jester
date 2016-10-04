include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type updatePetRequest: void {
.body: undefined
}
type updatePetResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	updatePet@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}