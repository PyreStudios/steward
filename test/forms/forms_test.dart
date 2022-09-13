import 'package:test/test.dart';
import 'package:steward/steward.dart';

class BadForm extends Form {
  @override
  List<FormError> validator() {
    var errors = <FormError>[];

    if (1 != 2) {
      errors.add(FormError('1 != 2'));
    }

    return errors;
  }
}

class GoodForm extends Form {
  @override
  List<FormError> validator() {
    var errors = <FormError>[];

    if (1 != 1) {
      errors.add(FormError('this should never happen'));
    }

    return errors;
  }
}

class User {
  final String name;
  final int age;
  const User({required this.name, required this.age});
}

class FormWithData extends Form {
  User user;
  FormWithData(this.user);

  @override
  List<FormError> validator() {
    var errors = <FormError>[];

    if (user.age < 18) {
      errors.add(FormError('user is under 18'));
    }

    return errors;
  }
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

    test('example with incoming data', () {
      var form = FormWithData(User(age: 16, name: 'John'));
      expect(form.validate().isNotEmpty, true);
      expect(form.validate()[0].message, 'user is under 18');
      expect(form.isValid, false);
    });
  });
}
