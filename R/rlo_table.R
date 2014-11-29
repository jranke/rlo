rlo_table <- function(x, captiontext, 
                      header = "colnames", footer = NULL,
                      factors = NULL, merge_factors = TRUE,
                      numbered = TRUE, cursor = "scursor") {
  python.exec("scursor.setPropertyValue('ParaStyleName', 'Table')")
  if (numbered) {
    python.exec("text.insertString(scursor, 'Table ', False)")
    rlo_dispatch(".uno:InsertField", 
      list(Type = 23, SubType = 127, Name = "Tabelle", Content = "", Format = 4, Separator = " "))
    python.exec("text.insertString(scursor, ': ', False)")
  }
  python.assign("captiontext", captiontext)
  python.exec("text.insertString(scursor, captiontext, False)")

  python.exec("tbl = doc.createInstance('com.sun.star.text.TextTable')")
  if (header[1] == "colnames") {
    header <- colnames(x)
  }
  if (!is.null(header)) {
    x <- rbind(header, x)
  }

          factors = list(Crop = c(rep("Winter cereals", 4), rep("Spring cereals", 2), 
                                  rep("Potatoes", 2)),
                         Application = application_factor)

  if (!is.null(factors)) {
    for (i in length(factors):1) {
      x <- cbind(c(names(factors)[i], factors[[i]]), x)
    }
  }

  dimnames(x) <- NULL

  python.exec(paste0("tbl.initialize(", nrow(x), ", ", ncol(x), ")"))
  python.exec("text.insertTextContent(scursor, tbl, False)")
  python.assign("x", x)
  python.exec("x = tuple(tuple(i) for i in x)")
  python.exec("tbl.setDataArray(x)")

  if (merge_factors) {
    #python.exec("tcursor.mergeRange()")
  }

  if (is.null(footer)) {
    python.exec("scursor.setPropertyValue('ParaStyleName', 'Textkörper mit Abstand')")
  } else {
    python.exec("scursor.setPropertyValue('ParaStyleName', 'Tabellenunterschrift')")
    python.assign("footer", footer)
    python.exec("text.insertString(scursor, footer, False)")
    python.exec("text.insertControlCharacter(scursor, 0, False)")
    python.exec("scursor.setPropertyValue('ParaStyleName', 'Textkörper mit Abstand')")
  }
}
