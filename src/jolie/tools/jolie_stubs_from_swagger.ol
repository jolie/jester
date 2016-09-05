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

include "console.iol"
include "string_utils.iol"
include "file.iol"
include "json_utils.iol"

include "swagger/public/interfaces/SwaggerDefinitionInterface.iol"


outputPort SwaggerDefinition {
    Interfaces: SwaggerDefinitionInterface
}

outputPort HTTP {
  Protocol: http {
      .method = "get";
      .osc.getDefinition.alias -> alias
  }
  RequestResponse: getDefinition
}

outputPort HTTPS {
  Protocol: https {
      .method = "get";
      .osc.getDefinition.alias -> alias
  }
  RequestResponse: getDefinition
}

embedded {
  Jolie:
    "swagger/swagger_definition.ol" in SwaggerDefinition
}


main {
    if ( #args != 3 ) {
        println@Console("Usage: jolie_stubs_from_swagger.ol url service_name output_folder")();
        throw( Error )
    }
    ;
    output_folder = args[ 2 ];

    exists@File( output_folder )( exists_folder );
    if ( !exists_folder ) {
          println@Console( "Output folder " + output_folder + " does not exist. Error!")();
          throw( Error )
    };

    service_name = args[ 1 ];
    /*file.filename = args[ 0 ];
    readFile@File( file )( input_swagger );*/
    url = spl = args[0];
    spl.regex = ":";
    split@StringUtils( spl )( protocol_split );
    protocol = protocol_split.result[0];
    if ( protocol == "http" ) {
      protocol_port = "80"
    } else if ( protocol == "https" ) {
      protocol_port = "443"
    } else {
      println@Console("Protocol not supported:" + protocol.result[0] )();
      throw( Error )
    };


    url.replacement = "socket";
    url.regex = protocol;
    replaceAll@StringUtils( url )( location );
    if ( #protocol_split.result == 2 ) {
        /* add default port number */
        spl.regex = "/";
        split@StringUtils( spl )( splitted_url );
        location = ""; alias = "";
        for( sp = 0, sp < #splitted_url.result, sp++ ) {
            if ( sp < 3 ) {
                location = location + splitted_url.result[sp];
                if ( sp == 2 ) {
                  location = location + ":" + protocol_port
                } else {
                  location = location + "/"
                }
            } else {
                alias = alias + splitted_url.result[sp];
                if ( sp < (#splitted_url.result - 1) ) {
                    alias = alias + "/"
                }
            }
        }
    };
    location.replacement = "socket";
    location.regex = protocol;
    replaceAll@StringUtils( location )( location );
    if ( protocol == "http" ) {

      HTTP.location = location;
      getDefinition@HTTP()( swagger )
    } else if ( protocol == "https" ) {
      HTTPS.location = location;
      getDefinition@HTTPS()( swagger )
    };

    spl = swagger.host;
    spl.regex = ":";
    split@StringUtils( spl )( ports );
    if ( #ports.result == 1 ) {
        swagger.host = swagger.host + ":" + protocol_port
    };

    /* creating outputPort */
    outputPort.name = service_name + "Port";
    outputPort.location = "socket://" + swagger.host + swagger.basePath;
    outputPort.protocol = protocol;
    outputPort.interface = service_name + "Interface";

    foreach( path : swagger.paths ) {
        foreach( method : swagger.paths.( path ) ) {
            if ( !is_defined( swagger.paths.( path ).( method ).operationId ) ) {
                println@Console( "Path " + path + " does not define an operationId, please insert an operationId for this path.")();
                print@Console(">")();
                in( operationId )
            } else {
                operationId = swagger.paths.( path ).( method ).operationId
            }
            ;
            op_max = #outputPort.interface.operation;
            spl = path;
            spl.replacement = "%!\\{";
            spl.regex = "\\{";
            replaceAll@StringUtils( spl )( corrected_path );

            outputPort.interface.operation[ op_max ] = operationId;
            outputPort.interface.operation[ op_max ].path = corrected_path;
            outputPort.interface.operation[ op_max ].method = method;
            outputPort.interface.operation[ op_max ].parameters << swagger.paths.( path ).( method ).parameters;
            outputPort.interface.operation[ op_max ].response << swagger.paths.( path ).( method ).responses.("200")
        }
    };

    foreach( definition : swagger.definitions ) {
        get_def.name = definition;
        get_def.definition -> swagger.definitions.( definition );
        getJolieTypeFromSwaggerDefinition@SwaggerDefinition( get_def )( j_definition );
        op_file = op_file + j_definition
    };

    for( o = 0, o < #outputPort.interface.operation, o++ ) {
        rq_p.definition.parameters -> outputPort.interface.operation[ o ].parameters;
        rq_p.name = outputPort.interface.operation[ o ] + "Request";
        getJolieTypeFromSwaggerParameters@SwaggerDefinition( rq_p )( parameters );

        type_string = parameters;

        type_string = type_string + "type " + outputPort.interface.operation[ o ] + "Response:";
        if ( is_defined( outputPort.interface.operation[ o ].response.schema ) ) {
            if ( is_defined( outputPort.interface.operation[ o ].response.schema.("$ref") ) ) {
                getReferenceName@SwaggerDefinition( outputPort.interface.operation[ o ].response.schema.("$ref") )( ref );
                type_string = type_string + ref + "\n"
            } else if ( outputPort.interface.operation[ o ].response.schema.type == "array" ) {
                rq_arr.definition -> outputPort.interface.operation[ o ].response.schema;
                rq_arr.indentation = 1;
                getJolieDefinitionFromSwaggerArray@SwaggerDefinition( rq_arr )( array );
                type_string = type_string + " void {\n\t._" + array + "}\n"
            } else if ( outputPort.interface.operation[ o ].response.schema.type == "object" ) {
                type_string = type_string + "undefined\n"
            } else {
                rq_n.type = outputPort.interface.operation[ o ].response.schema.type;
                if ( is_defined( outputPort.interface.operation[ o ].response.schema.format ) ) {
                    rq_n.format = outputPort.interface.operation[ o ].response.schema.format
                };
                getJolieNativeTypeFromSwaggerNativeType@SwaggerDefinition( rq_n )( native );
                type_string = type_string + native + "\n"
            }
        } else {
          type_string = type_string + "undefined \n"
        }
        ;
        op_file = op_file + type_string
        ;
        operation_file.filename = output_folder + "/" + outputPort.interface.operation[ o ] + ".ol";
        operation_file.content = "include \"console.iol\"\ninclude \"string_utils.iol\"\ninclude \"outputPort.iol\"\n\n"
        + "main {\n/*\n" + type_string + "\n*/\n\twith( request ) {\n\t// fill here the request message\n\t};\n\t" +  outputPort.interface.operation[ o ] + "@"
        + outputPort.name + "( request )( response );\n"
        + "\tvalueToPrettyString@StringUtils( response )( s );\n\tprintln@Console( s )()\n}";
        writeFile@File( operation_file )()
    };


    op_file = op_file + "interface " + outputPort.interface + "{\n";
    op_file = op_file + "RequestResponse:\n";
    for( o = 0, o < #outputPort.interface.operation, o++ ) {
        op_file = op_file + outputPort.interface.operation[ o ]
            + "( " + outputPort.interface.operation[ o ] + "Request )"
            + "( " + outputPort.interface.operation[ o ] + "Response )";
        if ( o < (#outputPort.interface.operation - 1) ) {
            op_file = op_file + ",\n"
        }
    };
    op_file = op_file + "}\n\n";
    op_file = op_file + "outputPort " + outputPort.name + "{\n";
    op_file = op_file + "Location: \"" + outputPort.location + "\"\n";
    op_file = op_file + "Protocol: " + outputPort.protocol + "{\n";
    for( o = 0, o < #outputPort.interface.operation, o++ ) {
        op_file = op_file + ".osc." + outputPort.interface.operation[ o ]
                          + ".alias=\"" + outputPort.interface.operation[ o ].path + "\";\n";
        op_file = op_file + ".osc." + outputPort.interface.operation[ o ]
                          + ".method=\"" + outputPort.interface.operation[ o ].method + "\"";
        if ( o < (#outputPort.interface.operation - 1) ) {
            op_file = op_file + ";\n"
        }
    };
    op_file = op_file + "}\n";

    op_file = op_file + "Interfaces: " + outputPort.interface + "\n}";

    undef( file );
    file.filename = output_folder + "/outputPort.iol";
    file.content = op_file;
    writeFile@File( file )()
}
