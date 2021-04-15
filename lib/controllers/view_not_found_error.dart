class ViewNotFoundError extends Error {
  String fileName;

  ViewNotFoundError(this.fileName);
}
