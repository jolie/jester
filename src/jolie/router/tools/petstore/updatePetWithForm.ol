include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type updatePetWithFormRequest: void {
.petId:long
.name?:string
.status?:string
}
type updatePetWithFormResponse:undefined 

*/
	with( request ) {
	// fill here the request message
	};
	updatePetWithForm@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}