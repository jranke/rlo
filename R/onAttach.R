.onAttach <- function(libname, pkgname) {
#  PythonInR::pyExec("import numpy")
  PythonInR::pyOptions("useNumpy", FALSE)
  #packageStartupMessage("rlo: Importing numpy and setting the PythonInR option useNumpy to TRUE")
}
