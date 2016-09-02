type OrderItem: void {
    .name: string
    .quantity: int
    .price: double
}

type Order: void {
    .title: string
    .id?: int
    .date: string
    .items*: OrderItem
}

type Orders: void {
    .orders*: Order
}

type GetOrdersRequest: void {
    .userId: string
    .maxItems: int
}

type GetOrdersResponse: Orders

type GetOrdersByItemRequest: void {
    .userId: string
    .itemName: string
}

type GetOrdersByItemResponse: Orders

type PutOrderRequest: void {
    .userId: string
    .order: Order
}

type PutOrderResponse: void

type DeleteOrderRequest: void {
    .orderId: int
}

type DeleteOrderResponse: void


interface DemoInterface {
  RequestResponse:
    /**! @Rest: method=get, template=/orders/{userId}?maxItems={maxItems}; */
    getOrders( GetOrdersRequest )( GetOrdersResponse ),

    /**! @Rest: method=post; */
    getOrdersByIItem( GetOrdersByItemRequest )( GetOrdersByItemResponse ),

    /**! @Rest: method=put; */
    putOrder( PutOrderRequest )( PutOrderResponse ),

    /**! @Rest: method=delete; */
    deleteOrder( DeleteOrderRequest )( DeleteOrderResponse )
}
