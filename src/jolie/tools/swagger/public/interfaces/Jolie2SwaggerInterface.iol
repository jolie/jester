type Jolie2SwaggerRequest: void {
  .filename: string
  .host: string
  .inputPort: string
  .easyInterface?: bool
}

interface Jolie2SwaggerInterface {
RequestResponse:
  jolie2swagger( Jolie2SwaggerRequest )( string ) throws EasyInterfaceModalityNotAllowed
}
