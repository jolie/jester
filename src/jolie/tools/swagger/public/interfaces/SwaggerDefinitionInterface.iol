include "types/role_types.iol"

type ExternalDocs: void {
    .url: string
    .description?: string
}

type Item: void {
    .type: string
    .format?: string
    .items*: Item
    .maximum: int
    .minimum: int
    /* NOT USED FOR Jolie purpouses
    .collectionFormat
    .default
    .exclusiceMaximum
    .exclusiceMinimum
    .maxLength
    .minLength
    .pattern
    .maxItems
    .minItems
    .uniqueItems
    .enum
    .multipleOf
  */
}

type OperationObject: void {
    .tags*: string
    .summary?: string
    .description?: string
    .externalDocs?: ExternalDocs
    .operationId: string
    .consumes*: string
    .produces*: string
    .parameters*: Parameter
    .responses: Responses
}

type Parameter: void {
    .name: string
    .in: void {
        .in_body?: void {  //"body"
            .schema_subType?: SubType   // used when there are more parameters in the body
            .schema_type?: Type         // used when there is one single parameter in the body
        }
        .other?: string {    // "query", "header", "path", "formData"
            .type: Type
            .allowEmptyValue?: bool
        }
    }
    .required?: bool
    .description?: string
}

type Responses: undefined


type CreateSwaggerFileRequest: void {
    .info: void {
        .title: string
        .description?: string
        .termsOfService?: string
        .contact?: void {
            .name?: string
            .url?: string
            .email?: string
        }
        .license?: void {
            .name: string
            .url: string
        }
        .version: string
    }
    .host: string
    .basePath: string
    .schemes*: string
    .consumes*: string
    .produces*: string
    .tags*: void {
        .name: string
        .description?: string
        .externalDocs?: ExternalDocs
    }
    .externalDocs?: ExternalDocs
    .paths*: string {
        .get?: OperationObject
        .post?: OperationObject
        .delete?: OperationObject
        .put?: OperationObject
        /* TODO
        .options?: OperationObject
        .head?: OperationObject
        .patch?: OperationObject
        .parameters?:
        */
    }
    .definitions*: Interface
    /* TODO
      .security?
      .securityDefinitions?
      .defintions?

    */
}

type CreateSwaggerFileResponse: undefined

type GetJolieTypeFromSwaggerParametersRequest: void {
    .definition: undefined
    .name: string
}

type GetJolieTypeFromSwaggerDefinitionRequest: void {
    .name: string
    .definition: undefined
}

type GetJolieDefinitionFromSwaggerObjectRequest: void {
    .definition: undefined
    .indentation: int
}

type GetJolieDefinitionFromSwaggerArrayRequest: void {
    .definition: undefined
    .indentation: int
}

type GetJolieNativeTypeFromSwaggerNativeTypeRequest: void {
    .type: string
    .format?: string
}

interface SwaggerDefinitionInterface {
  RequestResponse:
      createSwaggerFile( CreateSwaggerFileRequest )( CreateSwaggerFileResponse ),
      getJolieTypeFromSwaggerDefinition( GetJolieTypeFromSwaggerDefinitionRequest )( string ),
      getJolieTypeFromSwaggerParameters( GetJolieTypeFromSwaggerParametersRequest )( string ),
      getJolieDefinitionFromSwaggerObject( GetJolieDefinitionFromSwaggerObjectRequest )( string )
        throws DefinitionError,
      getJolieDefinitionFromSwaggerArray( GetJolieDefinitionFromSwaggerArrayRequest )( string ),
      getJolieNativeTypeFromSwaggerNativeType( GetJolieNativeTypeFromSwaggerNativeTypeRequest )( string ),
      getReferenceName( string )( string )

}
