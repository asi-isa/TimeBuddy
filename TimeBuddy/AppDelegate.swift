//
//  AppDelegate.swift
//  TimeBuddy
//
//  Created by Ali Soner Inceoglu on 30.10.26.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusItem: NSStatusItem?
    var popover = NSPopover()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "Time Buddy"
        
        statusItem?.menu = NSMenu()
        statusItem?.menu?.delegate = self
        
        let contentView = ContentView()
        popover.contentSize = CGSize(width: 500, height: 400)
        popover.contentViewController = NSHostingController(rootView: contentView)
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in self?.popover.performClose(event)
        }
    }
    
    @objc func showSettings() {
        guard let statusBarButton = statusItem?.button else { return }
        
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .maxY)
    }
    
    func addMenuItems() {
        statusItem?.menu?.removeAllItems()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        
        let timezones = UserDefaults.standard.stringArray(forKey: "TimeZones") ?? []
        
        for timezone in timezones {
            guard let zone = TimeZone(identifier: timezone) else { continue }
            
            dateFormatter.timeZone = zone
            
            let formattedTime = dateFormatter.string(from: .now)
            
            statusItem?.menu?.addItem(withTitle: "\(zone.formattedName): \(formattedTime)", action: #selector(copyToClipboard), keyEquivalent: "")
        }
        
        if timezones.isEmpty == false {
            statusItem?.menu?.addItem(.separator())
        }
        
        statusItem?.menu?.addItem(withTitle: "Settings", action: #selector(showSettings), keyEquivalent: "")
        
        statusItem?.menu?.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "")
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        addMenuItems()
        popover.performClose(self)
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    @objc func copyToClipboard(_ sender: NSMenuItem) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(sender.title, forType: .string)
    }
}
