/// FormError represents an error found by a form.
/// You'll maybe want to extend this to provide your own error types, but its usable as is, too.
class FormError {
  String message;

  FormError(this.message);
}

/// Form is a base class for building your own forms.
/// Please see the tests for examples on how they can be used.
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
