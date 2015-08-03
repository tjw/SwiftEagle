//
//  Component.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Component {
    public let name:String
    public let library: Library?
    
    public init(_ name:String, library:Library?) {
        self.name = name
        self.library = library
    }
}
