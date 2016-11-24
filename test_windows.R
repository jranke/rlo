lo_path = "E:/Program Files/LibreOffice 5/program"
lo_py = file.path(lo_path, "python.exe")

# We need to have 'soffice' in the path and we need to set environment
# variables necessary for the Python-UNO bridge
# This is ported to R and adapted to LibreOffice 5 from 
# http://sg.linuxtreff.ch/2012/libreoffice-dokumente-mit-python-generieren/
uno_env <- system2(lo_py, "get_uno_env.py", stdout = TRUE)

# Set environment variables for python interpreter
Sys.setenv(URE_BOOTSTRAP=uno_env[1])
Sys.setenv(UNO_PATH=uno_env[2])
Sys.setenv(PATH=uno_env[3])

# To get the uno module onto the path
Sys.setenv(PYTHONPATH=lo_path)

# Then connect (do not set PYTHON_EXE in .Rprofile or .Renviron,
# this is not flexible enough)
PythonInR:::pyConnectWinDll(
  dllName = "python33.dll",
  dllDir = lo_path,
  majorVersion = 3,
  pythonHome = paste0(lo_path, "/python-core-3.3.0"),
  pyArch = "32bit")

library(PythonInR)
pyExec("import uno")

# Alternatively, connect to a python installation with numpy
# user_path = "c:/users/USER/appdata/local/programs/python/python35-32"
# PythonInR:::pyConnectWinDll(
#   dllName = "python35.dll",
#   dllDir = user_path,
#   majorVersion = 3,
#   pythonHome = user_path,
#   pyArch = "32bit")
# library(PythonInR)
# pyExec("import numpy")
# # but then importing the uno module hangs, it seems not to be compatible
# pyExec("import uno")

# I am using a shortcut with the following code
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

rlo_dispatch(".uno:Save")
rlo_pdf()

rlo_quit()
