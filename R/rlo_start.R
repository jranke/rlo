rlo_start <- function(file = NULL,
                      title = NULL,
                      template = NULL,
                      overwrite = FALSE,
                      sleep_time = 3)
{
  # Start libreoffice listening to port 8100 on localhost
  command = "libreoffice --accept='socket,host=localhost,port=8100;urp;'"

  # Stop if file exists except if overwriting is requested
  if (!is.null(file) && !overwrite) {
    if (file.exists(file)) stop(file, " exists")
  }

  # Copy template to file if available
  if (is.null(template)) {
    command = paste(command, "--writer")
  } else {
    if (file.access(template, mode = 4) == 0) {
      if (!file.exists(file) || overwrite) {
        file.copy(template, file)
        command = paste(command, file)
      }
    } else {
      stop("Template not readable")
    }
  } 

  # Start libreoffice
  system(command, wait = FALSE)
  Sys.sleep(sleep_time)

  # Get the UNO objects
  rlo_connect()

  # Set the title if requested
  if (!is.null(title)) {
    python.exec(paste0("doc.DocumentProperties.Title = '", title, "'"))
  }
}
