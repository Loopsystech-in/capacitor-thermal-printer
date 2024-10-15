let STATUS_MOVEMENT_ERROR = "Printer movement error";//机芯错误
let STATUS_PAPER_JAMMED_ERROR = "Paper jammed error";//卡纸
let STATUS_NO_PAPER_ERROR = "No Paper";//缺纸
let STATUS_RIBBON_RUNS_OUT_ERROR = "The ribbon runs out";//碳带用尽
let STATUS_PRINTER_PAUSE = "Printer Pause";//打印机暂停，空闲
let STATUS_PRINTER_BUSY = "Printer Busy";//正在打印
let STATUS_PRINTER_LID_OPEN = "The printer's lid is open";//开盖状态
let STATUS_OVERHEATED_ERROR = "The printer is overheated ";//头片过热
let STATUS_READYPRINT = "Ready to print";//打印就绪

class PrinterManager {
    let PrinterList: SafeMutableArray = SafeMutableArray(capacity: 4);
    var currentPrinter: Printer;
    let currentPrinterCmdType: PrinterCmdType;
    let currentPrinterPortType: PrinterPortType;
    let MTULength: Int;
    let sendDelayMS: Int;
    
    public init(
        currentPrinterCmdType: PrinterCmdType,
        currentPrinterPortType: PrinterPortType,
        MTULength: Int = 150,
        sendDelayMS: Int = 20
    ) {
        self.currentPrinterCmdType = currentPrinterCmdType
        self.currentPrinterPortType = currentPrinterPortType
        self.MTULength = MTULength
        self.sendDelayMS = sendDelayMS
        
        self.currentPrinter = ThermalPrinterFactory.create()
//        self.currentPrinter = PrinterManager.createPrinterClass(currentPrinterCmdType)
    }
    class func createESC() -> PrinterManager {
        return PrinterManager(currentPrinterCmdType: PrinterCmdESC, currentPrinterPortType: PrinterPortBle)
    }
    func createCmdClass() -> Cmd {
        switch currentPrinterCmdType {
        case PrinterCmdESC:
            return  ESCFactory.create();
        case PrinterCmdTSC:
            return  TSCFactory.create();
        case PrinterCmdCPCL:
            return CPCLFactory.create();
//        case PrinterCmdPIN:
//            return PinCmdFactory.create();
        case PrinterCmdZPL:
            return ZPLFactory.create();
        default:
            fatalError("unreachable");
        }
    }
    class func createPrinterClass(_ printerCmdType: PrinterCmdType) -> Printer {
        switch printerCmdType {
        case PrinterCmdESC:
            return  ThermalPrinterFactory.create();
        case PrinterCmdTSC, PrinterCmdCPCL, PrinterCmdZPL:
            return LabelPrinterFactory.create();
//        case PrinterCmdPIN:
//            return PinPrinterFactory.create();
        default:
            fatalError("unreachable");
        }
    }
    
    func connectWifi(address: String, port: NSInteger) {
        let printerInter = WIFIFactory.create()!;
        printerInter.address = address;
        printerInter.port = port;
        printerInter.printerCmdtype = self.currentPrinterCmdType;
        currentPrinter.printerPi = printerInter
        currentPrinter.open()
    }
    func connectBLE2(address: String, blueToothPI: RTBlueToothPI) {
        self.currentPrinter = ThermalPrinterFactory.create()
        blueToothPI.mtuLength = self.MTULength;
        blueToothPI.sendDelayMS = self.sendDelayMS;
        blueToothPI.address = address;
        blueToothPI.printerCmdtype = self.currentPrinterCmdType;
        currentPrinter.printerPi = blueToothPI
        currentPrinter.open()
    }
    func connectBLE(address: String) {
        let blueToothPI =  BlueToothFactory.create(BlueToothKind_Ble)!
        blueToothPI.mtuLength = self.MTULength;
        blueToothPI.sendDelayMS = self.sendDelayMS;
        blueToothPI.address = address;
        blueToothPI.printerCmdtype = self.currentPrinterCmdType;
        currentPrinter.printerPi = blueToothPI
        currentPrinter.open()
    }
    func connectMFI(address: String) {
        let blueToothPI =  BlueToothFactory.create(BlueToothKind_Classic)!
        blueToothPI.mtuLength = 1024 * 1024;
        blueToothPI.sendDelayMS = 10;
        blueToothPI.address = address;
        blueToothPI.printerCmdtype = self.currentPrinterCmdType;
        currentPrinter.printerPi = blueToothPI
        currentPrinter.open()
    }
    func disconnect() {
        self.currentPrinter.close()
    }
    
    class func addConnectionObserver(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector ,
            name: NSNotification.Name(BleDeviceConnectedNotify),
            object: nil
        )
        NotificationCenter.default.addObserver(
            observer,
            selector: selector ,
            name: NSNotification.Name.PrinterDisconnected,
            object: nil
        )
        NotificationCenter.default.addObserver(
            observer,
            selector: selector ,
            name: Notification.Name(BleDeviceDataChanged),
            object: nil
        )
    }
    
//    class func showStatus(_ status: PrinterStatusObj) {
//        let handle = {
//            (m: String) in
//            NSLog("STATUS: %@", m)
//        }
//        switch (status.printStautsCmd) {
//        case PrnStautsCmd_Normal:
//            if (status.blMoveMentErr){
//                handle(STATUS_MOVEMENT_ERROR)
//            }
//            if (status.blPaperJammed) {
//                handle(STATUS_PAPER_JAMMED_ERROR);
//            }
//            if (status.blNoPaper) {
//                handle(STATUS_NO_PAPER_ERROR);
//            }
//            if (status.blNoRibon){
//                handle(STATUS_RIBBON_RUNS_OUT_ERROR);
//            }
//            if (status.blPrinterPause) {
//                handle(STATUS_PRINTER_PAUSE);
//            }
//            if (status.blPrinting) {
//                handle(STATUS_PRINTER_BUSY);
//            }
//            if (status.blLidOpened) {
//                handle(STATUS_PRINTER_LID_OPEN);
//            }
//            if (status.blOverHeated) {
//                handle(STATUS_OVERHEATED_ERROR);
//            }
//            if (status.blPrintReady) {
//                handle(STATUS_READYPRINT);
//            }
//            break;
//        case PrnStautsCmd_Mileage:
//            handle(String(format: "Printed Mileage:%ld m", status.printedMileage));
//            break;
//        case PrnStautsCmd_ModelName:
//            handle(String(format: "ModelName=%@ Serial number=%@", status.modelName, status.serialnumber));
//            break;
//        case PrnStautsCmd_MemorySize:
//            handle(String(format: "Memory Size:%ld", status.memorySize));
//            break;
//            
//        case PrnStautsCmd_PrintEnd:
//            if (status.printEndStatus==1)
//            {
//                handle("Print Okay");
//            }
//            break;
//        default:
//            break;
//        }
//    }
}
