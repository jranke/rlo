library(rlo)

rlo_new("test.odt", overwrite = TRUE)

rlo_heading("Yet another example heading", 1)

table_data = data.frame(
  City = c("München", "Berlin"),
  "Elevation\n[m]" = c(520, 34),
  check.names = FALSE)

rlo_table(table_data, "Two major cities in Germany")

rlo_dispatch(".uno:Save")
rlo_pdf()
rlo_pdf("test2.pdf")
unlink("test2.pdf")

rlo_quit()

rlo_start("test.odt")
browseURL("test.pdf")
