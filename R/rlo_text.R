#' Insert text
#'
#' @importFrom PythonInR pyExec pySet
#' @param text The text to be inserted
#' @param format Format to be used
#' @param break_after Should a paragraph break be inserted after the text?
#' @export
rlo_text <- function(text, format = NULL, break_after = FALSE) {
  rlo_scursor()

  if (!is.null(format)) {
    pyExec(paste0("scursor.setPropertyValue('ParaStyleName', '", format, "')"))
  }

  pySet("itext", text)
  pyExec("text.insertString(scursor, itext, False)")

  if (break_after) {
    pyExec("text.insertControlCharacter(scursor, 0, False)")
  }
}
