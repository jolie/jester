
type GetInterfacesResponse: void {
    .name*: string
}

interface FrontendInterface {
  RequestResponse:
    getInterfaces( void )( GetInterfacesResponse )
}
