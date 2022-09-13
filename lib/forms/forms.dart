/// FormError represents an error found by a form.
/// You'll maybe want to extend this to provide your own error types, but its usable as is, too.
class FormError {
  String message;

  FormError(this.message);
}

/// Form is a base class for building your own forms.
/// Please see the tests for examples on how they can be used.
abstract class Form {
  Form();

  bool _isValid = false;
  bool get isValid => _isValid;

  /// A function that validates your form.
  /// Returns a list of form errors, or an empty list if there are no errors - in which case isValid will be true.
  List<FormError> validator();

  /// Validates your form.
  /// Returns a list of form errors, or an empty list if there are no errors - in which case isValid will be true.
  /// Validation is handled lazily so you'll need to call this function to trigger validation.
  List<FormError> validate() {
    var errors = validator();

    if (errors.isNotEmpty) {
      _isValid = false;
    } else {
      _isValid = true;
    }

    return errors;
  }
}
