//
//  LIbrary.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public class Library {
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

    public func element(name:String, prefix:String, suffix:String? = nil, frame:Rect) -> Element {
        return Element(name, library:self, prefix:prefix, suffix:suffix, frame:frame)
    }
    
    // An element in a library that can be added to a design
    public class Element {
        public let name:String // The name of the device in the library
        public let prefix:String // When creating components in a design, what prefix to use by default in their name ("C" for a capacitor, for example)
        public let suffix:String?
        
        public let library: Library
        
        public let frame:Rect // The rectangle enclosing the element when it is at the origin

        var pins:[Pin] = []
        
        init(_ name:String, library:Library, prefix:String, suffix:String?, frame:Rect) {
            assert(frame.size.w.positive)
            assert(frame.size.h.positive)
            
            self.name = name
            self.library = library
            self.prefix = prefix
            self.suffix = suffix
            self.frame = frame
            
        }
        
        public enum PinDirection {
            case Left
            case Right
            case Up
            case Down
        }
        
        struct Pin {
            let name:String
            let location:Point
            let direction:PinDirection
            
            init(name:String, location:Point, direction:PinDirection) {
                self.name = name
                self.location = location
                self.direction = direction
            }
        }
        
        public func addPin(name:String, location:Point, direction:PinDirection) {
            // Disallow duplicate pin names, though some devices have muliple GND pins. We'll require our definition to be unique so we know where on the element you are talking about.
            assert(pins.indexOf({ $0.name == name}) == nil)
            
            pins.append(Pin(name:name, location:location, direction:direction))
        }
    }

}
