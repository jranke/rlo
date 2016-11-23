#' Function to finalize a jrwb report
#'
#' Not working yet, therefore not exported
#'
#' @importFrom PythonInR pyExec
rlo_finalize <- function()
{
  rlo_dispatch(".uno:UpdateAll")
}
