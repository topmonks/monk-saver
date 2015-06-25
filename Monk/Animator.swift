//
//  Animator.swift
//  Monk
//
//  Created by Robert Vojta on 24.06.15.
//  Copyright © 2015 TopMonks, s.r.o. All rights reserved.
//

import Foundation

protocol Animatable: Drawable {
  var origin: NSPoint { get set }
  var size: NSSize { get }
  var direction: NSPoint { get set }
}

protocol Animator {
  var bounds: NSRect { get set }
  
  mutating func animateOneFrame()
}
