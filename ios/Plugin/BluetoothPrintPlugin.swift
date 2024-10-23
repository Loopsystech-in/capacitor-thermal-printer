import Foundation
import Capacitor
import CoreBluetooth

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(BluetoothPrintPlugin)
public class BluetoothPrintPlugin: CAPPlugin {
    let fonts = ["A", "B"];
    let alignments = ["left", "center", "right"];
    let placements = ["none", "above", "below", "both"];
    let barcodeTypes = [
        "UPC_A",
        "EAN8",
        "EAN13",
        "CODE39",
        "ITF",
        "CODABAR",
        "CODE128",
    ];
    let fontEnumValues = [ESCFontType_FontA, ESCFontType_FontB];
    let placementEnumValues = [BarcodeHRIpos_noprint, BarcodeHRIpos_above, BarcodeHRIpos_Below, BarcodeHRIpos_both];
    let barcodeTypeEnumValues = [
        BarcodeTypeUPC_A,
        BarcodeTypeEAN8,
        BarcodeTypeEAN13,
        BarcodeTypeCODE39,
        BarcodeTypeITF,
        BarcodeTypeCODABAR,
        BarcodeTypeCODE128,
    ];

    let manager: PrinterManager = PrinterManager.createESC();
    let blueToothPI = BlueToothFactory.create(BlueToothKind_Ble)!
    
    var cmd = ESCCmd();
    var textSetting = TextSetting();
    var bitmapSetting = BitmapSetting();
    var dataCodeSetting = BarcodeSetting();
   
    var isScanning = false;
    var discoveryFinish: DispatchWorkItem?;
    
    public override init() {
        super.init()
        
        let handleNotificationSelector = #selector(self.handleNotification(notification: ));
        
        let notifications = [
            NSNotification.Name(BleDeviceConnectedNotify),
            NSNotification.Name(BleServiceFindDevice),
            //                NSNotification.Name(BleDeviceRssiChanged),
            NSNotification.Name(BleServiceStatusChanged),
            NSNotification.Name.PrinterConnected,
            NSNotification.Name.PrinterDisconnected,
            NSNotification.Name(BleDeviceDataChanged)
        ];
        for notification in notifications {
            NSLog("Observing Notifications %@", notification.rawValue)
            NotificationCenter.default.addObserver(
                self,
                selector: handleNotificationSelector,
                name: notification,
                object: nil
            )
        }
    }

    @objc
    func handleNotification(notification: Notification) {
        DispatchQueue.main.async {
            switch notification.name {
            case NSNotification.Name(BleServiceFindDevice):
                let devices = self.blueToothPI.getBleDevicelist() as! [RTDeviceinfo]
                self.notifyListeners("discoverDevices", data: [
                    "devices": devices.map({
                        return [
                            "name": $0.name,
                            "address": $0.uuidString
                        ]
                    })
                ])
                break;
            case NSNotification.Name.PrinterConnected:
                if notification.object == nil {
                    break;
                }
                if (notification.object as! ObserverObj?)?.msgobj == nil {
                    break;
                }
                
                self.notifyListeners("connected", data: nil)
                break;
            case NSNotification.Name.PrinterDisconnected:
                self.notifyListeners("disconnected", data: nil)
                break;
            case NSNotification.Name(BleDeviceDataChanged):
                let status = (notification.object as! ObserverObj).msgobj as! PrinterStatusObj;
                
                self.notifyListeners("datachanged", data: nil)
                break;
                
            default:
                break;
            }
        }
        
    }
    
    @objc func startScan(_ call: CAPPluginCall) {
        if (isScanning) {
            call.reject("Already Scanning!");
            return;
        }

        isScanning = true;
        blueToothPI.startScan(30, isclear: true)
        
        discoveryFinish = DispatchWorkItem(block: {
            if  self.discoveryFinish == nil ||
                self.discoveryFinish!.isCancelled {
                return
            }
            
            self.discoveryFinish!.cancel();
    
            self.discoveryFinish = nil;
            self.isScanning = false;
            self.notifyListeners("discoveryFinish", data: nil);
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: discoveryFinish!);
        
        call.resolve()
    }
    @objc func stopScan(_ call: CAPPluginCall) {
        blueToothPI.stopScan()

        discoveryFinish?.perform()
        call.resolve()
    }
    
    @objc func connect(_ call: CAPPluginCall) {
        guard let address = call.getString("address") else { call.reject("Please provide address!"); return }
        
        
        //        blueToothPI.stopScan()
        manager.connectBLE(address: address)
        NSLog("CONNECT %@", address)
        
        call.resolve()
    }
    @objc func disconnect() {
        manager.disconnect()
    }
    
    // MARK: - Text Formatting
    @objc func bold(_ call: CAPPluginCall) {
        textSetting.isBold = parseIsEnabled(call);
        call.resolve();
    }
    @objc func underline(_ call: CAPPluginCall) {
        textSetting.isUnderline = parseIsEnabled(call);
        call.resolve();
    }
    @objc func doubleWidth(_ call: CAPPluginCall) {
        textSetting.isTimes_Wide = parseIsEnabled(call);
        call.resolve();
    }
    @objc func doubleHeight(_ call: CAPPluginCall) {
        textSetting.isTimes_Heigh = parseIsEnabled(call);
        call.resolve();
    }
    @objc func inverse(_ call: CAPPluginCall) {
        textSetting.isInverse = parseIsEnabled(call);
        call.resolve();
    }
    
    // MARK: - Image Formatting
    var currentDPI = 8;
    @objc func dpi(_ call: CAPPluginCall) {
        let dpi = call.getInt("dpi");
        
        currentDPI = dpi == 300 ? 12: 8;
        call.resolve();
    }
    @objc func limitWidth(_ call: CAPPluginCall) {
        let width = call.getInt("width", 1);

        bitmapSetting.limitWidth = width * currentDPI;
        call.resolve();
    }

    // MARK: - Data Code Formatting
    @objc func barcodeWidth(_ call: CAPPluginCall) {
        let width = call.getInt("width", 0);
        dataCodeSetting.coord.width = width;
        call.resolve();
    }
    @objc func barcodeHeight(_ call: CAPPluginCall) {
        let height = call.getInt("height", 0);
        dataCodeSetting.coord.height = height;
        call.resolve();
    }
    @objc func barcodeTextPlacement(_ call: CAPPluginCall) {
        let placement = placements.firstIndex(of: call.getString("placement", "none"));
        if let placement = placement {
            dataCodeSetting.hriPos = placementEnumValues[placement];
            call.resolve();
        } else {
            call.reject("Invalid Placement");
        }
    }

    // MARK: - Hybrid Formatting
    func _align(_ alignment: Int) {
        var alignment = alignment;
        if alignment > 2 || alignment < 0 {
            alignment = 0;
        }
        cmd.append(Data([27, 97, UInt8(truncating: alignment as NSNumber)]))
    }
    func _lineSpacing(_ spacing: Int) {
        var spacing = spacing;
        if spacing < 0 {
            spacing = 0;
        }
        if spacing > 255 {
            spacing = 255;
        }
        cmd.append(Data([27, 51, UInt8(truncating: spacing as NSNumber)]))
    }
    func _charSpacing(_ spacing: Int) {
        var spacing = spacing;
        if spacing < 0 {
            spacing = 0;
        }
        if spacing > 30 {
            spacing = 30;
        }
        cmd.append(Data([27, 32, UInt8(truncating: spacing as NSNumber)]))
    }
    @objc func align(_ call: CAPPluginCall) {
        let alignmentName = call.getString("alignment", "left");
        let alignment = alignments.firstIndex(of: alignmentName);
        if let alignment = alignment {
            _align(alignment)
            call.resolve();
        } else {
            call.reject("Invalid Alignment");
        }
    }
    @objc func lineSpacing(_ call: CAPPluginCall) {
        let spacing = call.getInt("lineSpacing", 0);
        _lineSpacing(spacing)
        call.resolve();
    }
    @objc func charSpacing(_ call: CAPPluginCall) {
        let spacing = call.getInt("charSpacing", 0);
        _charSpacing(spacing)
        call.resolve();
    }
    
    @objc func font(_ call: CAPPluginCall) {
        let font = fonts.firstIndex(of: call.getString("font", "A"));
        if let font = font {
            textSetting.escFonttype = fontEnumValues[font];
            dataCodeSetting.hriFonttype = fontEnumValues[font];
            call.resolve();
        } else {
            call.reject("Invalid Font");
        }
    }
    @objc func clearFormatting(_ call: CAPPluginCall) {
        textSetting = TextSetting()
        bitmapSetting = BitmapSetting()
        dataCodeSetting = BarcodeSetting()
        
        textSetting.alignmode = Align_NoSetting
        textSetting.isTimes_Wide = Set_DisEnable
        textSetting.isTimes_Heigh = Set_DisEnable
        textSetting.isUnderline = Set_DisEnable
        textSetting.isBold = Set_DisEnable
        bitmapSetting.alignmode = Align_NoSetting
        bitmapSetting.limitWidth = 45 * 8;
        currentDPI = 8;
        dataCodeSetting.alignmode = Align_NoSetting;
        dataCodeSetting.coord.width = 3;
        dataCodeSetting.coord.height = 72;
        dataCodeSetting.high = 25;
        // Reset Action Formatters
        _align(0);
        _lineSpacing(30);
        _charSpacing(1);

        call.resolve();
    }
    
    // MARK: - Content
    @objc func text(_ call: CAPPluginCall) {
        let text = call.getString("text", "");

        cmd.append(cmd.getTextCmd(textSetting, text: text))
        call.resolve();
    }
    @objc func image(_ call: CAPPluginCall) {
        let dataurl = call.getString("image", "");

        let base64: String;
        if let i = dataurl.firstIndex(of: ",") {
            base64 = String(dataurl[dataurl.index(after: i)...]);
        } else {
            base64 = dataurl;
        }

        let data = Data(base64Encoded: base64);
        if let data = data {
            let img = UIImage(data: data);
            cmd.append(cmd.getBitMapCmd(bitmapSetting, image: img));
            call.resolve();
        } else {
            call.reject("Invalid Image");
        }
    }
    
    @objc func qr(_ call: CAPPluginCall) {
        let data = call.getString("data", "");

        let error: UnsafeMutablePointer<PrinterCodeError> = UnsafeMutablePointer.allocate(capacity: 1);
        let bytes = cmd.getBarCodeCmd(dataCodeSetting, codeType: BarcodeTypeQrcode, scode: data, codeError: error);

        error.deallocate();

        cmd.append(bytes);        
        call.resolve();
    }
    @objc func barcode(_ call: CAPPluginCall) {
        guard let type = barcodeTypes.firstIndex(of: call.getString("type", "")) else { call.reject("Invalid Type"); return };
        let data = call.getString("data", "");

        let error: UnsafeMutablePointer<PrinterCodeError> = UnsafeMutablePointer.allocate(capacity: 1);
        let bytes = cmd.getBarCodeCmd(dataCodeSetting, codeType: barcodeTypeEnumValues[type], scode: data, codeError: error);

        error.deallocate();

        cmd.append(bytes);
        call.resolve();
    }
    
    @objc func raw(_ call: CAPPluginCall) {
        let base64 = call.getString("data");
        if let base64 = base64 {
            if let data = Data(base64Encoded: base64) {
                cmd.append(data);
                call.resolve();
            } else {
                call.reject("Invalid Data");
            }
            return;
        }
        guard let dataArray = call.getArray("data") as! [NSNumber]? else { call.reject("Invalid Data"); return }
        
        var data = Data(count: dataArray.count)
        for i in 0..<data.count {
            data[i] = UInt8(truncating: dataArray[i]);
        }

        cmd.append(data);
        call.resolve();
    }
    @objc func selfTest(_ call: CAPPluginCall) {
        cmd.append(cmd.getSelftestCmd())
        call.resolve();
    }
    // MARK: - Content Actions
    @objc func beep(_ call: CAPPluginCall) {
        cmd.append(cmd.getBeepCmd(1, interval: 3))
        call.resolve();
    }
    @objc func openDrawer(_ call: CAPPluginCall) {
        cmd.append(cmd.getOpenDrawerCmd(0, startTime: 32, endTime: 1))
        call.resolve();
    }
    @objc func cutPaper(_ call: CAPPluginCall) {
        let half = call.getBool("half", false);
        cmd.append(cmd.getCutPaperCmd(half ? CutterMode_half: CutterMode_Full))
        call.resolve();
    }
    @objc func feedCutPaper(_ call: CAPPluginCall) {
        cmd.append(Data([10 /* character code of "\n" */]))
        cutPaper(call)
        call.resolve();
    }

    // MARK: Printing Actions
    @objc func begin(_ call: CAPPluginCall) {
        cmd = ESCCmd();
        cmd.encodingType = Encoding_UTF8;

        clearFormatting(call)
    }
    @objc func write(_ call: CAPPluginCall) {
        _writeRaw(call, cmd.getCmd())
    }
    
    // MARK: - Utils
    func _writeRaw(_ call: CAPPluginCall, _ data: Data?) {
        if (!manager.currentPrinter.isOpen) {
            call.reject("Printer is not connected!");
            return
        }
        

        let escCmd = manager.createCmdClass()
        escCmd.clear()
        escCmd.encodingType = Encoding_UTF8
        escCmd.append(escCmd.getHeaderCmd())
        escCmd.append(data)
        escCmd.append(escCmd.getLFCRCmd())
        escCmd.append(escCmd.getPrintEnd()!)
        
        NSLog("Printing to %@", self.manager.currentPrinter.printerPi.address);
        self.manager.currentPrinter.write(escCmd.getCmd())
        call.resolve()
    }
    func parseIsEnabled(_ call: CAPPluginCall) -> SettingMode {
        if (call.getString("enabled") == "default") {
            return Set_NoSetting
        }

        return call.getBool("enabled", true) ? Set_Enabled: Set_DisEnable;
    }
}
