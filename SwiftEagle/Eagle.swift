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

public extension Point {
    // Format a point as in a EAGLE command (no comma, units specified). The abbreviation names happen to match here.
    var formatted: String {
        return "(\(x.value)\(x.unit.abbreviation) \(y.value)\(y.unit.abbreviation))"
    }
}

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
        
        cmd += " \(measurement.unit.abbreviation) \(measurement.value)"
        
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
        let fullName = "\(element.name)@\(element.library.name)"
        
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
 
        let result = Component(componentName, element:element, transform:Transform(degrees:degrees, translate:origin))
        
        if degrees != 0 {
            rotate(result, degrees:degrees)
        }
        
        return result
    }
    
    // In the schematic editor, the angle must be 0, 90, 180, or 270.
    // The angle is added to the current angle of the component unless 'absolute' is specified
    public func rotate(component:Component, degrees:Double, mirror:Bool = false, absolute:Bool = false) -> Component {
        var cmd = "rotate "
        
        if absolute {
            cmd += "="
        }
        
        if mirror {
            cmd += "M"
        }
        
        cmd += "R\(degrees) \(component.name)"
        command(cmd)
        
        let transform = Transform(degrees: degrees, mirror: mirror, translate: component.transform.translate)
        return Component(component.name, element:component.element, transform:transform)
    }
    
    // Sadly, the net command doesn't take pin names, only locations and the scripting language doesn't have any way to get this.
    // Using pin definitions in Library.Element along with Component transforms and turtles makes this a little less bad.
    // Adding support for parsing EAGLE libraries could automate this...
    public func net(points:[Point], name:String? = nil, auto_end:Bool = true) {
        var cmd = "net "
        
        if let name = name {
            cmd += " \(name)"
        }
        for p in points {
            cmd += " \(p.formatted)"
        }
        
        command(cmd)
    }

    public func net(turtles:[Turtle], name:String? = nil, auto_end:Bool = true) {
        net(turtles.map { $0.location }, name:name, auto_end:auto_end)
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
        var cmd = "polygon '\(name)'"
        
        for p in points {
            cmd += " \(p.formatted)"
        }
        command(cmd)
    }
    
    public func move(component:Component, to:Point) -> Component {
        command("move \(component.name) \(to.formatted)")
        
        let transform = Transform(degrees: component.transform.degrees, mirror: component.transform.mirror, translate: to)
        return Component(component.name, element:component.element, transform:transform)
    }
    
    public func ratsnest() {
        command("ratsnest")
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
