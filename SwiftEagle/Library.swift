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
    
    init(path:String) {
        assert(path.pathExtension == Library.PathExtension)
        self.path = path
        self.name = path.lastPathComponent.stringByDeletingPathExtension
    }
    
    init(name:String) {
        self.path = nil // Must be in a default search location
        self.name = name
    }

    public func element(name:String, prefix:String, suffix:String? = nil) -> Element {
        return Element(name, library:self, prefix:prefix, suffix:suffix)
    }
    
    // An element in a library that can be added to a design
    public struct Element {
        public let name:String // The name of the device in the library
        public let prefix:String // When creating components in a design, what prefix to use by default in their name ("C" for a capacitor, for example)
        public let suffix:String?
        
        public let library: Library?
        
        init(_ name:String, library:Library?, prefix:String, suffix:String?) {
            self.name = name
            self.library = library
            self.prefix = prefix
            self.suffix = suffix
        }
    }

}
