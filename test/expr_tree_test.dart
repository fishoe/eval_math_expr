import 'dart:math';

import 'package:test/test.dart';
import 'package:eval_math_expr/expr_tree.dart';
import 'package:eval_math_expr/operators.dart';

void main() {
  group('NumberNode', () {
    test('should evaluate to its value', () {
      expect(NumberNode(5).evaluate(), equals(5));
      expect(NumberNode(10).evaluate(), equals(10));
      expect(NumberNode(-3).evaluate(), equals(-3));
    });
  });

  group('OperatorNode', () {
    test('should evaluate to the correct value', () {
      expect(OperatorNode(sum, NumberNode(5), NumberNode(3)).evaluate(),
          equals(8));
      expect(OperatorNode(sub, NumberNode(10), NumberNode(5)).evaluate(),
          equals(5));
      expect(OperatorNode(mul, NumberNode(2), NumberNode(4)).evaluate(),
          equals(8));
      expect(OperatorNode(div, NumberNode(10), NumberNode(3)).evaluate(),
          equals(3));
    });
  });

  group('parse tool', () {
    test("get left number and rest of expression", () {
      expect(getNumberFrom("5+3"), equals((5, "+3")));
      expect(getNumberFrom(" 5-3"), equals((5, "-3")));
      expect(getNumberFrom("5*3"), equals((5, "*3")));
      expect(getNumberFrom("  5/3 "), equals((5, "/3")));
    });

    test("get operator and rest of expression", () {
      expect(getOperatorSignFrom("+3"), equals((sum, "3")));
      expect(getOperatorSignFrom("-3"), equals((sub, "3")));
      expect(getOperatorSignFrom("*3"), equals((mul, "3")));
      expect(getOperatorSignFrom("/3"), equals((div, "3")));
    });

    test("get number and operator", () {
      var (left, expr) = getNumberFrom("5+3");
      expect((left, expr), equals((5, "+3")));
      expect(getOperator(expr), equals((sum, "3")));
    });
  });

  group('Tree', () {
    test('a number tree evaluate', () {
      expect(Tree.parse("5").evaluate(), equals(5));
    });

    test('simple expression evaluate', () {
      expect(Tree.parse("5+3").evaluate(), equals(8));
      expect(Tree.parse("5-3").evaluate(), equals(2));
      expect(Tree.parse("5*3").evaluate(), equals(15));
      expect(Tree.parse("5/3").evaluate(), equals(1));
    });

    test('expressions with 4 numbers evaluate', () {
      expect(Tree.parse("5+3*2-1").evaluate(), equals(10));
      expect(Tree.parse("5-3*2+1").evaluate(), equals(0));
      expect(Tree.parse("5*3+2-1").evaluate(), equals(16));
      expect(Tree.parse("5/3+2-1").evaluate(), equals(2));
    });

    test('long expression without parenthesis evaluate', () {
      expect(Tree.parse("5+3*2-1+4*2-1").evaluate(), equals(17));
      expect(Tree.parse("5-3*2+1+4*2-1").evaluate(), equals(7));
      expect(Tree.parse("20 * 8 - 7 * 2 * 5").evaluate(), equals(90));
      expect(Tree.parse("5/3+2-1+4*2-1").evaluate(), equals(9));
    });

    test('invalid expression', () {
      expect(() => Tree.parse("5+3*2-"), throwsException);
      expect(() => Tree.parse("5+**2+"), throwsException);
      expect(() => Tree.parse("5+3*2/"), throwsException);
    });
  });
}
