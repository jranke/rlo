#' Function to connect to the current LibreOfficeWriter document
#'
#' @importFrom PythonInR pyExecfile
#' @export
rlo_connect <- function() pyExecfile(system.file("py/connect.py", package = "rlo"))
