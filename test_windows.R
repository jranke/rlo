# The following code should got to .Rprofile after installing
# the rlo package

#--------------------------------
# We need to have 'soffice' in the path and we need to set environment
# variables necessary for the Python-UNO bridge
# This is ported to R and adapted to LibreOffice 5 from 
# http://sg.linuxtreff.ch/2012/libreoffice-dokumente-mit-python-generieren/
lo_path = "E:/Program Files/LibreOffice 5/program"
lo_py = file.path(lo_path, "python.exe")
uno_env <- system2(lo_py, 
  shQuote(system.file("py/get_uno_env.py", package = "rlo")),
  stdout = TRUE)

# Set environment variables for python interpreter
Sys.setenv(URE_BOOTSTRAP=uno_env[1])
Sys.setenv(UNO_PATH=uno_env[2])
Sys.setenv(PATH=uno_env[3])

# To get the uno module onto the path
Sys.setenv(PYTHONPATH=lo_path)

# Then set the path to local python installation
py_path = "e:/WinPython-32bit-3.3.5.9/python-3.3.5"
Sys.setenv(PYTHON_EXE=file.path(py_path, "python.exe"))
#--------------------------------


# Alternatively, do not set PYTHON_EXE, but connect to the python coming with
# libreoffice, but then numpy is not included which limits PythonInR a lot.
# PythonInR:::pyConnectWinDll(
#   dllName = "python33.dll",
#   dllDir = lo_path,
#   majorVersion = 3,
#   pythonHome = paste0(lo_path, "/python-core-3.3.0"),
#   pyArch = "32bit")
# pyOptions("useNumpy", FALSE)

library(PythonInR)
pyExec("import uno")

# For starting libreoffice, I am using a shortcut with the following code
shortcut = '"E:\\Program Files\\LibreOffice 5\\program\\soffice.exe" "-accept=socket,host=localhost,port=8100;urp;"'
# But when I call it using "system", LO is not visible and I cannot connect to
# it. 
#system(shortcut)

# When I have started LO using the shortcut, I can do
command = "soffice test.odt"
system(command, wait = FALSE)
# to open an odt document if soffice is in the PATH (see above)

# The GUI is visible and I can connect:
pyExecfile(system.file("py/connect.py", package = "rlo"))

# so I can use the part of my library that does not depend on numpy

library(rlo)

rlo_heading("test")

rlo_heading("Yet another example heading", 1)

table_data = data.frame(
  City = c("München", "Berlin"),
  "Elevation\n[m]" = c(520, 34),
  check.names = FALSE)

rlo_table(table_data, "Two major cities in Germany")

rlo_dispatch(".uno:Save")
rlo_pdf()
browseURL("test.pdf")

rlo_quit()
