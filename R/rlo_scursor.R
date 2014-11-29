rlo_scursor <- function() {
  python.exec("scursor = text.createTextCursorByRange(doc.CurrentController.ViewCursor)")
}
