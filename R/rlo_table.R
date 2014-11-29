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

  if (merge_factors) {
    mergelist = list()
    for (fi in seq_along(factors)) {
      factor_col = LETTERS[fi]
      f <- factors[[fi]]
      mergelist[[factor_col]] <- list()
      merge_start = 1
      merge_end = 1
      merge_factor = f[merge_start]
      merge_count = 0
      for (i in 1:length(f)) {
        if (f[i] == merge_factor) {
          if (i != merge_start) {
            factors[[fi]][i] = ""
            if (is.na(f[i + 1])) {
                merge_count = merge_count + 1
                merge_end = i
                entry <- c(start = merge_start, end = merge_end)
                mergelist[[factor_col]][[merge_count]] = entry
            }
            else if (f[i + 1] != merge_factor) {
                merge_count = merge_count + 1
                merge_end = i
                entry <- c(start = merge_start, end = merge_end)
                mergelist[[factor_col]][[merge_count]] = entry
            }
          }
        } else {
          merge_start = i
          merge_end = i
          merge_factor = f[merge_start]
        }
      }
    }
  }

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
    for (factor_col in names(mergelist)) {
      for (ei in seq_along(mergelist[[factor_col]])) {
        entry = mergelist[[factor_col]][[ei]]
        python.assign("cellname", paste0(factor_col, entry["start"] + 1))
        python.exec("tcursor = tbl.createCursorByCellName(cellname)")
        stepsize = entry["end"] - entry["start"]
        python.exec(paste0("tcursor.goDown(", stepsize, ", True)"))
        python.exec("tcursor.mergeRange()")
      }
    }
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
