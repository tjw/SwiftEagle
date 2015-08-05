//
//  Eagle.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

/*

An EAGLE script.

There are probably reasons to use the ULP (User Level Program) support in EAGLE itself, but having a Swift interface that produces a command script seems like it can hide some of the nastiness (at the expense of having extra steps).

*/

public class Eagle {
    
    // Required path extension for EAGLE scripts
    public static let pathExtension:String = "scr"
    
    public init() {
        
    }
    
    public func string() -> String {
        return buffer
    }
    
    // MARK:- Basic commands
    
    public enum GridType : String {
        case Dots = "dots"
        case Lines = "lines"
    }
    
    public func grid(measurement:Measurement, alternate:Bool = false, visible:Bool = true, type:GridType = .Dots, factor:UInt? = nil) {
        var cmd = "grid"
        
        // EAGLE doesn't allow separate visibility/type for the main and alternate grid, so 'grid alt off' is not valid. We'll just ignore the visible option in this case...
        if alternate {
            cmd += " alt"
        } else {
            let visibility = visible ? "on" : "off"
            cmd += " \(visibility) \(type.rawValue)"
        }
        
        cmd += " \(measurement.unit) \(measurement.value)"
        
        if let factor = factor {
            cmd += " \(factor)"
        }
        
        command(cmd)
    }
    
    public func addLibrary(path path:String) -> Library {
        command("use \(path)")
        return Library(path: path)
    }
    public func addLibrary(name name:String) -> Library {
        command("use \(name)")
        return Library(name: name)
    }

    public func removeLibrary(library:Library) {
        command("use -* \(library.name)")
    }
    
    var componentNames: Set<String> = []
    var componentCountByPrefix: [String:UInt] = [:]
    
    // In the schematic editor, the angle must be 0, 90, 180, or 270.
    public func addComponent(element:Library.Element, name:String? = nil, origin:Point, degrees:Double = 0) -> Component {
        let fullName = element.library != nil ? "\(element.name)@\(element.library!.name)" : element.name
        
        var cmd = "add \(fullName)"
        
        var componentName: String
        if name == nil {
            let prefix = element.prefix
            let componentIndex = componentCountByPrefix[prefix] ?? 0
            componentName = "\(prefix)\(componentIndex)"
            
            if let s = element.suffix {
                componentName += s
            }
            componentCountByPrefix[prefix] = componentIndex + 1
        } else {
            componentName = name!
        }
        
        assert(componentNames.contains(componentName) == false)
        componentNames.insert(componentName)
        
        cmd += " \(componentName)"
        cmd += " \(origin.formatted)"
        
        // Sadly, appending a rotation here doesn't work reliably (when run directly from the editor, if you leave the ';' off the command when issuing it, the mouse pointer is configured to drop components at the desired rotation, but the added component is at angle zero).
        // So, we'll issue a rotate command below instead (if needed)
        //if let degrees = degrees {
        //    cmd += " R\(Int(degrees))"
        //}
        
        command(cmd)
 
        let result = Component(componentName, origin:origin)
        
        if degrees != 0 {
            rotate(result, degrees:degrees)
        }
        
        return result
    }
    
    // In the schematic editor, the angle must be 0, 90, 180, or 270.
    // The angle is added to the current angle of the component unless 'absolute' is specified
    public func rotate(component:Component, degrees:Double, absolute:Bool = false) {
        var cmd = "rotate "
        
        if absolute {
            cmd += "="
        }
        
        cmd += "R\(degrees) \(component.name)"
        command(cmd)
    }
    
    // Sadly, the net command doesn't take pin names, only locations and the scripting language doesn't have any way to get this.
    // This means you have to know the offsets of pins relative to their element's origin in order to make connections
    public func net(from from:Point, to:Point, auto_end:Bool = true) {
        var cmd = "net \(from.formatted) \(to.formatted)"
        
        if auto_end == false {
            cmd += " auto_end_off"
        }
        
        command(cmd)
    }
    
    public func edit(name:String) {
        command("edit \(name)")
    }

    public func confirmDialogsAutomatically(confirm:Bool) {
        let name = confirm ? "YES" : "NO"
        command("set confirm \(name)")
    }

    public func layer(layer:Layer) {
        command("layer \(layer.rawValue)")
    }
    
    public func delete(point:Point) {
        command("delete \(point.formatted)")
    }
    
    public func wire(from from:Point, to:Point) {
        command("wire \(from.formatted) \(to.formatted)")
    }
    
    public func arc(p1:Point, p2:Point, p3:Point, clockwise:Bool = true) {
        var cmd = "arc"
        
        if !clockwise {
            cmd += " ccw"
        }
        cmd += " \(p1.formatted) \(p2.formatted) \(p3.formatted)"
        command(cmd)
    }
    
    public func polygon(name:String, points:[Point]) {
        var cmd = "polygon \(name)"
        
        for p in points {
            cmd += " \(p.formatted)"
        }
        command(cmd)
    }
    
    // Hacky; the origin in the component is in the schematic side, while this is mostly useful for the board side. We could return a new component for the board side, but that doesn't seem useful currently.
    public func move(component:Component, to:Point) {
        command("move \(component.name) \(to.formatted)")
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
