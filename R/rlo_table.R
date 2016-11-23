#' Insert a table into the connected document
#'
#' Inserts a table at the current position of the view cursor.
#'
#' @importFrom PythonInR pyExec pySet
#' @param x A matrix of character vectors to be inserted as a table. If not a matrix,
#'   an attempt is made to turn it into a matrix by \code{\link{as.matrix}}.
#' @param captiontext The text of the caption
#' @param header The names to be used for the columns of the matrix
#' @param group_header If not NULL, the names of column groups
#' @param common_header If not NULL, the common header of all matrix columns
#' @param group_sizes If group_header is not NULL, a vector holding the sizes of
#'   column groups
#' @param footer An optional text to be included as a table footer
#' @param factors An optional named list of character vectors that must describe the
#'   rows of the matrix object
#' @param merge_index An optional character vector with the names of the factors for
#'   which adjacent cells with identical values should be merged
#' @param numbered Should the caption of the table be numbered?
#' @param NA_string The string used for NA values
#' @param break_before_caption Should a page break be insersted before the caption
#' @param split Should it be allowed to split the table across pages
#' @param repeat_headlines Should the headline(s) be repeated?
#' @param charheight An optional way to specify the character height in table cells
#' @param widths An optional way to specify relative columns widths
#' @param warn Should missing paragraph styles give a warning?
#' @export
rlo_table <- function(x, captiontext,
                      header = "colnames",
                      group_header = NULL,
                      common_header = NULL,
                      group_sizes = NULL,
                      footer = NULL,
                      factors = NULL, merge_index = NULL,
                      numbered = TRUE,
                      NA_string = "",
                      break_before_caption = FALSE,
                      split = FALSE,
                      repeat_headlines = TRUE,
                      charheight = NULL,
                      widths = NULL,
                      warn = FALSE)
{
  rlo_scursor()

  if (!inherits(x, "matrix")) x <- as.matrix(x)
  matrix_cols = ncol(x)

  pyExec("scursor.setPropertyValue('ParaStyleName', 'Table')")
  pyExec("scursor.setPropertyValue('ParaKeepTogether', True)")
  if (break_before_caption) {
    pyExec("scursor.setPropertyValue('BreakType', 4)") # PAGE_BEFORE
  } else {
    pyExec("scursor.setPropertyValue('BreakType', 0)") # NONE
  }
  if (numbered) {
    pyExec("text.insertString(scursor, 'Table ', False)")
    rlo_dispatch(".uno:InsertField",
      list(Type = 23, SubType = 127, Name = "Tabelle", Content = "", Format = 4, Separator = " "))
    pyExec("text.insertString(scursor, ': ', False)")
  }
  pySet("captiontext", captiontext)
  pyExec("text.insertString(scursor, captiontext, False)")

  pyExec("tbl = doc.createInstance('com.sun.star.text.TextTable')")

  if (split) pyExec("tbl.Split = True")
  else pyExec("tbl.Split = False")

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
    if (!is.null(common_header)) {
      x <- rbind(c(common_header, rep("", matrix_cols - 1)), x)
      n_headrows = n_headrows + 1
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
      if (n_headrows == 3) {
        x <- cbind(c(names(factors)[i], "", "", factors[[i]]), x)
      }
    }
  }

  dimnames(x) <- NULL

  x[is.na(x)] <- NA_string

  pyExec(paste0("tbl.initialize(", nrow(x), ", ", ncol(x), ")"))
  pyExec("text.insertTextContent(scursor, tbl, False)")
  pySet("x", x)
  pyExec("x = tuple(tuple(i) for i in x)")
  pyExec("tbl.setDataArray(x)")

  # Set cell widths
  if (!is.null(widths)) {
    if (length(widths) > ncol(x)) stop("You specified more cell widths than the number of columns")
    if (length(widths) < ncol(x)) widths = c(widths, rep(1, ncol(x) - length(widths)))

    separators = round(cumsum(widths) / sum(widths) * 10000)

    pyExec("tcs = tbl.TableColumnSeparators")
    for (i in 0:(length(separators) - 2)) {
      pyExec(paste0("tcs[", i, "].Position = ", separators[i + 1]))
    }
    pyExec("tbl.TableColumnSeparators = tcs")
  }

  cellrange = paste0("A1:", LETTERS[ncol(x)], nrow(x))
  if (!is.null(charheight)) {
    pyExec(paste0("tbl.getCellRangeByName('", cellrange, "').CharHeight = ", charheight))
  }

  # Merge factor columns if requested
  for (factor_col in names(mergelist)) {
    if (factor_col %in% merge_index) {
      for (ei in seq_along(mergelist[[factor_col]])) {
        entry = mergelist[[factor_col]][[ei]]
        pySet("cellname", paste0(factor_col, entry["start"] + n_headrows))
        pyExec("tcursor = tbl.createCursorByCellName(cellname)")
        stepsize = entry["end"] - entry["start"]
        pyExec(paste0("tcursor.goDown(", stepsize, ", True)"))
        pyExec("tcursor.mergeRange()")
      }
    }
  }

  # Merge headers of factor columns (vertically)
  if (n_headrows > 1) {
    factor_merge_step = n_headrows - 1
    for (factor_index in seq_along(factors)) {
      factor_col = LETTERS[factor_index]
      pySet("cellname", paste0(factor_col, 1))
      pyExec("tcursor = tbl.createCursorByCellName(cellname)")
      pyExec(paste0("tcursor.goDown(", factor_merge_step, ", True)"))
      pyExec("tcursor.mergeRange()")
    }
  }

  # Merge group header fields if group header is present
  if (!is.null(group_header)) {
    col_index = length(factors)
    for (group_size in group_sizes) {
      col_index = col_index + 1
      group_header_row_index = if (!is.null(common_header)) 2 else 1
      pySet("cellname", paste0(LETTERS[col_index], group_header_row_index))
      pyExec("tcursor = tbl.createCursorByCellName(cellname)")
      pyExec(paste0("tcursor.goRight(", group_size - 1, ", True)"))
      pyExec("tcursor.mergeRange()")
    }
  }

  # Merge common header fields if common header is present
  if (!is.null(common_header)) {
    col_index = length(factors) + 1
    pySet("cellname", paste0(LETTERS[col_index], 1))
    pyExec("tcursor = tbl.createCursorByCellName(cellname)")
    pyExec(paste0("tcursor.goRight(", matrix_cols - 1, ", True)"))
    pyExec("tcursor.mergeRange()")
  }

  # Repeat headlines if requested
  if (repeat_headlines) {
    pyExec(paste0("tbl.setPropertyValue('HeaderRowCount', ", n_headrows, ")"))
  }

  # Set footer
  if (is.null(footer)) {
    rlo_parstyle('Textk\u00f6rper mit Abstand', warn = warn)
  } else {
    rlo_parstyle('Tabellenunterschrift', warn = warn)
    if (!is.null(charheight)) {
      pyExec(paste0("scursor.setPropertyValue('CharHeight', ", charheight, ")"))
    }
    pySet("footer", footer)
    pyExec("text.insertString(scursor, footer, False)")
    pyExec("text.insertControlCharacter(scursor, 0, False)")
    rlo_parstyle('Textk\u00f6rper mit Abstand', warn = warn)
  }
}
