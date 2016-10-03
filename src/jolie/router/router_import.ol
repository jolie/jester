type GetOrdersByItemRequest: void {
  .itemName[1,1]:string
  .userId[1,1]:string
}
type OrderItem: void {
  .quantity[1,1]:int
  .price[1,1]:double
  .name[1,1]:string
}
type Order: void {
  .date[1,1]:string
  .id[0,1]:int
  .title[1,1]:string
  .items[0,*]:OrderItem
}
type Orders: void {
  .orders[0,*]:Order
}
type GetOrdersByItemResponse: Orders
type PutOrderRequest: void {
  .userId[1,1]:string
  .order[1,1]:Order
}
type PutOrderResponse: void
type DeleteOrderRequest: void {
  .orderId[1,1]:int
}
type DeleteOrderResponse: void
type GetOrdersRequest: void {
  .maxItems[1,1]:int
  .userId[1,1]:string
}
type GetOrdersResponse: Orders
interface DEMOInterface {
RequestResponse:
  getOrdersByIItem( GetOrdersByItemRequest )( GetOrdersByItemResponse ),
  putOrder( PutOrderRequest )( PutOrderResponse ),
  deleteOrder( DeleteOrderRequest )( DeleteOrderResponse ),
  getOrders( GetOrdersRequest )( GetOrdersResponse )
}

outputPort DEMO {
  Protocol:sodep
  Location:"socket://localhost:11000"
  Interfaces:DEMOInterface
}

init {
	routes[router_counter++] << {
		.outputPort="DEMO"
		,.method="post"
		,.template="/DEMO/getOrdersByIItem"
		,.operation="getOrdersByIItem"
	}
	;
	routes[router_counter++] << {
		.outputPort="DEMO"
		,.method="put"
		,.template="/DEMO/putOrder"
		,.operation="putOrder"
	}
	;
	routes[router_counter++] << {
		.outputPort="DEMO"
		,.method="delete"
		,.template="/DEMO/deleteOrder"
		,.operation="deleteOrder"
	}
	;
	routes[router_counter++] << {
		.outputPort="DEMO"
		,.method="get"
		,.template="/DEMO/orders/{userId}?maxItems={maxItems}"
		,.operation="getOrders"
		,.cast.maxItems="int"
	}
}
