//
//  Layer.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public enum Layer: UInt {
    case Top = 1
    case Bottom = 16
    case Dimension = 20
    
    case TopStopMask = 29
    case BottomStopMask = 30
    
    case TopKeepout = 39
    case BottomKeepout = 40
    case TopRestrict = 41
    case BottomRestrict = 42
}
