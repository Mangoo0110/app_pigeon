class Success<T> {
  final String _message;
  final T? data;
  Success({String? message, this.data}): _message = message ?? "Success";
  String get message => _message;

  Success<T> copyWith({String? message, T? data}) =>
      Success<T>(message: message ?? _message, data: data ?? this.data);
}

class NoData {}