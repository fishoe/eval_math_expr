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
      expect(getOperatorSignFrom("+3"), equals(('+', "3")));
      expect(getOperatorSignFrom("-3"), equals(('-', "3")));
      expect(getOperatorSignFrom("*3"), equals(('*', "3")));
      expect(getOperatorSignFrom("/3"), equals(('/', "3")));
    });

    test("get number and operator", () {
      var (left, expr) = getNumberFrom("5+3");
      expect((left, expr), equals((5, "+3")));
      expect(getOperatorSignFrom(expr), equals(('+', "3")));
    });

    test("invalid operator", () {
      expect(() => getOperator("!"), throwsException);
    });

    test("last operator node", () {
      var node = OperatorNode(sum, NumberNode(5), NumberNode(3));
      expect(lastOperatorNode(node), equals(node));
      node = OperatorNode(
          sum, NumberNode(5), OperatorNode(sum, NumberNode(3), NumberNode(2)));
      expect(lastOperatorNode(node), equals(node.right));
    });

    test("last operator node with invalid node", () {
      expect(() => lastOperatorNode(NumberNode(5)), throwsException);
    });

    test("extract sub expression in expression has Paren", () {
      expect(ExpressionTree.getParenExpression("(5+3)"), equals("5+3"));
      expect(ExpressionTree.getParenExpression("(5+3)*2"), equals("5+3"));
    });
  });

  group('Tree', () {
    test('a number tree evaluate', () {
      expect(ExpressionTree.parse("5").evaluate(), equals(5));
    });

    test('simple expression evaluate', () {
      expect(ExpressionTree.parse("5+3").evaluate(), equals(8));
      expect(ExpressionTree.parse("5-3").evaluate(), equals(2));
      expect(ExpressionTree.parse("5*3").evaluate(), equals(15));
      expect(ExpressionTree.parse("5/3").evaluate(), equals(1));
    });

    test('expressions with 4 numbers evaluate', () {
      expect(ExpressionTree.parse("5+3*2-1").evaluate(), equals(10));
      expect(ExpressionTree.parse("5-3*2+1").evaluate(), equals(0));
      expect(ExpressionTree.parse("5*3+2-1").evaluate(), equals(16));
      expect(ExpressionTree.parse("5/3+2-1").evaluate(), equals(2));
    });

    test('long expression without Paren evaluate', () {
      expect(ExpressionTree.parse("5+3*2-1+4*2-1").evaluate(),
          equals(5 + 3 * 2 - 1 + 4 * 2 - 1));
      expect(ExpressionTree.parse("5-3*2+1+4*2-1").evaluate(),
          equals(5 - 3 * 2 + 1 + 4 * 2 - 1));
      expect(ExpressionTree.parse("20 * 8 - 7 * 2 * 5").evaluate(),
          equals(20 * 8 - 7 * 2 * 5));
      expect(ExpressionTree.parse("5/3+2-1+4*2-1").evaluate(),
          equals(5 ~/ 3 + 2 - 1 + 4 * 2 - 1));
    });

    test('Parsing paren expression', () {
      var expr = "5+3";
      var eTree = ExpressionTree.parse(expr);
      expect(eTree.evaluate(), equals(5 + 3));
      expect(ExpressionTree.adaptWithParen(eTree.root, " * 2").evaluate(),
          equals((5 + 3) * 2));
      expect(ExpressionTree.adaptWithParen(eTree.root, " * 2 + 7").evaluate(),
          equals((5 + 3) * 2 + 7));
    });

    test('Paren expression evaluate', () {
      expect(
          ExpressionTree.parse("((((((((((5))))))))))").evaluate(), equals(5));
      expect(ExpressionTree.parse("((((((((((5)))))").evaluate(), equals(5));
      expect(ExpressionTree.parse("(5+3)").evaluate(), equals((5 + 3)));
      expect(ExpressionTree.parse("(5+3)*2-1").evaluate(),
          equals((5 + 3) * 2 - 1));
      expect(ExpressionTree.parse("(5-3)*2+1").evaluate(),
          equals((5 - 3) * 2 + 1));
      expect(ExpressionTree.parse("(5*3)+2-1").evaluate(),
          equals((5 * 3) + 2 - 1));
      expect(ExpressionTree.parse("3*(7*2-2)").evaluate(),
          equals(3 * (7 * 2 - 2)));
      // expect(ExpressionTree.parse("3+(7*2-2)*7").evaluate(),
      //     equals(3 + (7 * 2 - 2) * 7));
    });
  });
}
