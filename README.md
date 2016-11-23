# rlo

The R package `rlo` uses the UNO API of libreoffice to write to existing
libreoffice writer documents.

This is useful for useRs that appreciate the functionality of the libreoffice
writer for writing documents, but would like to be able to insert results from
R calculations.

However, it is also possible to start, populate and save libreoffice documents
without even touching the GUI:

```r
library(rlo)
rlo_start(file = "test.odt", overwrite = TRUE)

rlo_heading("Example heading", 1)
table_data = data.frame(
  Name = c("Jane", "Björn"),
  Age = c(25, 33))

rlo_table(table_data, "Some people and their age")

rlo_quit()
```

## Prerequisites

`rlo` depends on the R package `PythonInR` and the python bindings of libreoffice called `Python UNO`.
The `PythonInR` package can be installed from CRAN. On Debian and possibly on derived distributions,
installing `Python UNO` should be as easy as

```bash
apt install python-uno
```

I have not tried to use this package on operating systems other than Debian
stable, but I think it should be possible.
