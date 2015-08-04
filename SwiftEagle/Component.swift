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
    public let origin:Point
    
    public init(_ name:String, origin:Point) {
        self.name = name
        self.origin = origin
    }
}
