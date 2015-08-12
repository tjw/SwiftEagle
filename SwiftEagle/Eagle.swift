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
    
    public func grid(measurement:Measurement, alternate:Bool = false, type:GridType = .Dots, factor:UInt? = nil) {
        var cmd = "grid"
        
        if alternate {
            cmd += " alt"
        }
        
        cmd += " \(measurement.unit.abbreviation) \(measurement.value)"
        
        if let factor = factor {
            cmd += " \(factor)"
        }
        
        command(cmd)
    }
    
    public var gridVisible:Bool = true {
        didSet {
            let name = gridVisible ? "on" : "off"
            command("grid \(name)")
        }
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
    
    public func route(points:[Point], width:Double? = nil) {
        var cmd = "route "
        
        for p in points {
            cmd += " \(p.formatted)"
        }

        if let width = width {
            cmd += " \(width)"
        }
        
        command(cmd)
    }
    
    public enum Shape:String {
        case Square = "square"
        case Circle = "round"
        case Octagon = "octagonal"
    }
    
    public struct Via {
        public let location:Point
        public let signal:String?
        public let diameter:Measurement?
        public let shape:Shape?
        public let layer1:Layer
        public let layer2:Layer
        
        public init(location:Point, signal:String? = nil, diameter:Measurement? = nil, shape:Shape? = nil, layer1:Layer, layer2:Layer) {
            self.location = location
            self.signal = signal
            self.diameter = diameter
            self.shape = shape
            self.layer1 = layer1
            self.layer2 = layer2
        }
    }
    
    public func via(location:Point, signal:String? = nil, diameter:Measurement? = nil, shape:Shape? = nil, layer1:Layer, layer2:Layer) -> Via {
        var cmd = "via"
        
        if let signal = signal {
            cmd += " '\(signal)'"
        }
        
        if let diameter = diameter {
            cmd += " \(diameter.value)\(diameter.unit.abbreviation)"
        }
        
        if let shape = shape {
            cmd += " \(shape.rawValue)"
        }
        
        cmd += " \(layer1.rawValue)-\(layer2.rawValue)"
        cmd += " \(location.formatted)"
        
        command(cmd)
        
        return Via(location:location, signal:signal, diameter:diameter, shape:shape, layer1:layer1, layer2:layer2)
    }
    
    public func edit(name:String) {
        command("edit \(name)")
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
    
    public enum WireBend:Int {
        case StraightThenBend90 = 0
        case StraightThenBend45 = 1
        case StraightNoBend = 2
        case Bend45ThenStraight = 3
        case Bend90ThenStraight = 4
        case ArcThenStraight = 5
        case StraightThenArc = 6
        case ArcThenStraightThenArc = 7
        case FollowMeRouterFromInitialPad = 8
        case FollowMeRouterBetweenPads = 9
    }
    
    public var confirmDialogsAutomatically:Bool = false {
        didSet {
            let name = confirmDialogsAutomatically ? "YES" : "NO"
            command("set confirm \(name)")
        }
    }
    
    public var wireBend:WireBend = .StraightThenBend90 {
        didSet {
            command("set wire_bend \(wireBend.rawValue)")
        }
    }
    
    public var snapLength:Measurement = Inch(20/1000.0) {
        didSet {
            command("set snap_length \(snapLength.value)\(snapLength.unit.abbreviation)")
        }
    }
    
    public var confirmationBeep:Bool = true {
        didSet {
            let name = confirmationBeep ? "on" : "off"
            command("set beep \(name)")
        }
    }
    
    // MARK:- Private

    var buffer = ""
    
    func command(cmd:String) {
        buffer += cmd + ";\n"
    }
}
