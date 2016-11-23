#' Use the dispatcher for GUI functions
#'
#' @importFrom PythonInR pyExec
#' @param URL The URL of the function to be dispatched
#' @param properties If not NULL, a list of properties to specify the call.
#'   This is often difficult to specify because of missing documentation
#' @export
#' @examples
#' \dontrun{rlo_dispatch(".uno:Save")}

rlo_dispatch <- function(URL, properties = NULL) {
  if (is.null(properties)) {
    pyExec(paste0("dispatcher.executeDispatch(doc.getCurrentController(), '", URL, 
                  "', '', 0, tuple())"))
  } else {
    pyExec(paste0("proplist = [ PropertyValue() for i in range(", length(properties), ") ]"))
    for (i in 1:length(properties)) {
      pyExec(paste0("proplist[", i - 1, "].Name = '", names(properties)[i], "'"))
      if (is.numeric(properties[[i]])) {
        pyExec(paste0("proplist[", i - 1, "].Value = ", properties[[i]]))
      } else {
        pyExec(paste0("proplist[", i - 1, "].Value = '", properties[[i]], "'"))
      }
    }
    pyExec(paste0("dispatcher.executeDispatch(doc.getCurrentController(), '", URL, 
                  "', '', 0, tuple(proplist))"))
  }
}
