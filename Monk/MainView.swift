//
//  MainView.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation
import ScreenSaver
import Cocoa

///
/// Simple wrapper around `MonkView` in case you would like to test and
/// debug it in application, because screen saver debugging is not so easy.
///
class MainView: ScreenSaverView {
  
  // MARK: - Properties    
  private var preferencesObserver: NSObjectProtocol?
  
  private var monkView: MonkView? {
    didSet {
      oldValue?.removeFromSuperview()
      guard let newView = self.monkView else {
        return
      }
      newView.autoresizingMask = [ NSAutoresizingMaskOptions.ViewHeightSizable, NSAutoresizingMaskOptions.ViewWidthSizable ]
      newView.frame = self.bounds
      self.addSubview(newView)
    }
  }
  
  let preferencesWindowController: PreferencesWindowController = {
    let controller = PreferencesWindowController()
    controller.loadWindow()
    return controller
  }()
  
  // MARK: - Initialization
  
  deinit {
    if let observer = self.preferencesObserver {
      NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
  }
  
  override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview:isPreview)
    self.registerObserver()
    self.reloadScene()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.registerObserver()
    self.reloadScene()
  }
  
  private func registerObserver() {
    if let observer = self.preferencesObserver {
      NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    self.preferencesObserver = NSNotificationCenter.defaultCenter().addObserverForName(PreferencesDidChangeNotification,
      object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self] (note) -> Void in
        self?.reloadScene()
    })
  }
  
  private func reloadScene() {
    let preferences = MonkSettings.load()
    self.preferencesWindowController.preferencesModel = PreferencesModel()
    self.animationTimeInterval = preferences.animationTimeInterval
    let view = MonkView(frame: NSZeroRect)
    view.scene = preferences.generateScene()
    self.monkView = view
  }
  
  // MARK: - Animation
    
  override func animateOneFrame() {
    guard let monkView = self.monkView else {
      return
    }
    monkView.animateOneFrame()
  }
  
  // MARK: - Preferences
    
  override func hasConfigureSheet() -> Bool {
    return true
  }

  override func configureSheet() -> NSWindow? {
    return self.preferencesWindowController.window
  }
}
