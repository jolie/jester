type Order: void {
	.petId:long
	.quantity:int
	.id:long
	.shipDate:string
	.complete:bool
	.status:string
}
type Category: void {
	.name:string
	.id:long
}
type User: void {
	.firstName:string
	.lastName:string
	.password:string
	.userStatus:int
	.phone:string
	.id:long
	.email:string
	.username:string
}
type Tag: void {
	.name:string
	.id:long
}
type Pet: void {
	.photoUrls[0,*]:string
	.name:string
	.id:long
	.category:Category
	.tags[0,*]:Tag
	.status:string
}
type ApiResponse: void {
	.code:int
	.type:string
	.message:string
}
type addPetRequest: void {
.body: undefined
}
type addPetResponse:undefined 
type updatePetRequest: void {
.body: undefined
}
type updatePetResponse:undefined 
type getUserByNameRequest: void {
.username:string
}
type getUserByNameResponse:User
type deleteUserRequest: void {
.username:string
}
type deleteUserResponse:undefined 
type updateUserRequest: void {
.username:string
.body: undefined
}
type updateUserResponse:undefined 
type findPetsByStatusRequest: void {
.status[0,*]:string
}
type findPetsByStatusResponse: void {
	._[0,*]:Pet
}
type createUsersWithListInputRequest: void {
.body[0,*]:User
}
type createUsersWithListInputResponse:undefined 
type uploadFileRequest: void {
.petId:long
.additionalMetadata?:string
.file?:raw
}
type uploadFileResponse:ApiResponse
type getInventoryRequest: void {
}
type getInventoryResponse:undefined
type loginUserRequest: void {
.username:string
.password:string
}
type loginUserResponse:string
type createUserRequest: void {
.body: undefined
}
type createUserResponse:undefined 
type createUsersWithArrayInputRequest: void {
.body[0,*]:User
}
type createUsersWithArrayInputResponse:undefined 
type findPetsByTagsRequest: void {
.tags[0,*]:string
}
type findPetsByTagsResponse: void {
	._[0,*]:Pet
}
type placeOrderRequest: void {
.body: undefined
}
type placeOrderResponse:Order
type logoutUserRequest: void {
}
type logoutUserResponse:undefined 
type updatePetWithFormRequest: void {
.petId:long
.name?:string
.status?:string
}
type updatePetWithFormResponse:undefined 
type getPetByIdRequest: void {
.petId:long
}
type getPetByIdResponse:Pet
type deletePetRequest: void {
.api_key?:string
.petId:long
}
type deletePetResponse:undefined 
type getOrderByIdRequest: void {
.orderId:long
}
type getOrderByIdResponse:Order
type deleteOrderRequest: void {
.orderId:long
}
type deleteOrderResponse:undefined 
interface petstoreInterface{
RequestResponse:
addPet( addPetRequest )( addPetResponse ),
updatePet( updatePetRequest )( updatePetResponse ),
getUserByName( getUserByNameRequest )( getUserByNameResponse ),
deleteUser( deleteUserRequest )( deleteUserResponse ),
updateUser( updateUserRequest )( updateUserResponse ),
findPetsByStatus( findPetsByStatusRequest )( findPetsByStatusResponse ),
createUsersWithListInput( createUsersWithListInputRequest )( createUsersWithListInputResponse ),
uploadFile( uploadFileRequest )( uploadFileResponse ),
getInventory( getInventoryRequest )( getInventoryResponse ),
loginUser( loginUserRequest )( loginUserResponse ),
createUser( createUserRequest )( createUserResponse ),
createUsersWithArrayInput( createUsersWithArrayInputRequest )( createUsersWithArrayInputResponse ),
findPetsByTags( findPetsByTagsRequest )( findPetsByTagsResponse ),
placeOrder( placeOrderRequest )( placeOrderResponse ),
logoutUser( logoutUserRequest )( logoutUserResponse ),
updatePetWithForm( updatePetWithFormRequest )( updatePetWithFormResponse ),
getPetById( getPetByIdRequest )( getPetByIdResponse ),
deletePet( deletePetRequest )( deletePetResponse ),
getOrderById( getOrderByIdRequest )( getOrderByIdResponse ),
deleteOrder( deleteOrderRequest )( deleteOrderResponse )}

outputPort petstorePort{
Location: "socket://petstore.swagger.io:80/v2"
Protocol: http{
.osc.addPet.alias="/pet";
.osc.addPet.method="post";
.osc.updatePet.alias="/pet";
.osc.updatePet.method="put";
.osc.getUserByName.alias="/user/%!{username}";
.osc.getUserByName.method="get";
.osc.deleteUser.alias="/user/%!{username}";
.osc.deleteUser.method="delete";
.osc.updateUser.alias="/user/%!{username}";
.osc.updateUser.method="put";
.osc.findPetsByStatus.alias="/pet/findByStatus";
.osc.findPetsByStatus.method="get";
.osc.createUsersWithListInput.alias="/user/createWithList";
.osc.createUsersWithListInput.method="post";
.osc.uploadFile.alias="/pet/%!{petId}/uploadImage";
.osc.uploadFile.method="post";
.osc.getInventory.alias="/store/inventory";
.osc.getInventory.method="get";
.osc.loginUser.alias="/user/login";
.osc.loginUser.method="get";
.osc.createUser.alias="/user";
.osc.createUser.method="post";
.osc.createUsersWithArrayInput.alias="/user/createWithArray";
.osc.createUsersWithArrayInput.method="post";
.osc.findPetsByTags.alias="/pet/findByTags";
.osc.findPetsByTags.method="get";
.osc.placeOrder.alias="/store/order";
.osc.placeOrder.method="post";
.osc.logoutUser.alias="/user/logout";
.osc.logoutUser.method="get";
.osc.updatePetWithForm.alias="/pet/%!{petId}";
.osc.updatePetWithForm.method="post";
.osc.getPetById.alias="/pet/%!{petId}";
.osc.getPetById.method="get";
.osc.deletePet.alias="/pet/%!{petId}";
.osc.deletePet.method="delete";
.osc.getOrderById.alias="/store/order/%!{orderId}";
.osc.getOrderById.method="get";
.osc.deleteOrder.alias="/store/order/%!{orderId}";
.osc.deleteOrder.method="delete"}
Interfaces: petstoreInterface
}