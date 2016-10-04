include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type deletePetRequest: void {
.api_key?:string
.petId:long
}
type deletePetResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	deletePet@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}