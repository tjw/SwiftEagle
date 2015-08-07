//
//  Direction.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/6/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public enum Direction {
    case Left
    case Right
    case Up
    case Down
    
    // Could make this have a Double rawValue, but prefer the nicer name `direction`
    public var degrees:Double {
        switch(self) {
        case .Right:
            return 0
        case .Up:
            return 90
        case .Left:
            return 180
        case .Down:
            return 270
        }
    }
}
