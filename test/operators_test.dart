import 'package:test/test.dart';
import 'package:eval_math_expr/operators.dart';

void main() {
  group('Operators', () {
    group('Sum', () {
      test('should evaluate to the sum of its operands', () {
        expect(sum(5, 3), equals(8));
        expect(sum(10, 5), equals(15));
        expect(sum(-3, 5), equals(2));
      });
    });

    group('Sub', () {
      test('should evaluate to the difference of its operands', () {
        expect(sub(5, 3), equals(2));
        expect(sub(10, 5), equals(5));
        expect(sub(-3, 5), equals(-8));
      });
    });

    group('Multi', () {
      test('should evaluate to the product of its operands', () {
        expect(mul(5, 3), equals(15));
        expect(mul(10, 5), equals(50));
        expect(mul(-3, 5), equals(-15));
      });
    });

    group('Divide', () {
      test('should evaluate to the quotient of its operands', () {
        expect(div(5, 3), equals(1));
        expect(div(10, 5), equals(2));
        expect(div(-3, 5), equals(0));
      });
    });

    group('Get operator function from operator sign', () {
      test('should return the correct operator function', () {
        expect(getOperator("+"), equals(sum));
        expect(getOperator("-"), equals(sub));
        expect(getOperator("*"), equals(mul));
        expect(getOperator("/"), equals(div));
      });

      test('should throw an exception if the operator is unknown', () {
        expect(() => getOperator("!"), throwsException);
      });
    });
  });
}
