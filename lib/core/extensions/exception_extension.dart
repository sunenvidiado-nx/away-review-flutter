extension ExceptionExtension on Exception {
  String get errorMessage => toString().replaceAll('Exception: ', '');
}
