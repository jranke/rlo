lo_path = "E:/Program Files/LibreOffice 5/program"
lo_py = file.path(lo_path, "python.exe")


# We need to have 'soffice' in the path
# And we to manually set UNO environment variables
# This is ported to R and adapted to LibreOffice 5 from 
# http://sg.linuxtreff.ch/2012/libreoffice-dokumente-mit-python-generieren/
uno_env <- system2(lo_py, "get_uno_env.py", stdout = TRUE)

# Set environment variables for python interpreter
#Sys.setenv(URE_BOOTSTRAP=gsub("vnd.sun.star.pathname:", "", uno_env[1]))
Sys.setenv(URE_BOOTSTRAP=uno_env[1])
Sys.setenv(UNO_PATH=uno_env[2])
Sys.setenv(PATH=uno_env[3])

# To get the uno module onto the path
Sys.setenv(PYTHONPATH=lo_path)
PythonInR:::pyConnectWinDll(
  "python33.dll",
  lo_path,
  3,
  paste0(lo_path, "/python-core-3.3.0"),
  "32bit")

library(PythonInR)

pyExec("import uno")

# I am using a shortcut with the following code
shortcut = '"E:\\Program Files\\LibreOffice 5\\program\\soffice.exe" "-accept=socket,host=localhost,port=8100;urp;"'
#system(shortcut)
# But when I call it as above, LO is not visible and I cannot connect to it. 

# When I have started LO like this, I can do
command = "soffice test.odt"
system(command, wait = FALSE)
# to open an odt document

# When I click the shortcut, it is visible and I can connect:
pyExecfile(system.file("py/connect.py", package = "rlo"))
 

# and then, finally, I can use the part of my library that does not
# depend on numpy

library(rlo)

rlo_heading("test")

# The following does not work because I can not start libreoffice from R in the
# right way
#rlo_new("test.odt", overwrite = TRUE)

rlo_heading("Yet another example heading", 1)

table_data = data.frame(
  City = c("München", "Berlin"),
  "Elevation\n[m]" = c(520, 34),
  check.names = FALSE)

# Does not work because numpy is not available in the python
# coming with libreoffice
#rlo_table(table_data, "Two major cities in Germany")

# The following do work also under windows \o/
rlo_dispatch(".uno:Save")
rlo_pdf()
# rlo_pdf("test2.pdf") # Does not work
unlink("test2.pdf")

rlo_quit()

#rlo_start("test.odt")
browseURL("test.pdf")
