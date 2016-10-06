include "console.iol"
include "string_utils.iol"
include "outputPort.iol"

main {
/*
type uploadFileRequest: void {
.petId:long
.additionalMetadata?:string
.file?:raw
}
type uploadFileResponse:ApiResponse

*/
	with( request ) {
	// fill here the request message
	};
	uploadFile@petstorePort( request )( response );
	valueToPrettyString@StringUtils( response )( s );
	println@Console( s )()
}