import 'package:test/test.dart';
import 'package:steward/steward.dart';

class BadForm extends Form {
  BadForm(): super((form) {
    List<FormError> errors = [];

    if (1 != 2) {
      errors.add(FormError('1 != 2'));
    }

    return errors;
  });
}

class GoodForm extends Form {
  GoodForm(): super((form) {
    List<FormError> errors = [];

    if (1 != 1) {
      errors.add(FormError('this should never happen'));
    }

    return errors;
  });
}

void main() {
  group('Form tests', () {
    test('should handle validation errors', () {
      var form = BadForm();
      expect(form.validate().isNotEmpty, true);
      expect(form.validate()[0].message, '1 != 2');
      expect(form.isValid, false);
    });

    test('should handle no validation errors', () {
      var form = GoodForm();
      expect(form.validate().isEmpty, true);
      expect(form.isValid, true);
    });
  });
}
