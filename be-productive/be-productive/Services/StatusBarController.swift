import AppKit
import SwiftUI

class StatusBarController: ObservableObject {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    
    init(_ popover: NSPopover) {
        self.popover = popover
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusBarButton = statusItem.button {
            statusBarButton.image = NSImage(systemSymbolName: "checkmark.circle", accessibilityDescription: "Productivity App")
            statusBarButton.action = #selector(togglePopover)
            statusBarButton.target = self
        }
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            hidePopover()
        } else {
            showPopover()
        }
    }
    
    func showPopover() {
        if let statusBarButton = statusItem.button {
            popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func hidePopover() {
        popover.performClose(nil)
    }
}
