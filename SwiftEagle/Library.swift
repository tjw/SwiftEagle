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
        assert((path as NSString).pathExtension == Library.PathExtension)
        self.path = path
        self.name = ((path as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
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
        var pads:[Pad] = []
        
        init(_ name:String, library:Library, prefix:String, suffix:String?, frame:Rect) {
            assert(frame.size.w.positive)
            assert(frame.size.h.positive)
            
            self.name = name
            self.library = library
            self.prefix = prefix
            self.suffix = suffix
            self.frame = frame
        }
        
        struct Pin {
            let name:String
            let location:Point
            let direction:Direction
            
            init(name:String, location:Point, direction:Direction) {
                self.name = name
                self.location = location
                self.direction = direction
            }
        }
        
        public func addPin(name:String, location:Point, direction:Direction) {
            // Disallow duplicate pin names, though some devices have muliple GND pins. We'll require our definition to be unique so we know where on the element you are talking about.
            assert(pins.indexOf({ $0.name == name}) == nil)
            
            pins.append(Pin(name:name, location:location, direction:direction))
        }
        
        subscript(pin pinName:String) -> Pin {
            let pinIndex = pins.indexOf({ $0.name == pinName })
            return pins[pinIndex!] // not bothering with error handling; die if you give a bad argument
        }

        // A little Logo-turtle type thing. The starting point is at the tip of a pin, pointing in the direction of the pin.
        public func turtle(pinName pinName:String) -> Turtle {
            let pin = self[pin:pinName]
            let degrees = pin.direction.degrees
            return Turtle(location:pin.location, degrees:degrees)
        }
        
        struct Pad {
            let name:String
            let location:Point // center of the pad -- we don't care about its dimension or whether it is PTH/SMT

            init(name:String, location:Point) {
                self.name = name
                self.location = location
            }
        }
        
        public func addPad(name:String, location:Point) {
            // Disallow duplicate pad names, though some devices have muliple GND connections. We'll require our definition to be unique so we know where on the element you are talking about.
            assert(pads.indexOf({ $0.name == name}) == nil)
            
            pads.append(Pad(name:name, location:location))
        }
        
        subscript(pad padName:String) -> Pad {
            let padIndex = pads.indexOf({ $0.name == padName })
            return pads[padIndex!] // not bothering with error handling; die if you give a bad argument
        }

        // Pads don't have a direction, so we need to specify it.
        public func turtle(padName padName:String, direction:Direction) -> Turtle {
            let pad = self[pad:padName]
            let degrees = direction.degrees
            return Turtle(location:pad.location, degrees:degrees)
        }
    }

}
