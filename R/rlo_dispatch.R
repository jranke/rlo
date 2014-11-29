rlo_dispatch <- function(URL, properties) {
  python.exec(paste0("proplist = [ PropertyValue() for i in range(", length(properties), ") ]"))
  for (i in 1:length(properties)) {
    python.exec(paste0("proplist[", i - 1, "].Name = '", names(properties)[i], "'"))
    if (is.numeric(properties[[i]])) {
      python.exec(paste0("proplist[", i - 1, "].Value = ", properties[[i]]))
    } else {
      python.exec(paste0("proplist[", i - 1, "].Value = '", properties[[i]], "'"))
    }
  }
  python.exec(paste0("dispatcher.executeDispatch(doc.getCurrentController(), '",
                     URL, "', '', 0, tuple(proplist))"))
}
