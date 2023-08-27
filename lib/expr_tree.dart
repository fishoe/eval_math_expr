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
    throw Exception("Invalid node type: $node");
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

class ExpressionTree {
  Node root;

  ExpressionTree(this.root);

  int evaluate() => root.evaluate();

  static Node addNode(Node left, String expr) {
    var localExpr = expr.trim();
    if (localExpr.isEmpty) {
      return left;
    } else {
      var operatorSign = '';
      var right = 0;
      (operatorSign, localExpr) = getOperatorSignFrom(localExpr);
      var operatorFunction = getOperator(operatorSign);
      if (localExpr[0] == '(') {
        var subExpr = getParenExpression(localExpr);
        localExpr = localExpr.substring(subExpr.length + 2);
        return adaptWithParen(
            OperatorNode(operatorFunction, left, _parse(subExpr)), localExpr);
      } else {
        (right, localExpr) = getNumberFrom(localExpr);
        if (operatorSign == '+' || operatorSign == '-' || left is NumberNode) {
          return addNode(
              OperatorNode(operatorFunction, left, NumberNode(right)),
              localExpr);
        } else {
          var lastOperatorFromTree = lastOperatorNode(left) as OperatorNode;
          lastOperatorFromTree.right = OperatorNode(
              operatorFunction, lastOperatorFromTree.right, NumberNode(right));
          return addNode(left, localExpr);
        }
      }
    }
  }

  static Node adaptWithParen(Node left, String expr) {
    var localExpr = expr.trim();
    if (localExpr.isEmpty) {
      return left;
    } else {
      var operatorSign = '';
      var right = 0;
      (operatorSign, localExpr) = getOperatorSignFrom(localExpr);
      var operatorFunction = getOperator(operatorSign);
      (right, localExpr) = getNumberFrom(localExpr);

      if (operatorSign == '/' && right == 0) {
        throw Exception("Division by zero");
      }

      return addNode(
          OperatorNode(operatorFunction, left, NumberNode(right)), localExpr);
    }
  }

  static String getParenExpression(String expr) {
    var open = 0;
    var close = 0;
    var idx = 0;

    for (; idx < expr.length; idx++) {
      if (expr[idx] == '(') {
        open++;
      } else if (expr[idx] == ')') {
        close++;
      }

      if (open == close) {
        break;
      } else if (open < close) {
        throw Exception("Invalid expression");
      }
    }

    var subExpr = expr.substring(1, idx);

    return subExpr + (")" * (open - close));
  }

  static Node _parse(String expr) {
    if (expr.isEmpty) {
      throw Exception("Empty expression");
    }

    if (expr[0] == '(') {
      var subExpr = getParenExpression(expr);
      if (subExpr.length >= expr.length) {
        return _parse(subExpr);
      } else {
        expr = expr.substring(subExpr.length + 2);
        return adaptWithParen(_parse(subExpr), expr);
      }
    } else {
      var (left, rest) = getNumberFrom(expr);
      return addNode(NumberNode(left), rest);
    }
  }

  static ExpressionTree parse(String expr) {
    return ExpressionTree(_parse(expr));
  }
}
