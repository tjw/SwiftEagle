//
//  Script.swift
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

public class Script {
    
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
 
        let result = Component(componentName)
        
        if degrees != 0 {
            rotate(result, degrees:degrees)
        }
        
        return result
    }
    
    // In the schematic editor, the angle must be 0, 90, 180, or 270.
    // The angle is added to the current angle of the component ('=' can be prepended to the 'R' if we need to have a 'set angle').
    public func rotate(component:Component, degrees:Double) {
        command("rotate R\(degrees) \(component.name)")
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
