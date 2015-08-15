//
//  Size.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/6/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Size {
    public let w, h: Measurement
    
    public init(_ w:Measurement, _ h: Measurement) {
        self.w = w
        self.h = h
    }
}

public func *(size:Size, scale:Double) -> Size {
    return Size(size.w * scale, size.h * scale)
}
public func *(scale:Double, size:Size) -> Size {
    return Size(size.w * scale, size.h * scale)
}
