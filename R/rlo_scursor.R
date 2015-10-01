#' Function to get the current view cursor in the active document
#'
#' @importFrom PythonInR pyExec
#' @export
rlo_scursor <- function() {
  pyExec("scursor = text.createTextCursorByRange(doc.CurrentController.ViewCursor)")
}
