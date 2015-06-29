//
//  AppDelegate.swift
//  Monk Demo
//
//  Created by Robert Vojta on 29.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  private let preferencesWindowController: PreferencesWindowController = {
    let controller = PreferencesWindowController()
    controller.loadWindow()
    return controller
    }()
  
  @IBAction func showPreferences(sender: AnyObject) {
    guard let window = NSApplication.sharedApplication().mainWindow else {
      return
    }

    window.beginSheet(self.preferencesWindowController.window!) { (response) -> Void in }
  }
  
  func applicationDidFinishLaunching(notification: NSNotification) {
    NSNotificationCenter.defaultCenter().addObserverForName(NSWindowWillCloseNotification, object: nil,
      queue: NSOperationQueue.mainQueue()) { (note) -> Void in
        NSApplication.sharedApplication().terminate(note.object)
    }
  }
  
  func windowWillClose(notification: NSNotification) {
    NSApplication.sharedApplication().terminate(nil)
  }
}
