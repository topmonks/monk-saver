//
//  MonkSettings.swift
//  Monk
//
//  Created by Robert Vojta on 25.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation
import Cocoa
import ScreenSaver

// Number of available monk*.png images
// Images must be named "monk\(x)" where x is 0..<NumberOfMonkLogos
let NumberOfMonkLogos = 4

enum MonkType {
  case Single(index: Int)
  case Random
  case All  
}

struct MonkSettings {
  let type: MonkType
  let count: Int
  let animationTimeInterval: NSTimeInterval
  let monkScale: CGFloat

  static func defaultPreferences() -> MonkSettings {
    return MonkSettings(type: .Random, count: 10, animationTimeInterval: 1.0 / 10.0, monkScale: 0.7)
  }
  
  private static func moduleDefaults() -> ScreenSaverDefaults? {
    return ScreenSaverDefaults(forModuleWithName: "com.topmonks.apps.Monk")
  }
  
  static func load() -> MonkSettings {
    let defaultPreferences = self.defaultPreferences()
    
    guard let defaults = MonkSettings.moduleDefaults() else {
      return defaultPreferences
    }
    
    var count = defaults.integerForKey("count")
    if count == 0 {
      count = defaultPreferences.count
    }
    
    var monkScale = defaults.doubleForKey("monkScale")
    if monkScale == 0.0 {
      monkScale = Double(defaultPreferences.monkScale)
    }
    
    var animationTimeInterval = defaults.doubleForKey("animationTimeInterval")
    if animationTimeInterval == 0.0 {
      animationTimeInterval = defaultPreferences.animationTimeInterval
    }
    
    var type: MonkType = .Random
    if defaults.objectForKey("type") != nil {
      let typeValue = defaults.integerForKey("type")
      if typeValue == -2 {
        type = .All
      } else if typeValue >= 0 {
        type = .Single(index: typeValue)
      }
    } else {
      type = defaultPreferences.type
    }
    
    return MonkSettings(type: type, count: count, animationTimeInterval: animationTimeInterval, monkScale: CGFloat(monkScale))
  }
  
  func save() {
    guard let defaults = MonkSettings.moduleDefaults() else {
      return
    }
    defaults.setInteger(self.count, forKey: "count")
    defaults.setDouble(self.animationTimeInterval, forKey: "animationTimeInterval")
    defaults.setDouble(Double(self.monkScale), forKey: "monkScale")
    switch self.type {
      case .Single(let index):
        defaults.setInteger(index, forKey: "type")
      case .Random:
        defaults.setInteger(-1, forKey: "type")
      case .All:
        defaults.setInteger(-2, forKey: "type")
    }
    defaults.synchronize()
  }
}

// MARK: - Scene Generator

extension MonkSettings {
  func generateScene() -> Scene {
    var scene = Scene()
    
    let bundle = NSBundle(forClass: MainView.self)
    let bounds = NSMakeRect(0, 0, Scene.DefaultWidth, Scene.DefaultHeight)
    var monkImageIndex = self.initialMonkImageIndex(self.type)
    
    for _ in 0..<count {
      guard let image = bundle.imageForResource("monk\(monkImageIndex)") else {
        continue
      }
      
      let origin = self.generateRandomNodeOrigin(image.size, bounds: bounds)
      let direction = self.generateRandomNodeDirection()
      let monk = ImageNode(image: image, scale: self.monkScale, origin: origin, direction: direction)
      scene.nodes.append(monk)
      
      monkImageIndex = self.nextMonkImageIndex(self.type, index: monkImageIndex)
    }
    
    return scene
  }
  
  private func initialMonkImageIndex(type: MonkType) -> Int {
    switch type {
      case .Single(let index):
        return index
      case .All:
        return 0
      case .Random:
        return Int(arc4random_uniform(UInt32(NumberOfMonkLogos)))
    }
  }
  
  private func nextMonkImageIndex(type: MonkType, index: Int) -> Int {
    switch type {
      case .Single(let index):
        return index
      case .All:
        return ( index + 1 ) % NumberOfMonkLogos
      case .Random:
        return Int(arc4random_uniform(UInt32(NumberOfMonkLogos)))
    }
  }
  
  private func generateRandomNodeDirection() -> NSPoint {
    var direction = NSZeroPoint
    while direction.x == 0 || direction.y == 0 {
      let x = arc4random_uniform(1000)
      let y = arc4random_uniform(1000)
      direction = NSMakePoint((CGFloat(x) - 500.0) / 200.0, (CGFloat(y) - 500.0) / 200.0)
    }
    return direction
  }
  
  private func generateRandomNodeOrigin(size: NSSize, bounds: NSRect) -> NSPoint {
    return NSMakePoint(
      CGFloat(arc4random_uniform(UInt32(bounds.size.width - size.width))),
      CGFloat(arc4random_uniform(UInt32(bounds.size.height - size.height)))
    )
  }
}
