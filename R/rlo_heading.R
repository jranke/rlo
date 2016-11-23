#' Insert a heading
#'
#' @importFrom PythonInR pyExec pySet
#' @param heading The text of the heading
#' @param level Heading level from 1 to 10
#' @param break_before Should a page break before be associated with the heading?
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
