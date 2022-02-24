class FormError {
  String message;

  FormError(this.message);
}

class Form {
  final List<FormError> Function(Form) _validator;
  bool _isValid = false;

  Form(this._validator);

  bool get isValid => _isValid;

  List<FormError> validate() {
    var errors = _validator(this);

    if (errors.isNotEmpty) {
      _isValid = false;
    } else {
      _isValid = true;
    }

    return errors;
  }
}
