import 'package:flutter_test/flutter_test.dart';
import 'package:salary_app/core/network/api_exception.dart';

void main() {
  test('ApiException exposes its message and status code', () {
    const exception = ApiException('Invalid credentials.', statusCode: 401);

    expect(exception.message, 'Invalid credentials.');
    expect(exception.statusCode, 401);
    expect(exception.toString(), contains('401'));
  });
}
