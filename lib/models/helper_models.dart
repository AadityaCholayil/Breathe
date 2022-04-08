enum PageState { init, success, loading, error }

String getDateFromDateTime(DateTime dateTime){
  return dateTime.toIso8601String().substring(0, 10);
}
