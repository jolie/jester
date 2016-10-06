/*
The MIT License (MIT)
Copyright (c) 2016 Claudio Guidi <guidiclaudio@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

include "file.iol"
include "console.iol"
include "string_utils.iol"
include "metajolie.iol"
include "metaparser.iol"

include "public/interfaces/SwaggerDefinitionInterface.iol"
include "public/interfaces/Jolie2SwaggerInterface.iol"

execution{ concurrent }

outputPort Swagger {
  Interfaces: SwaggerDefinitionInterface
}

constants {
  LOG = false
}


embedded {
  Jolie:
    "swagger_definition.ol" in Swagger
}

inputPort Jolie2Swagger {
  Location: "local"
  Protocol: sodep
  Interfaces: Jolie2SwaggerInterface
}

define __analize_rest_annotation {
    /* __annotation */
    undef( __method );
    undef( __template );
    if ( !easyInterface ) {
        __is_rest = false;
        r = __annotation;
        r.regex = ".*@Rest:.*;";
        find@StringUtils( r )( is_rest );
        if ( is_rest == 1 ) {
              __is_rest = true;
              r1 = __annotation;
              r1.regex = "@Rest:(.*);";
              find@StringUtils( r1 )( r2 );
              r3 = r2.group[1];
              r3.regex = ",";
              split@StringUtils( r3 )( r4 );
              for( _p = 0, _p < #r4.result, _p++ ) {
                  trim@StringUtils( r4.result[_p] )( r_result );
                  r_result.regex = "method=";
                  find@StringUtils( r_result )( there_is_method );
                  if ( there_is_method == 1) {
                      split@StringUtils( r_result )( _params );
                      trim@StringUtils( _params.result[1] )( __method )
                  } else {
                      r_result.regex = "template=";
                      find@StringUtils( r_result )( there_is_template );
                      if ( there_is_template == 1) {
                            split@StringUtils( r_result )( _params );
                            trim@StringUtils( _params.result[1] )( __template )
                      }
                  }
              };
              rp = __annotation;
              rp.regex = "@Rest:.*;";
              rp.replacement = "";
              replaceAll@StringUtils( rp )( __documentation )
        }
    } else {
        __method = "post";
        __documentation = __annotation;
        __is_rest = true
    }

}


main {

[ jolie2swagger( request )( response ) {
      easyInterface = false;
      if ( is_defined( request.easyInterface ) ) {
          easyInterface = request.easyInterface
      };
      router_host = request.host;
      service_filename = request.filename;
      service_input_port = request.inputPort;

      with( request_meta ) {
        .filename = service_filename;
        .name.name  = "";
        .name.domain = ""
      };
      getInputPortMetaData@MetaJolie( request_meta )( metadata );

      if ( easyInterface && metadata.input.protocol != "http" && metadata.input.protocol != "https" ) {
          throw( EasyInterfaceModalityNotAllowed )
      }
      ;
      /* creating swagger definition file */
      undef( swagger );
      with( swagger ) {
        with( .info ) {
            .title = service_input_port + " API";
            .description = "";
            .version = ""
        };
        .host = router_host;
        if ( easyInterface ) {
          .basePath = "/"
        } else {
          .basePath = "/" + service_input_port
        };

        /* importing of all the types */
        for( itf = 0, itf < #metadata.input.interfaces, itf++ ) {
            with( .tags[ itf ] ) {
                .name = .description = metadata.input.interfaces[ itf ].name.name
            };
            .definitions[ itf ] << metadata.input.interfaces[ itf ]
        }
      };



      /* selecting the port and the list of the interfaces to be imported */
      for( i = 0, i < #metadata.input, i++ ) {
          if ( metadata.input[ i ].name.name == service_input_port ) {
              output_port_index = #render.output_port;
              path_counter = -1;
              for( int_i = 0, int_i < #metadata.input[ i ].interfaces, int_i++ ) {
                  c_interface -> metadata.input[ i ].interfaces[ int_i ];
                  c_interface_name = c_interface.name.name;
                  for( o = 0, o < #c_interface.operations, o++ ) {
                        oper -> c_interface.operations[ o ];
                        if ( LOG ) { println@Console("Analyzing operation:" + oper.operation_name )() };
                        error_prefix =  "ERROR on port " + service_input_port + ", operation " + oper.operation_name + ":" + "the operation has been declared to be imported as a REST ";
                        if ( !( oper.documentation instanceof void ) ) {
                            __annotation = oper.documentation;
                            __analize_rest_annotation;
                            if ( LOG ) { println@Console("Operation Template:" + __template )() };

                            if ( __is_rest ) {
                                  path_counter++;
                                  with( swagger.paths[ path_counter ].( __method ) ) {
                                        .tags = c_interface_name;
                                        .description = __documentation;
                                        .operationId = oper.operation_name;
                                        .consumes[0] = "application/json";
                                        .produces = "application/json";
                                        with( .responses.( "200" ) ) {
                                              .description = "OK";
                                              tp_resp_count = 0; tp_resp_found = false;
                                              while( !tp_resp_found && tp_resp_count < #c_interface.types ) {
                                                  if ( c_interface.types[ tp_resp_count ].name.name == oper.output.name ) {
                                                      tp_resp_found = true
                                                  } else {
                                                      tp_resp_count++
                                                  }
                                              };
                                              if ( tp_resp_found ) {
                                                  .schema << c_interface.types[ tp_resp_count ]
                                              }
                                        }
                                  };
                                  swagger_params_count = -1;
                                  current_swagger_path -> swagger.paths[ path_counter ].( __method );

                                  /* find request type description */
                                  tp_count = 0; tp_found = false;
                                  while( !tp_found && tp_count < #c_interface.types ) {
                                      if ( c_interface.types[ tp_count ].name.name == oper.input.name ) {
                                          tp_found = true
                                      } else {
                                          tp_count++
                                      }
                                  };
                                  if ( tp_found ) {
                                      current_type -> c_interface.types[ tp_count ];
                                      if ( !is_defined( current_type.root_type.void_type ) ) {
                                            println@Console( error_prefix + "but the root type of the request type is not void" )();
                                            throw( DefinitionError )
                                      }
                                  }
                                  ;

                                  if ( !( __template instanceof void ) ) {
                                        /* check if the params are contained in the request type */
                                        splr =__template;
                                        splr.regex = "/|\\?|=|&";
                                        split@StringUtils( splr )( splres );
                                        undef( par );
                                        found_params = false;
                                        for( pr = 0, pr < #splres.result, pr++ ) {
                                            w = splres.result[ pr ];
                                            w.regex = "\\{(.*)\\}";
                                            find@StringUtils( w )( params );
                                            if ( params == 1 ) {
                                                found_params = true;
                                                par = par + params.group[1] + "," /* string where looking for */
                                            }
                                        }

                                        ;

                                        if ( found_params ) {

                                              /* there are parameters in the template */
                                              error_prefix = error_prefix + "with template " + __template + " ";
                                              if ( !tp_found ) {
                                                    println@Console( error_prefix +  "but the request type does not declare any field")();
                                                    throw( DefinitionError )
                                              } else {
                                                      /* if there are parameters in the template the request type must be analyzed */
                                                      for( sbt = 0, sbt < #current_type.sub_type, sbt++ ) {

                                                          /* casting */
                                                          current_root_type -> current_sbt.type_inline.root_type;

                                                          current_sbt -> current_type.sub_type[ sbt ];
                                                          find_str = par;
                                                          find_str.regex = current_sbt.name;

                                                          find@StringUtils( find_str )( find_str_res );

                                                          swagger_params_count++;
                                                          with( current_swagger_path.parameters[ swagger_params_count ] ) {
                                                              .name = current_sbt.name;
                                                              if ( current_sbt.cardinality.min > 0 ) {
                                                                  .required = true
                                                              };
                                                              if ( find_str_res == 1 ) {
                                                                  if ( is_defined( current_sbt.type_inline ) ) {
                                                                        if ( #current_sbt.type_inline.sub_type > 0 ) {
                                                                            println@Console( error_prefix +  "but the field " + .name + " has a type with subnodes which is not permitted")();
                                                                            throw( DefinitionError )
                                                                        };
                                                                        .in.other = "path";
                                                                        .in.other.type << current_sbt.type_inline;

                                                                        if ( is_defined( current_sbt.type_inline.root_type.type_link ) ) {
                                                                          println@Console( error_prefix +  "but the field " + .name + " cannot reference to another type because it is a path parameter")();
                                                                          throw( DefinitionError )
                                                                        }
                                                                  }

                                                              } else {
                                                                  .in.in_body.schema << current_sbt
                                                              }

                                                          }
                                                      }

                                              }
                                        } else {
                                            /* no parameters in the template
                                               if the method is GET, the request type must be void
                                               if the method is different from GET, the request stype must be declared as a reference
                                            */

                                            /* the root type of the request type must be always void */
                                            if ( !tp_found ) {
                                                if ( oper.input.name != "void" ) {

                                                    println@Console( error_prefix + "0but its request message must be declared as void" )();
                                                    throw( DefinitionError )
                                                }
                                            } else {
                                                /* check if the request type is void */
                                                if ( !current_type.root_type.void_type ) {
                                                    println@Console( error_prefix + "1but its request message must be declared as void" )();
                                                    throw( DefinitionError )
                                                }
                                            };

                                            if ( __method == "get" ) {
                                                  if ( tp_found && #current_type.sub_type > 0 ) {
                                                        println@Console( error_prefix + "2but its request message must be declared as void" )();
                                                        throw( DefinitionError )
                                                  }
                                            } else {
                                                  if ( tp_found ) {
                                                        /* the fields of the request type must be transformed into parameters */
                                                        for( sf = 0, sf < #current_type.sub_type, sf++ ) {
                                                              swagger_params_count++;
                                                              with( current_swagger_path.parameters[ swagger_params_count ] ) {
                                                                  .name = current_type.sub_type[ sf ].name;
                                                                  if ( current_type.sub_type[ sf ].cardinality.min > 0 ) {
                                                                      .required = true
                                                                  };
                                                                  .in.in_body.schema_subType << current_type.sub_type[ sf ]
                                                              }
                                                        }
                                                  }
                                            }

                                        }
                                  } else {
                                        __template = "/" + oper.operation_name;

                                        /* if it is a GET, extract the path params from the request message */
                                        if ( __method == "get" ) {
                                              for( sbt = 0, sbt < #current_type.sub_type, sbt++ ) {
                                                /* casting */
                                                current_root_type -> current_sbt.type_inline.root_type;

                                                current_sbt -> current_type.sub_type[ sbt ];
                                                swagger_params_count++;
                                                with( current_swagger_path.parameters[ swagger_params_count ] ) {
                                                    .name = current_sbt.name;
                                                    if ( current_sbt.cardinality.min > 0 ) {
                                                        .required = true
                                                    };

                                                    if ( is_defined( current_sbt.type_inline ) ) {
                                                          if ( #current_sbt.type_inline.sub_type > 0 ) {
                                                              println@Console( error_prefix +  "but the field " + .name + " has a type with subnodes which is not permitted")();
                                                              throw( DefinitionError )
                                                          };
                                                          .in.other = "path";
                                                          .in.other.type << current_sbt.type_inline;
                                                          if ( is_defined( current_sbt.type_inline.root_type.type_link ) ) {
                                                            println@Console( error_prefix +  "but the field " + .name + " cannot reference to another type because it is a path parameter")();
                                                            throw( DefinitionError )
                                                          }
                                                    } else {
                                                          println@Console( error_prefix +  "but the field " + current_sbt.name + " of request type is not an inline type. REST template for GET method cannot be created!")();
                                                          throw( DefinitionError )
                                                    }
                                                }
                                                ;
                                                __template = __template + "/{" + current_sbt.name + "}"
                                              }
                                        } else {

                                              if ( tp_found ) {
                                                  with( current_swagger_path.parameters ) {
                                                      .in.in_body.schema_type << current_type;
                                                      .name = current_type.name.name;
                                                      .required = true
                                                  }

                                              }
                                        };
                                        if ( LOG ) { println@Console( "Template automatically generated:" + __template )() }
                                  }
                                  ;
                                  swagger.paths[ path_counter ] = __template
                            }
                        }
                  }
              }
          }
      }
      ;
      createSwaggerFile@Swagger( swagger )( response )
    }]

}
