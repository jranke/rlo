#' Function to insert a heading
#'
#' @importFrom PythonInR pyExec
#' @export
rlo_heading <- function(heading, level = 2, break_before = FALSE) {
  rlo_scursor()

  pyExec(paste0("scursor.setPropertyValue('ParaStyleName', 'Heading ", level, "')"))
  if (break_before) {
    pyExec("scursor.setPropertyValue('BreakType', 4)") # PAGE_BEFORE
  } else {
    pyExec("scursor.setPropertyValue('BreakType', 0)") # NONE
  }

  pySet("heading", heading)
  pyExec("text.insertString(scursor, heading, False)")
  pyExec("text.insertControlCharacter(scursor, 0, False)")
}
