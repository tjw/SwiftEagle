//
//  Rect.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/6/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Rect {
    public let origin:Point
    public let size:Size
    
    public init(origin:Point, size:Size) {
        self.origin = origin
        self.size = size;
    }
    public init(x:Measurement, y:Measurement, w:Measurement, h:Measurement) {
        self.origin = Point(x, y)
        self.size = Size(w, h)
    }
    public init(lowerLeft:Point, upperRight:Point) {
        self.origin = lowerLeft
        self.size = Size(upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y)
    }
    public init(center:Point, size:Size) {
        self.init(origin:center - 0.5*size, size:size)
    }

}
