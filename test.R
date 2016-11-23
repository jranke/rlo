library(rlo)

rlo_new("test.odt", overwrite = TRUE)

rlo_heading("Yet another example heading", 1)

table_data = data.frame(
  Name = c("Jane", "Björn"),
  Age = c(25, 33))

rlo_table(table_data, "Some people and their age")

rlo_quit()

rlo_start("test.odt", overwrite = FALSE)
rlo_start("test.odt")
