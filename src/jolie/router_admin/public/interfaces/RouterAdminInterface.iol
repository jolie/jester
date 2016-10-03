
type Route: void {
  .method: string
  .template: string
  .operation: string
}

type AddResourceCollectionRequest: void {
  .name: string
  .location: string
  .interface: string
  .interface_name: string
}

type GetRegisteredResourceCollectionsResponse: void {
  .resource_collection*: void {
      .name: string
      .surface: string
  }
}

type RemoveResourceCollectionRequest: void {
  .name: string
}


interface RouterAdminInterface {
  RequestResponse:

    getRegisteredResourceCollections( void )( GetRegisteredResourceCollectionsResponse ),

    /*
      It adds a new collection resource to the router. The router must be restarted
    */
    addResourceCollection( AddResourceCollectionRequest )( void )
      throws ResourceCollectionNameAlreadyExists DefinitionError( string ),

    removeResourceCollection( RemoveResourceCollectionRequest )( void )
      throws ResourceCollectionNameDoesNotExist
}
