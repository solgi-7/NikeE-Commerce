class AddToCartRespose {
  final int productId;
  final int cartItemId;
  final int count;

  AddToCartRespose(this.productId, this.cartItemId, this.count);

  AddToCartRespose.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        cartItemId = json['id'],
        count = json['count'];
}
