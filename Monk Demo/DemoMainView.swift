//
//  DemoMainView.swift
//  Monk
//
//  Created by Robert Vojta on 29.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation

class DemoMainView: MainView {
  private weak var animationTimer: NSTimer?
  
  override var animationTimeInterval: NSTimeInterval {
    didSet {
      self.animationTimer?.invalidate()
      self.animationTimer = NSTimer.scheduledTimerWithTimeInterval(animationTimeInterval, target: self,
        selector: "animateOneFrame", userInfo: nil, repeats: true)
    }
  }
  
  deinit {
    self.animationTimer?.invalidate()
  }
}
