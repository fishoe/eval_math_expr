import 'package:eval_math_expr/eval_math_expr.dart';
import 'package:eval_math_expr/operators.dart';

bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

abstract class Node {
  int evaluate();
}

class NumberNode implements Node {
  final int value;

  NumberNode(this.value);

  @override
  int evaluate() => value;
}

class OperatorNode implements Node {
  final Node left;
  Node right;
  final int Function(int, int) opFunc;

  OperatorNode(this.opFunc, this.left, this.right);

  @override
  int evaluate() {
    return opFunc(left.evaluate(), right.evaluate());
  }
}

(int, String) getNumberFrom(String expr) {
  expr = expr.trim();
  var left = "";
  for (int i = 0; i < expr.length; i++) {
    if (isDigit(expr, i)) {
      left += expr[i];
    } else {
      return (int.parse(left), expr.substring(left.length));
    }
  }
  return (int.parse(left), "");
}

(String, String) getOperatorSignFrom(String expr) {
  expr = expr.trim();
  var op = expr[0];
  return (op, expr.substring(1));
}

Node lastOperatorNode(Node node) {
  if (node is NumberNode) {
    return node;
  } else if (node is OperatorNode) {
    if (node.right is NumberNode) {
      return node;
    } else {
      return lastOperatorNode(node.right);
    }
  } else {
    throw Exception("Unknown node type: $node");
  }
}

class Tree {
  Node root;

  Tree(this.root);

  int evaluate() => root.evaluate();

  static Node adaptWith(Node left, String expr) {
    expr = expr.trim();
    if (expr.isEmpty) {
      return left;
    } else {
      var operatorSign = '';
      var right = 0;
      (operatorSign, expr) = getOperatorSignFrom(expr);
      var operatorFunction = getOperator(operatorSign);
      (right, expr) = getNumberFrom(expr);

      if (operatorSign == '/' && right == 0) {
        throw Exception("Division by zero");
      }

      if (operatorSign == '+' || operatorSign == '-' || left is NumberNode) {
        return adaptWith(
            OperatorNode(operatorFunction, left, NumberNode(right)), expr);
      } else {
        var lastOperatorFromTree = lastOperatorNode(left) as OperatorNode;
        lastOperatorFromTree.right = OperatorNode(
            operatorFunction, lastOperatorFromTree.right, NumberNode(right));
        return adaptWith(left, expr);
      }
    }
  }

  static Tree parse(String expr) {
    var (left, rest) = getNumberFrom(expr);
    return Tree(adaptWith(NumberNode(left), rest));
  }
}
