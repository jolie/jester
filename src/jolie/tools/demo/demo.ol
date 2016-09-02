include "DemoInterface.iol"

include "console.iol"
include "string_utils.iol"

include "config.iol"

execution{ concurrent }

inputPort DEMO {
  Location: DemoLocation
  Protocol: sodep
  Interfaces: DemoInterface
}


inputPort DEMOHTTP {
  Location: DemoLocationHTTP
  Protocol: http {
    .response.headers.("Access-Control-Allow-Methods") = "POST,GET,OPTIONS";
    .response.headers.("Access-Control-Allow-Origin") = "*";
    .response.headers.("Access-Control-Allow-Headers") = "Content-Type"
  }
  Interfaces: DemoInterface
}

init {
      with( global.orders[ 0 ] ) {
        .title = "order0";
        .id = 1;
        .date = "01/01/2001";
        with( .items[ 0 ] ) {
          .name = "itemA";
          .quantity = 2;
          .price = 10.8
        };
        with( .items[ 1 ] ) {
          .name = "itemb";
          .quantity = 3;
          .price = 11.8
        };
        with( .items[ 2 ] ) {
          .name = "itemC";
          .quantity = 3;
          .price = 15.0
        }
      }
      ;
      with( global.orders[ 1 ] ) {
        .title = "order1";
        .id = 2;
        .date = "02/02/2002";
        with( .items[ 0 ] ) {
          .name = "itemA";
          .quantity = 2;
          .price = 10.8
        };
        with( .items[ 1 ] ) {
          .name = "itemb";
          .quantity = 3;
          .price = 11.8
        };
        with( .items[ 2 ] ) {
          .name = "itemC";
          .quantity = 3;
          .price = 15.0
        }
      }
      ;
      with( global.orders[ 2 ] ) {
        .title = "order2";
        .id = 2;
        .date = "03/03/2003";
        with( .items[ 0 ] ) {
          .name = "itemA";
          .quantity = 2;
          .price = 10.8
        };
        with( .items[ 1 ] ) {
          .name = "itemb";
          .quantity = 3;
          .price = 11.8
        };
        with( .items[ 2 ] ) {
          .name = "itemC";
          .quantity = 3;
          .price = 15.0
        }
      }
}

main {
  [ getOrders( request )( response ) {
      response.orders -> global.orders
  }]

  [ getOrdersByIItem( request )( response ) {
      response.orders -> global.orders
  }]

  [ putOrder( request )( response ) {
      orders_max = #orders;
      with( orders[ orders_max ] ) {
        .title = request.title;
        .id = orders_max;
        .date = request.date;
        for( i = 0, i < #request.items, i++ ) {
            with( .items[ i ] ) {
              .name = request.items[ i ].name;
              .quantity = request.items[ i ].quantity;
              .price = request.items[ i ].price
            }
        }
      }
  }]

  [ deleteOrder( request )( response ) {
      nullProcess
  }]
}
