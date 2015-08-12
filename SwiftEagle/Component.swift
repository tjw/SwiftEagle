//
//  Component.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

// An instantiated instance of a Library.Element.
public struct Component {
    public let name:String
    public let element:Library.Element
    public let transform:Transform
    
    public init(_ name:String, element:Library.Element, transform:Transform) {
        self.name = name
        self.element = element
        self.transform = transform
    }
    
    public var origin:Point {
        return transform.translate
    }
    
    public func pinLocation(name:String) -> Point {
        let pin = element[pin:name]
        return transform.apply(pin.location)
    }
    
    public func turtle(pinName:String) -> Turtle {
        // Element-space turtle
        let pinTurtle = element.turtle(pinName)
        
        // Step it forward 1mm
        let forward = pinTurtle.move(Millimeter(1))
        
        // Transform both points (which might to a mirror, rotate, etc).
        let head = transform.apply(pinTurtle.location)
        let tail = transform.apply(forward.location)
        
        let d = tail - head
        
        let radians = atan2(d.y.value, d.x.value)
        
        return Turtle(location: head, degrees: radians * 360 / (2.0 * M_PI))
    }
    
    public func padLocation(name:String) -> Point {
        let pad = element[pad:name]
        return transform.apply(pad.location)
    }
}
