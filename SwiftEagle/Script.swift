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
    
    public func addLibrary(library:Library) {
        if let path = library.path {
            command("use \(path)")
        } else {
            command("use \(library.name)")
        }
    }
    public func removeLibrary(library:Library) {
        command("use -* \(library.name)")
    }
    
    // In the schematic editor, the angle must be 0, 90, 180, or 270.
    public func addComponent(component:Component, name:String?, origin:Point, angle:Double?) {
        let fullName = component.library != nil ? "\(component.name)@\(component.library!.name)" : component.name
        
        var cmd = "add \(fullName)"
        if let name = name {
            cmd = cmd + " \(name)"
        }
        cmd = cmd + " \(origin.formatted)"
        
        if let angle = angle {
            cmd = " R\(angle)"
        }
        
        command(cmd)
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
