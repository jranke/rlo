#' Apply a paragraph if it exists
#'
#' @importFrom PythonInR pyExec pyGet
#' @param parstyle The name of the paragraph style to be applied
#' @param warn Should missing paragraph styles give a warning?
#' @export
rlo_parstyle <- function(parstyle, warn = TRUE) {
    pyExec("parstyles = doc.StyleFamilies.getByName('ParagraphStyles')")
    if (pyGet(paste0("parstyles.hasByName('", parstyle, "')"))) {
      pyExec(paste0("scursor.setPropertyValue('ParaStyleName', '", parstyle, "')"))
    } else {
      if (warn) warning("Paragraph Style ", parstyle, " is not available in the document")
    }
}
