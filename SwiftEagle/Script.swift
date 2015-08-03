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
    
    public func addLibrary(name:String) {
        command("use \(name)")
    }
    public func removeLibrary(name:String) {
        command("use -* \(name)")
    }
    
    public func addComponent(component:String, library:String?, name:String?, origin:Point) {
        let fullName = library != nil ? "\(component)@\(library!)" : component
        
        var cmd = "add \(fullName)"
        if let name = name {
            cmd = cmd + " \(name)"
        }
        cmd = cmd + " \(origin.formatted)"
        command(cmd)
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
