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
    
    case TopPlace = 21
    case BottomPlace = 22

    case TopOrigins = 23
    case BottomOrigins = 24
    
    case TopNames = 25
    case BottomNames = 26
    
    case TopStopMask = 29
    case BottomStopMask = 30
    
    case TopKeepout = 39
    case BottomKeepout = 40
    case TopRestrict = 41
    case BottomRestrict = 42
    
    case TopDocumentation = 51
    case BottomDocumentation = 52
}
