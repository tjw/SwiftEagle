//
//  Point.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Point {
    public let x, y: Measurement
    
    public init(_ x:Measurement, _ y: Measurement) {
        self.x = x
        self.y = y
    }
    
    public var formatted:String {
        return "(\(x.formatted) \(y.formatted))"
    }
}
