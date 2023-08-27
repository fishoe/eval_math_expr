int evaluate(String expr) {
  var (leftVal, op, rightVal) = getNumberAndOperator(expr);
  if (op.isEmpty || rightVal.isEmpty) {
    return leftVal;
  } else {
    return switch (op) {
      "+" => sum(leftVal, evaluate(rightVal)),
      "-" => sub(leftVal, evaluate(rightVal)),
      "*" => mul(leftVal, evaluate(rightVal)),
      "/" => div(leftVal, evaluate(rightVal)),
      _ => throw Exception("Unknown operator: $op"),
    };
  }
}

int sum(int a, int b) => a + b;
int sub(int a, int b) => a - b;
int mul(int a, int b) => a * b;
int div(int a, int b) => a ~/ b;

// bit trick to check if a char is a digit
bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;

(int, String, String) getNumberAndOperator(String expr) {
  var number = "";
  var operator = "";
  var rest = "";
  for (int i = 0; i < expr.length; i++) {
    if (isDigit(expr, i)) {
      number += expr[i];
    } else {
      operator = expr[i];
      rest = expr.substring(number.length + 1);
      break;
    }
  }
  return (int.parse(number), operator, rest);
}
