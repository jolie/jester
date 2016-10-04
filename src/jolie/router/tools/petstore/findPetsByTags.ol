include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type findPetsByTagsRequest: void {
.tags[0,*]:string
}
type findPetsByTagsResponse: void {
	._[0,*]:Pet
}

*/
	with( request ) {
	// fill here the request message
	};
	findPetsByTags@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}