//
//  PreferencesWindowController.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Cocoa
import ScreenSaver

///
/// Just for bindings
///
class PreferencesModel: NSObject {
  // 0..3 = Monk1..Monk 4, 4 = All, 5 = Random
  dynamic var type: Int
  dynamic var count: Int
  dynamic var speed: Int
  dynamic var size: Int
  
  init(monkSettings: MonkSettings = MonkSettings.load()) {
    self.count = monkSettings.count
    self.speed = Int(1.0 / monkSettings.animationTimeInterval)
    self.size = Int(monkSettings.monkScale * 100.0)
    
    switch monkSettings.type {
      case .Single(let index):
        self.type = index
      case .All:
        self.type = 4
      case .Random:
        self.type = 5
    }
  }
  
  func monkSettings() -> MonkSettings {
    var type: MonkType = .Random
    if self.type == 4 {
      type = .All
    } else if self.type < 4 {
      type = .Single(index: self.type)
    }
    
    return MonkSettings(type: type, count: self.count,
      animationTimeInterval: NSTimeInterval(1.0 / CGFloat(self.speed)),
      monkScale: CGFloat(self.size) / 100.0)
  }
}

@objc protocol PreferencesWindowControllerDelegate {
  func preferencesWindowControllerDidDismiss(controller: PreferencesWindowController, update: Bool)
}

class PreferencesWindowController: NSWindowController {
  weak var delegate: PreferencesWindowControllerDelegate?
  dynamic var preferencesModel: PreferencesModel = PreferencesModel()
  
  override var windowNibName: String! {
    return "Preferences"
  }
    
  @IBAction func ok(sender: AnyObject?) {
    self.preferencesModel.monkSettings().save()
    self.window?.sheetParent?.endSheet(self.window!)
    self.delegate?.preferencesWindowControllerDidDismiss(self, update: true)
  }

  @IBAction func cancel(sender: AnyObject?) {
    self.window?.sheetParent?.endSheet(self.window!)
    self.delegate?.preferencesWindowControllerDidDismiss(self, update: false)
  }
}
