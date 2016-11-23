#' Quit a libroffice instance
#'
#' @importFrom PythonInR pyExec
#' @param save Should changes in the current file be saved on closing?
#' @export
rlo_quit <- function(save = TRUE)
{
  if (save) {
    rlo_dispatch(".uno:Save", list(FilterName = "writer8"))
  }
  pyExec("desktop.terminate()")   
}
