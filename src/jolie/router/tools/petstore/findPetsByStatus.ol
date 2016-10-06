include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type findPetsByStatusRequest: void {
.status[0,*]:string
}
type findPetsByStatusResponse: void {
	._[0,*]:Pet
}

*/
	with( request ) {
	// fill here the request message
	};
	findPetsByStatus@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}