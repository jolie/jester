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

include "Jolie2RestServiceInterface.iol"

outputPort Jolie2RestService {
  Interfaces: Jolie2RestServiceInterface
}

embedded {
  Jolie:
    "jolie2rest_service.ol" in Jolie2RestService
}


define __check_arguments {
    if ( #args > 1 ) {
        for( a = 1, a < #args, a++ ) {
            spl_arg = args[ a ];
            spl_arg.regex = "=";
            split@StringUtils( spl_arg )( argument );
            if ( argument.result[0] == "swagger_enable" ) {
                swagger_enable = bool( argument.result[1] )
            };
            if ( argument.result[0] == "easy_interface" ) {
                easy_interface = bool( argument.result[1] )
            }
        }
    }


}


main {
    if ( #args < 1 ) {
        println@Console( "Usage: jolie jolie2rest.ol router_host [swagger_enable=true|false] [easy_interface=true|false]\nEx: jolie jolie2rest.ol localhost:8080 swagger_enable=true easy_interface=false")();
        throw( IllegalArgument )
    };

    request.router_host = args[0];
    request.swagger_enable = true;
    request.easy_interface = false;
    request.wkdir = ".";
    __check_arguments;

    file.filename = "service_list.txt";
    readFile@File( file )( service_list );

    split_r = service_list;
    split_r.regex = "\n";
    split@StringUtils( split_r )( lines );

    for( l = 0, l < #lines.result, l++ ) {
        with( request.service[ l ] ) {
          split_r = lines.result[ l ];
          split_r.regex = ",";
          split@StringUtils( split_r )( params );

          trim@StringUtils( params.result[ 0 ] )( .filename );
          trim@StringUtils( params.result[ 1 ] )( .input_port )
        }
    }
    ;
    scope( executing_jolie2rest ) {
      install( DefinitionError => println@Console( executing_jolie2rest.DefinitionError )() );
      run@Jolie2RestService( request )()
    }

}
