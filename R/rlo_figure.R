rlo_figure <- function(svg_file, caption, aspect = 1, width = 17, height = aspect * width)
{
  rlo_scursor()

  # Insert the SVG file {{{3
  pyExec("fig = doc.createInstance('com.sun.star.text.GraphicObject')")
  pySet("url", paste0("file:///", normalizePath(svg_file)))
  pyExec("fig.GraphicURL = url")
  pyExec("fig.AnchorType = 'AT_PARAGRAPH'")
  rlo_width = width * 1000
  pyExec(paste0("fig.Width = ", rlo_width))
  pyExec(paste0("fig.Height = ", rlo_width * height/width))
  pyExec("text.insertTextContent(scursor, fig, False)")

  # Add the caption {{{3
  pyExec("scursor.setPropertyValue('ParaStyleName', 'Figure')")
  pyExec("text.insertString(scursor, 'Figure ', False)")

  rlo_dispatch(".uno:InsertField", 
    list(Type = 23, SubType = 127, Name = "Figure", Content = "", Format = 4, Separator = " "))
  pyExec("text.insertString(scursor, ': ', False)")
  pySet("captiontext", caption)
  pyExec("text.insertString(scursor, captiontext, False)")
  pyExec("text.insertControlCharacter(scursor, 0, False)")
}
