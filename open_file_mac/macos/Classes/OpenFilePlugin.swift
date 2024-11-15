import Cocoa
import FlutterMacOS

public class OpenFilePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "open_file", binaryMessenger: registrar.messenger)
        let instance = OpenFilePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "open_file":
            let arguments = call.arguments as? Dictionary<String,Any>
            let filePath = arguments!["file_path"] as? String
            if(filePath==nil){
                self.result(result:result,message:"the file path cannot be null",type:-4)
                return
            }
            let fileExist = FileManager.default.fileExists(atPath: filePath!)
            if(fileExist){
                let documentURL = URL(fileURLWithPath: filePath!)
                let fileType = documentURL.pathExtension
                if(!canOpen(filePath: filePath!)){
                    self.openSelectPanel(filePath:filePath!,fileType: fileType ,result: result)
                }else{
                    self.open(documentURL: documentURL, result: result)
                }
            }else{
                self.result(result:result,message:"the file does not exist",type:-2)
            }
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func canOpen(filePath: String) ->Bool{
        return FileManager.default.isReadableFile(atPath: filePath)
    }
    
    private func convertDictionaryToString(dict:[String:Any]) -> String {
        var result:String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                result = JSONString
            }
            
        } catch {
            result = ""
        }
        return result
    }
    
    private func openSelectPanel(filePath:String,fileType: String,result: @escaping FlutterResult){
        let fileUrl = URL(fileURLWithPath:filePath)
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = [fileType]
        openPanel.directoryURL = fileUrl
        openPanel.showsHiddenFiles = true
        openPanel.allowsOtherFileTypes = false
        let currentLanguage = Locale.current.languageCode
        openPanel.prompt = (currentLanguage == "zh") ?"允许":"Accept"
        openPanel.beginSheetModal(for: NSApplication.shared.mainWindow!) { (openResult) in
            if (openResult.rawValue == NSApplication.ModalResponse.OK.rawValue) {
                let selectedURL = openPanel.url!
                var isReadable: Bool = false
                if FileManager.default.fileExists(atPath: selectedURL.path, isDirectory: nil) && FileManager.default.isReadableFile(atPath: selectedURL.path) {
                    isReadable = true
                }
                if isReadable {
                    self.open(documentURL: fileUrl, result: result)
                } else {
                    self.result(result:result,message:"Operation not permitted",type:-3)
                }
            }else{
                self.result(result:result,message:"Operation not permitted",type:-3)
            }
        }
    }
    
    private func open(documentURL:URL,result: FlutterResult){
        NSWorkspace.shared.open([documentURL], withAppBundleIdentifier: nil, options: .default, additionalEventParamDescriptor: nil, launchIdentifiers: nil)
        self.result(result:result,message:"done",type:0)
    }
    
    private func result(result: FlutterResult,message:String,type:Int){
        let map = ["message":message, "type":type]as [String : Any]
        result(convertDictionaryToString(dict: map))
    }
    
    @available(*, deprecated, message: "This method is just test.")
    private func requestDiskPermission(onGranted:()->Void,onDenied:()->Void){
        
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
            if NSWorkspace.shared.open(url) {
                print("Opened successfully")
            }else{
                onDenied()
                return
            }
        }
        
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let status = AXIsProcessTrustedWithOptions(options)
        
        if (status != true) {
            print("Prompting for accessibility permissions")
            let alert = NSAlert()
            alert.messageText = "This app requires disk permissions to function properly. Please grant access in the System Preferences app when prompted."
            alert.addButton(withTitle: "OK")
            alert.runModal()
            onDenied()
            return
        }
        
        let task = Process()
        task.launchPath = "/usr/bin/sqlite3"
        task.arguments = ["/Library/Application Support/com.apple.TCC/TCC.db", "INSERT INTO access VALUES('kTCCServiceSystemPolicyAllFiles', '\(Bundle.main.bundleIdentifier!)', 0, 1, 0, NULL);"]
        task.launch()
        task.waitUntilExit()
        onGranted()
        print("Full Disk Access granted successfully")
        
    }
    
    func checkFullDiskAccess() -> Bool {
        let fileManager = FileManager.default
        let testFilePath = "/Library/Application Support/com.apple.TCC/TCC.db"
        
        if fileManager.isReadableFile(atPath: testFilePath) {
            return true
        } else {
            return false
        }
    }
    
    @available(*, deprecated, message: "This method is no longer used.")
    private func getUTI(fileType:String)->String{
        var uti = ""
        switch fileType.lowercased(){
        case "rtf":
            uti = "public.rtf"
        case "txt":
            uti = "public.plain-text"
        case "html","htm":
            uti = "public.html"
        case "xml":
            uti = "public.xml"
        case "tar":
            uti = "public.tar-archive"
        case "gz","gzip":
            uti = "org.gnu.gnu-zip-archive"
        case "tgz":
            uti = "org.gnu.gnu-zip-tar-archive"
        case "jpg","jpeg":
            uti = "public.jpeg"
        case "png":
            uti = "public.png"
        case "avi":
            uti = "public.avi"
        case "mpg","mpeg":
            uti = "public.mpeg"
        case "mp4":
            uti = "public.mpeg-4"
        case "3gpp","3gp":
            uti = "public.3gpp"
        case "mp3":
            uti = "public.mp3"
        case "zip":
            uti = "com.pkware.zip-archive"
        case "gif":
            uti = "com.compuserve.gif"
        case "bmp":
            uti = "com.microsoft.bmp"
        case "ico":
            uti = "com.microsoft.ico"
        case "doc":
            uti = "com.microsoft.word.doc"
        case "xls":
            uti = "com.microsoft.excel.xls"
        case "ppt":
            uti = "com.microsoft.powerpoint.​ppt"
        case "wav":
            uti = "com.microsoft.waveform-​audio"
        case "wm":
            uti = "om.microsoft.windows-​media-wm"
        case "wmv":
            uti = "om.microsoft.windows-​media-wmv"
        case "pdf":
            uti = "com.adobe.pdf"
        default:
            uti = ""
        }
        return uti
    }
}
