//
//  MonkView.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation
import Cocoa

func calculateScale(forFrame frame: NSRect) -> CGFloat {
  let horizontalScale = frame.size.width / Scene.DefaultWidth
  let verticalScale = frame.size.height / Scene.DefaultHeight
  return min(horizontalScale, verticalScale)
}

class MonkView: NSView {
  private var scale: CGFloat = 1.0 {
    didSet {
      self.redraw()
    }
  }
    
  override var frame: NSRect {
    didSet {
      self.scene?.bounds = self.sceneBounds()
      self.scale = calculateScale(forFrame: self.frame)
    }
  }

  var scene: Scene? {
    didSet {
      self.scene?.bounds = self.sceneBounds()
      self.redraw()
    }
  }
  
  func sceneBounds() -> NSRect {
    let scale = calculateScale(forFrame: self.bounds)
    let viewBounds = self.convertRect(self.bounds, fromView: self)
    return NSMakeRect(0, 0, viewBounds.size.width / scale, viewBounds.size.height / scale)
  }
  
  func animateOneFrame() {
    self.scene?.animateOneFrame()
    self.redraw()
  }
  
  func redraw() {
    self.setNeedsDisplayInRect(self.bounds)
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    guard let scene = self.scene else {
      return
    }
    Scaled(scale: self.scale, subject: scene).draw(self)
  }
}

extension MonkView: Renderer {
  
  func render(image: NSImage, at: NSPoint, scale: CGFloat) {
    let frame = NSMakeRect(at.x, at.y, image.size.width * scale, image.size.height * scale)
    image.drawInRect(frame, fromRect: NSZeroRect, operation: .CompositeSourceOver, fraction: 1.0)
  }
  
}