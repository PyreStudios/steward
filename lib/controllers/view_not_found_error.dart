/// ViewNotFoundError is thrown when we try to load a view that doesn't exist.
class ViewNotFoundError extends Error {
  String fileName;

  ViewNotFoundError(this.fileName);
}
