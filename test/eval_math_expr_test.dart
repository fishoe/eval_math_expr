import 'package:eval_math_expr/eval_math_expr.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(evaluate("6*7"), 42);
    expect(evaluate("1+1"), 2);
    expect(evaluate("1+2*3"), 7);
    expect(evaluate("1+2*3+4"), 11);
  });
}
