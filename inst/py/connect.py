import uno
import unohelper
from com.sun.star.beans import PropertyValue
from array import array

localContext = uno.getComponentContext()
resolver = localContext.ServiceManager.createInstanceWithContext(
        "com.sun.star.bridge.UnoUrlResolver", localContext)
ctx = resolver.resolve("uno:socket,host=localhost,port=8100;urp;StarOffice.ComponentContext")
smgr = ctx.ServiceManager
desktop = smgr.createInstanceWithContext("com.sun.star.frame.Desktop", ctx)
dispatcher = smgr.createInstance("com.sun.star.frame.DispatchHelper")
doc = desktop.getCurrentComponent()
text = doc.Text
bm = doc.Bookmarks
