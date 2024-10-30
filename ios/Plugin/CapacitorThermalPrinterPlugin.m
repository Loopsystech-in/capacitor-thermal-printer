#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapacitorThermalPrinterPlugin, "CapacitorThermalPrinter",
           CAP_PLUGIN_METHOD(startScan, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(stopScan, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(connect, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(disconnect, CAPPluginReturnPromise);

           CAP_PLUGIN_METHOD(bold, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(underline, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(doubleWidth, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(doubleHeight, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(inverse, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(barcodeWidth, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(barcodeHeight, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(barcodeTextPlacement, CAPPluginReturnPromise);

           CAP_PLUGIN_METHOD(dpi, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(limitWidth, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(align, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(charSpacing, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(lineSpacing, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(font, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearFormatting, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(text, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(image, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(qr, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(barcode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(raw, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(selfTest, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(beep, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(openDrawer, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(cutPaper, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(feedCutPaper, CAPPluginReturnPromise);
           
           CAP_PLUGIN_METHOD(begin, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(write, CAPPluginReturnPromise);
)
