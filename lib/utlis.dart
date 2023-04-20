extension Capitalize on String {
  String capitalize() => length > 0
      ? "${this[0].toUpperCase()}${substring(1).toLowerCase()}"
      : this;
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.capitalize())
      .join(' ');
}
