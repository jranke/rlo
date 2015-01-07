rlo_table <- function(x, captiontext, 
                      header = "colnames", 
                      group_header = NULL,
                      group_sizes = NULL,
                      footer = NULL,
                      factors = NULL, merge_index = NULL,
                      numbered = TRUE, 
                      break_before_caption = FALSE,
                      split = FALSE,
                      first_column_width = "default") {
  python.exec("scursor.setPropertyValue('ParaStyleName', 'Table')")
  if (break_before_caption) {
    python.exec("scursor.setPropertyValue('BreakType', 4)") # PAGE_BEFORE
  }
  if (numbered) {
    python.exec("text.insertString(scursor, 'Table ', False)")
    rlo_dispatch(".uno:InsertField", 
      list(Type = 23, SubType = 127, Name = "Tabelle", Content = "", Format = 4, Separator = " "))
    python.exec("text.insertString(scursor, ': ', False)")
  }
  python.assign("captiontext", captiontext)
  python.exec("text.insertString(scursor, captiontext, False)")

  python.exec("tbl = doc.createInstance('com.sun.star.text.TextTable')")

  if (split) python.exec("tbl.Split = True")
  else python.exec("tbl.Split = False")

  if (header[1] == "colnames") {
    header <- colnames(x)
  }

  n_headrows = 0
  if (!is.null(header)) {
    x <- rbind(header, x)
    n_headrows = 1
    if (!is.null(group_header)) {
      group_header_expanded = NULL
      for (group in seq_along(group_header)) {
        group_header_expanded = c(group_header_expanded, group_header[group])
        group_size = group_sizes[group]
        if (group_size > 1) {
          group_header_expanded = c(group_header_expanded, rep("", group_size - 1))
        }
      }
      x <- rbind(group_header_expanded, x)
      n_headrows = 2
    }
  }

  mergelist = list()
  for (fi in seq_along(factors)) {
    factor_col = LETTERS[fi]
    if (factor_col %in% merge_index) {
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
      if (n_headrows == 0) {
        x <- cbind(factors[[i]], x)
      }
      if (n_headrows == 1) {
        x <- cbind(c(names(factors)[i], factors[[i]]), x)
      }
      if (n_headrows == 2) {
        x <- cbind(c(names(factors)[i], "", factors[[i]]), x)
      }
    }
  }

  dimnames(x) <- NULL

  python.exec(paste0("tbl.initialize(", nrow(x), ", ", ncol(x), ")"))
  python.exec("text.insertTextContent(scursor, tbl, False)")
  python.assign("x", x)
  python.exec("x = tuple(tuple(i) for i in x)")
  python.exec("tbl.setDataArray(x)")

  # Merge factor columns if requested
  for (factor_col in names(mergelist)) {
    if (factor_col %in% merge_index) {
      for (ei in seq_along(mergelist[[factor_col]])) {
        entry = mergelist[[factor_col]][[ei]]
        python.assign("cellname", paste0(factor_col, entry["start"] + n_headrows))
        python.exec("tcursor = tbl.createCursorByCellName(cellname)")
        stepsize = entry["end"] - entry["start"]
        python.exec(paste0("tcursor.goDown(", stepsize, ", True)"))
        python.exec("tcursor.mergeRange()")
      }
    }
  }

  # Merge headers of factor columns and group header fields if group header is present
  if (!is.null(group_header)) {
    for (factor_index in seq_along(factors)) {
      factor_col = LETTERS[factor_index]    
      python.assign("cellname", paste0(factor_col, 1))
      python.exec("tcursor = tbl.createCursorByCellName(cellname)")
      python.exec(paste0("tcursor.goDown(1, True)"))
      python.exec("tcursor.mergeRange()")
    }
    col_index = length(factors)
    for (group_size in group_sizes) {
      col_index = col_index + 1
      python.assign("cellname", paste0(LETTERS[col_index], 1))
      python.exec("tcursor = tbl.createCursorByCellName(cellname)")
      python.exec(paste0("tcursor.goRight(", group_size - 1, ", True)"))
      python.exec("tcursor.mergeRange()")
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

  # Sizing of columns not implemented
#   if (first_column_width != "default") {
#     python.exec("tcursor = tbl.createCursorByCellName('A1')")
#   }
}
