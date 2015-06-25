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
public class MainView: ScreenSaverView, PreferencesWindowControllerDelegate {
  
  // MARK: - Properties
  
  var monkView: MonkView? {
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
  
  public override init?(frame: NSRect, isPreview: Bool) {
    super.init(frame: frame, isPreview:isPreview)
    self.reloadScene()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.reloadScene()
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
    
  public override func animateOneFrame() {
    guard let monkView = self.monkView else {
      return
    }
    monkView.animateOneFrame()
  }
  
  // MARK: - Preferences
    
  public override func hasConfigureSheet() -> Bool {
    return true
  }

  public override func configureSheet() -> NSWindow? {
    self.preferencesWindowController.delegate = self
    return self.preferencesWindowController.window
  }
  
  func preferencesWindowControllerDidDismiss(controller: PreferencesWindowController, update: Bool) {
    controller.delegate = nil
    
    if update {
      dispatch_async(dispatch_get_main_queue()) { [weak self] () -> Void in
        self?.reloadScene()
      }
    }
  }
}
