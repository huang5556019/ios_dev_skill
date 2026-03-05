import Cocoa
import SQLite

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindowController: MainWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do { try DatabaseManager.shared.initialize() } catch { NSLog("数据库初始化失败: \(error)") }
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {}
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { true }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { true }
}
