class PostPayment {
  final String clientId;
  final String createdAt;
  final int price;

  PostPayment(
      {required this.createdAt, required this.clientId, required this.price});
}
