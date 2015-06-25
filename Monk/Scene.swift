//
//  Scene.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Cocoa
import Darwin

protocol SceneNode: Drawable, Animatable {}

struct Scene: Drawable {
  //
  // Monk images and other stuff was developed on a monitor with this resolution.
  // Leave it as it is and don't worry, screen saver itself scales up/down to
  // fit your screen size / preview pane. If you do modify these numbers, be sure
  // you do scale monk*.png files as well. At least, monk* logos (@1) must be smaller
  // than this resolution to fit.
  //
  static let DefaultWidth: CGFloat  = 1920.0
  static let DefaultHeight: CGFloat = 1080.0
  
  var bounds: NSRect = NSZeroRect
  var nodes: [SceneNode] = []
  
  mutating func append(node: SceneNode) {
    self.nodes.append(node)
  }
  
  func draw(renderer: Renderer) {
    self.nodes.map({ $0.draw(renderer) })
  }
}

func + (lhs: NSPoint, rhs: NSPoint) -> NSPoint {
  return NSMakePoint(lhs.x + rhs.x, lhs.y + rhs.y)
}

extension Scene: Animator {
  
  mutating func animateOneFrame() {
    self.nodes = self.nodes.map({ self.animateOneFrame($0) })
  }
  
  private func animateOneFrame(var node: SceneNode) -> SceneNode {
    let newOrigin = node.origin + node.direction
    var newDirection = node.direction
    
    if newOrigin.x <= CGRectGetMinX(self.bounds) && node.direction.x < 0 {
      newDirection = NSMakePoint(abs(newDirection.x), newDirection.y)
    } else if newOrigin.x + node.size.width >= CGRectGetMaxX(self.bounds) && node.direction.x > 0 {
      newDirection = NSMakePoint(-abs(newDirection.x), newDirection.y)
    }
    if newOrigin.y <= CGRectGetMinY(self.bounds) && node.direction.y < 0 {
      newDirection = NSMakePoint(newDirection.x, abs(newDirection.y))
    } else if newOrigin.y + node.size.height >= CGRectGetMaxY(self.bounds) && node.direction.y > 0 {
      newDirection = NSMakePoint(newDirection.x, -abs(newDirection.y))
    }
    
    node.origin = newOrigin
    node.direction = newDirection
    return node
  }
}
