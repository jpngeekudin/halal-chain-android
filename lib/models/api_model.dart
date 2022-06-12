class ApiResponse<T> {
  String? message;
  int status;
  T data;

  ApiResponse({
    this.message,
    required this.status,
    required this.data
  });
}