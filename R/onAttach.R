.onAttach <- function(libname, pkgname) {
  pyExec("import numpy")
  pyOptions("useNumpy", TRUE)
  message("rlo: Importing numpy and setting the PythonInR option useNumpy to TRUE")
}
