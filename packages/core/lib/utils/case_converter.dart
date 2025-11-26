/// Utility function to convert snake_case to camelCase for JSON parsing
Map<String, dynamic> toCamelCase(Map<String, dynamic> row) {
  final result = <String, dynamic>{};
  row.forEach((key, value) {
    final camelKey = key.replaceAllMapped(
      RegExp(r'_([a-z])'), 
      (match) => match.group(1)!.toUpperCase(),
    );
    result[camelKey] = value;
  });
  return result;
}

/// Convert camelCase to snake_case for database operations
Map<String, dynamic> toSnakeCase(Map<String, dynamic> row) {
  final result = <String, dynamic>{};
  row.forEach((key, value) {
    final snakeKey = key.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
    result[snakeKey] = value;
  });
  return result;
}
