---
sidebar_position: 1
---

# Forms

Steward ships with a small abstraction to aid in building Forms.

For example, we can set up a simple Sign Up form like so: 

```dart
class _SignUpForm extends Form {
  final String? email;
  final String? password;

  _SignUpForm(Map<String, String> json)
      : email = json['email'],
        password = json['password'];
  
  @override
  List<FormError> validator() {
    final self = _self as _SignUpForm;
    final errors = <FormError>[];

    if (self.email == null || self.password == null) {
      errors.add(FormError('Email and password are required'));
    }

    if (self.email?.isEmpty == true) {
      errors.add(FormError('Email is required'));
    }

    if (self.password?.isEmpty == true &&
        (self.password?.length ?? 0) < 8) {
      errors.add(FormError('Password is not strong enough.'));
    }

    return errors;
  }
}
```

Of course, your sign up form may have different business logic associated with it and perhaps better validation, but the general shape of your form will match the one above. You'll take in some parameters to the form constructor and then call super, passing in a function to validate the form. That function will create a list of errors and return those errors. If no errors are returned, the form is assumed to be valid. 


```dart
@Post('/')
  Future<Response> signUp(Request request) async {
    final form = _SignUpForm(jsonDecode(await request.getBody()));
    final errors = form.validate();
    if (form.isValid) {
      final account = Account.signUp(
        emailAddress: form.email!,
        password: form.password!,
      );
      await accountsTable.insert(account);
      return Response.Ok(account);
    } else {
      return Response.BadRequest(errors);
    }
  }
```