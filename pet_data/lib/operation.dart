
class Operation {
  final int operationID;
  final String name;
  final String? description;

  const Operation({
    required this.operationID,
    required this.name,
    required this.description,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'OperationID': int operationID,
        'Name': String name,
        'Description': String? description,
      } =>
        Operation(
          operationID: operationID,
          name: name,
          description: description,
        ),
      _ => throw const FormatException('Failed to load Operation.'),
    };
  }
}