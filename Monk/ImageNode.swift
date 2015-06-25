//
//  ImageNode.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation
import Cocoa

struct ImageNode: SceneNode {
  let image: NSImage
  let scale: CGFloat
  var origin: NSPoint
  var direction: NSPoint

  var size: NSSize {
    get {
      return NSMakeSize(self.image.size.width * self.scale, self.image.size.height * self.scale)
    }
  }
  
  func draw(renderer: Renderer) {
    renderer.render(self.image, at: self.origin, scale: self.scale)
  }
}
