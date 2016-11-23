#' Export to PDF
#'
#' By default, this function takes the file name and substitutes .pdf for .odt.
#' Alternatively, an output file name can be given
#'
#' @importFrom PythonInR pyExec pyGet
#' @inheritParams rlo_start
#' @export
rlo_pdf <- function(file = NULL, dir = ".", overwrite = FALSE)
{
  if (is.null(file)) {
    file_url = pyGet("doc.URL")
    pdf_url = gsub(".odt$", ".pdf", file_url)
  } else {
    pdf_url = paste0("file://", file.path(normalizePath(dir), file))
  }

  pdf_path = gsub("^file://", "", pdf_url)
  if (file.exists(pdf_path) & overwrite == FALSE) {
    stop(pdf_url, " already exists.")
  } else {
    rlo_dispatch(".uno:ExportDirectToPDF",
                 list(URL = pdf_url, FilterName = "writer_pdf_Export"))
    message("Saved to ", pdf_url)
  }
}
