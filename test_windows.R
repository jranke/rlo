# If installing a matching python with numpy support is not wanted,
# do not set PYTHON_EXE, but connect to the python coming with
# libreoffice, but then numpy is not included which limits PythonInR a lot.
# PythonInR:::pyConnectWinDll(
#   dllName = "python33.dll",
#   dllDir = lo_path,
#   majorVersion = 3,
#   pythonHome = paste0(lo_path, "/python-core-3.3.0"),
#   pyArch = "32bit")
# pyOptions("useNumpy", FALSE)

# When I have started LO using the shortcut, I can do
command = "soffice test.odt"
system(command, wait = FALSE)
# to open an odt document if soffice is in the PATH (see above)

# The GUI is visible and I can connect:
library(rlo)
rlo_connect()

library(rlo)

rlo_heading("test")

rlo_heading("Yet another example heading", 1)

table_data = data.frame(
  City = c("München", "Berlin"),
  "Elevation\n[m]" = c(520, 34),
  check.names = FALSE)

# This depends on numpy to be available
rlo_table(table_data, "Two major cities in Germany")

rlo_dispatch(".uno:Save")
rlo_pdf()
browseURL("test.pdf")

rlo_quit()
