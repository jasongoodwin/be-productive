import SwiftUI

@main
struct be_productiveApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var statusBar: StatusBarController
    
    init() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 700, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext))
        
        _statusBar = StateObject(wrappedValue: StatusBarController(popover))
    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

