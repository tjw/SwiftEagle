//
//  LIbrary.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Library {
    public static let PathExtension = "lbr"
    
    public let path:String?
    public let name:String
    
    public init(path:String) {
        assert(path.pathExtension == Library.PathExtension)
        self.path = path
        self.name = path.lastPathComponent.stringByDeletingPathExtension
    }
    
    public init(name:String) {
        self.path = nil // Must be in a default search location
        self.name = name
    }
}

