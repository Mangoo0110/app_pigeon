

DateTime parseDateTime(dynamic dateData) {
  return dateData == null
      ? DateTime.now()
      : dateData.runtimeType == int
      ? DateTime.fromMillisecondsSinceEpoch(dateData)
      : dateData.runtimeType == String
      ? DateTime.parse(dateData)
      : throw Exception("Invalid date format");
}

DateTime? tryParseDateTime(dynamic dateData) {
  try {
    return parseDateTime(dateData);
  } catch (e) {
    return null;
  }
}
