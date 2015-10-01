#' Function to use the dispatcher to use GUI functions
#'
#' @importFrom PythonInR pyExec
#' @export
rlo_dispatch <- function(URL, properties) {
  pyExec(paste0("proplist = [ PropertyValue() for i in range(", length(properties), ") ]"))
  for (i in 1:length(properties)) {
    pyExec(paste0("proplist[", i - 1, "].Name = '", names(properties)[i], "'"))
    if (is.numeric(properties[[i]])) {
      pyExec(paste0("proplist[", i - 1, "].Value = ", properties[[i]]))
    } else {
      pyExec(paste0("proplist[", i - 1, "].Value = '", properties[[i]], "'"))
    }
  }
  pyExec(paste0("dispatcher.executeDispatch(doc.getCurrentController(), '",
                     URL, "', '', 0, tuple(proplist))"))
}
