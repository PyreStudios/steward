class FormError {
  String message;

  FormError(this.message);
}


/// Validatable is an abstract class that allows us to validate
/// implementers of the class. Additionally, we can query the validity of that form.
abstract class Validatable {
  List<FormError> validator();
  bool isValid = false;
}

abstract class Form<T> extends Validatable {
  @override
  List<FormError> validator();

  List<FormError> validate() {
    var errors = validator();

    if (errors.isNotEmpty) {
      isValid = false;
    } else {
      isValid = true;
    }

    return errors;
  }
}
