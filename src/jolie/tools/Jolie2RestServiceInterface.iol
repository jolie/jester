type RunJolie2ServiceRequest: void {
  .router_host: string
  .swagger_enable: bool
  .easy_interface: bool
  .wkdir: string
  .service*: void {
    .filename: string
    .input_port: string
  }
}


interface Jolie2RestServiceInterface {
  RequestResponse:
    run( RunJolie2ServiceRequest )( void ) throws DefinitionError( string )
}
