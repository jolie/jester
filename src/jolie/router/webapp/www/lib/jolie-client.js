var JolieClient = JolieClient || (function() {
    var API = {};
    var isError = function( data ) {
        if ( data != null && typeof data.error != "undefined" ) {
            return true;
        }
        return false;
    }

    var jolieCall = function( operation, request, callback, errorHandler ) {

        $.ajax({
            url: '/' + operation,
            dataType: 'json',
            data: JSON.stringify( request ),
            type: 'POST',
            contentType: 'application/json;charset=UTF-8',
            success: function( data ){
               if ( isError( data ) ) {
                    if ( data.error.message == "SessionExpired") {
                        showSessionExpiredDialog();
                    } else {
                        errorHandler( data );
                    }
               } else {
                    callback( data );
               }
            },
            error: function(errorType, textStatus, errorThrown) {
              errorHandler( textStatus );
            }
        });
    }

    API.getInterfaces = function( request, callback, errorHandler ) {
        jolieCall( "getInterfaces", request, callback, errorHandler );
    }

    return API;
})();
