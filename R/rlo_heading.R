rlo_heading <- function(heading, level = 2, break_before = FALSE) {
  rlo_scursor()

  python.exec(paste0("scursor.setPropertyValue('ParaStyleName', 'Überschrift ", level, "')"))
  if (break_before) {
    python.exec("scursor.setPropertyValue('BreakType', 4)") # PAGE_BEFORE
  } else {
    python.exec("scursor.setPropertyValue('BreakType', 0)") # NONE
  }

  python.assign("heading", heading)
  python.exec("text.insertString(scursor, heading, False)")
  python.exec("text.insertControlCharacter(scursor, 0, False)")
}
