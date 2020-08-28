String formatDate(DateTime dateTime) {
  return '${((dateTime.day.toString()).length < 2 ? '0'+dateTime.day.toString() : dateTime.day.toString())}/'
      '${((dateTime.month.toString()).length < 2 ? '0'+dateTime.month.toString() : dateTime.month.toString())}/'
      '${dateTime.year.toString()}';
}