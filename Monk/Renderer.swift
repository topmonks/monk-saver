//
//  Drawable.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Cocoa

protocol Drawable {
  func draw(renderer: Renderer)
}

struct Scaled<Base: Drawable> : Drawable {
  let scale: CGFloat
  let subject: Base
  
  func draw(renderer: Renderer) {
    subject.draw(ScaledRenderer(base: renderer, scale: scale))
  }
}

protocol Renderer {
  func render(image: NSImage, at: NSPoint, scale: CGFloat)
}

struct ScaledRenderer: Renderer {
  let base: Renderer
  let scale: CGFloat
  
  func render(image: NSImage, at: NSPoint, scale: CGFloat) {
    base.render(image, at: NSMakePoint(at.x * self.scale, at.y * self.scale), scale: self.scale * scale)
  }
}
