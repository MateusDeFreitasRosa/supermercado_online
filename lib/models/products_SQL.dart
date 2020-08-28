class Products_SQL {
  String ID_STORE;
  String ID_PRODUCT;
  String EMAIL_USER;
  int AMOUNT;

  Products_SQL({this.ID_STORE,this.ID_PRODUCT,this.EMAIL_USER,this.AMOUNT});

  Map<String, dynamic> toMap() {
    return {
      'ID_STORE': ID_STORE,
      'ID_PRODUCT': ID_PRODUCT,
      'EMAIL_USER': EMAIL_USER,
      'AMOUNT': AMOUNT
    };
  }

}