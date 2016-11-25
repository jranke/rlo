# rlo

The R package `rlo` uses the UNO API of libreoffice to write to existing
libreoffice writer documents.

This is useful for useRs that appreciate the functionality of the libreoffice
writer for writing documents, but would like to be able to insert results from
R calculations.

However, on Linux it is also possible to start, populate and save libreoffice
documents without even touching the GUI:

```r
library(rlo)
rlo_start(file = "test.odt", overwrite = TRUE)

rlo_heading("Example heading", 1)
table_data = data.frame(
  City = c("München", "Berlin"),
  "Elevation\n[m]" = c(520, 34),
  check.names = FALSE)

rlo_table(table_data, "Two major cities in Germany")

rlo_quit()
```

## Prerequisites

`rlo` depends on the R package `PythonInR` and the python bindings of
libreoffice called the Python-UNO bridge.

### PythonInR

The `PythonInR` package can be installed from CRAN or from the
[https://bitbucket.org/Floooo/pythoninr/](bitbucket repo), where you can also
find instructions for installation and setup.

### Python-UNO bridge

On Debian and possibly on derived distributions, installing `Python UNO` can be
as easy as

```bash
apt install python-uno
```

You may also find that it is possible to use this package on Windows, with the
limitation that I did not find a way to start LibreOffice from R. Therefore,
the functions `rlo_start` and `rlo_new` give an error on windows.

As `rlo` uses `PythonInR` with the option to use numpy (`pyOption(useNumpy=TRUE)`),
I installed WinPython in a version matching the minor release version of the Python
coming with Libreoffice. In the case of LibreOffice 5.1.6.2, I used
[WinPython-32bit-3.3.5.9](https://github.com/winpython/winpython/releases/tag/1.2.20150628b)
built on 28th of June 2015, as it was the last release of python 3.3 from this project.

After installing this, I had success using the following code in my `.Rprofile`:

```r
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
```
I made a shortcut on my Desktop containing the following command:

```cmd
"E:\Program Files\LibreOffice 5\program\soffice.exe" "-accept=socket,host=localhost,port=8100;urp;"
```
With this setup, I can load `rlo`. Before connecting to the LibreOffice
instance started by the shortcut, a text document has to be opened.

## Documentation

An online version of the package documentation can be found on [github.io](https://jranke.github.io/rlo).
