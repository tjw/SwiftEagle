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
        let pin = element[name]
        return transform.apply(pin.location)
    }
}
