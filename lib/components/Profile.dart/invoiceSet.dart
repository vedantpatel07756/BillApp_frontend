class InvoiceSet {
  String _name="Shree Samarth Trading";
  String _mobileNo="9324195020";
  String _gstNumber="Asljfdlflsdmsd";
  String _panNumber="GJGPP5444G";
  String _businessAddress="Vidya Nagar Nagpar East";
  String _email="Vedantpatel07756@gmail.com";

  InvoiceSet({
    required String name,
    required String mobileNo,
    required String gstNumber,
    required String panNumber,
    required String businessAddress,
    required String email,
  })  : _name = name,
        _mobileNo = mobileNo,
        _gstNumber = gstNumber,
        _panNumber = panNumber,
        _businessAddress = businessAddress,
        _email = email;

  // Getters
  String get name => _name;
  String get mobileNo => _mobileNo;
  String get gstNumber => _gstNumber;
  String get panNumber => _panNumber;
  String get businessAddress => _businessAddress;
  String get email => _email;

  // Setters
  set name(String value) {
    _name = value;
  }

  set mobileNo(String value) {
    _mobileNo = value;
  }

  set gstNumber(String value) {
    _gstNumber = value;
  }

  set panNumber(String value) {
    _panNumber = value;
  }

  set businessAddress(String value) {
    _businessAddress = value;
  }

  set email(String value) {
    _email = value;
  }

  // Method to display all information
  @override
  String toString() {
    return 'InvoiceSet(name: $_name, mobileNo: $_mobileNo, gstNumber: $_gstNumber, panNumber: $_panNumber, businessAddress: $_businessAddress, email: $_email)';
  }
}
