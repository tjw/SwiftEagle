//
//  Measurement.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public enum Measurement {
    case Millimeter(Double)
    case Inch(Double)
    case Mil(Double)
    
    public var formatted: String {
        switch self {
        case .Millimeter(let v):
            return "\(v)mm"
        case .Inch(let v):
            return "\(v)in"
        case .Mil(let v):
            return "\(v)mil"
        }
    }
}
