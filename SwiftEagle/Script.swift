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
    
    // MARK:- Basic commands
    
    public func addLibrary(name:String) {
        command("use \(name)")
    }
    public func removeLibrary(name:String) {
        command("use -* \(name)")
    }
    
    public func addComponent(name:String, library:String?, origin:Point) {
        let fullName = library != nil ? "\(name)@\(library!)" : name
        command("add \(fullName) \(origin.formatted)")
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
