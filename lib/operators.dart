int sum(int left, int right) => left + right;
int sub(int left, int right) => left - right;
int mul(int left, int right) => left * right;
int div(int left, int right) {
  if (right == 0) {
    throw Exception("Division by zero");
  }
  return left ~/ right;
}

int Function(int, int) getOperator(String op) {
  return switch (op) {
    "+" => sum,
    "-" => sub,
    "*" => mul,
    "/" => div,
    _ => throw Exception("Unknown operator: $op"),
  };
}
