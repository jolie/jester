include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type addPetRequest: void {
.body: undefined
}
type addPetResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	addPet@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}