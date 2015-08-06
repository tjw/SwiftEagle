//
//  Measurement.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 10/21/14.
//  Copyright © 2014 Cocoatoa. All rights reserved.
//

import Foundation

/*

Goals:

- Type-safe support for units of the same kind (length to start with, but could also do mass, temperature, angles, etc).
- Concise syntax for declaring constants ("Inch(1)" is better than "Measurment<Inch>(1)", for example).
- Support for heterogenous collections of measurements. Should be able to make a rect where the center or origin is in millimeters, while the size is in inches.
- Easy conversion between units, especially converting to/from "user space" for rendering and hit testing
- Comparision, equating, mathematical operations on measurements.
- Don't have to redefine a bunch of boilerplate BS on each concrete measurement unit struct/class
- Nice debug/printing including units.

Non-goals:
- Can hardcode the list of units; don't need to allow third parties to add Ängstroms and AU…
- Don't necessarily need to avoid repeated rounding error if you convert repeatedly between units. The caller could be in charge of not doing that.
- Don't need to be super efficient in terms of space (OK, to have a dynamic `isa` pointer in each measurement). Not going to use this for 3D model data.

*/


/*

Goals:

- Type-safe support for units of the same kind (length to start with, but could also do mass, temperature, angles, etc).
- Concise syntax for declaring constants ("Inch(1)" is better than "Measurment<Inch>(1)", for example).
- Support for heterogenous collections of measurements. Should be able to make a rect where the center or origin is in millimeters, while the size is in inches.
- Easy conversion between units, especially converting to/from "user space" for rendering and hit testing
- Comparision, equating, mathematical operations on measurements.
- Don't have to redefine a bunch of boilerplate BS on each concrete measurement unit struct/class
- Nice debug/printing including units.

Non-goals:
- Can hardcode the list of units; don't need to allow third parties to add Ängstroms and AU…
- Don't necessarily need to avoid repeated rounding error if you convert repeatedly between units. The caller could be in charge of not doing that.
- Don't need to be super efficient in terms of space (OK, to have a dynamic `isa` pointer in each measurement). Not going to use this for 3D model data.

Note:
- If we have 'Measurement' only record one coordinate, then we can't really use it as a full transform where we use a NSView/UIView as a coordinate system...
*/

// Require 'class' so that we get dynamic dispatch to the right unit
public protocol MeasurementUnit: class {
    // The unit name "mm" or the like.
    var abbreviation: String { get }
    
    // The conversion factor between this unit and millimeters
    var oneUnitInMillimeters: Double { get }
}

public struct Measurement {
    let unit: MeasurementUnit
    
    // The numeric part of the measurement
    let value: Double
    
    init(_ value:Double, _ unit:MeasurementUnit) {
        self.value = value
        self.unit =  unit
    }
}

public extension Measurement {
    public var positive: Bool {
        return value > 0.0
    }
    public var nonNegative: Bool {
        return value >= 0.0
    }
}

extension Measurement : CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "\(value) \(unit.abbreviation)"
    }
    
    public var debugDescription: String {
        return "\(value) \(unit.abbreviation)"
    }
}

// Something that can be converted to a measurement system and an implementation for a base measurement
public protocol MeasurementConvertible {
    func to(toUnit: MeasurementUnit) -> Self
}
public extension Measurement {
    public func to(toUnit: MeasurementUnit) -> Measurement {
        let mm = value * unit.oneUnitInMillimeters
        let v = mm / toUnit.oneUnitInMillimeters
        return Measurement(v, toUnit)
    }
}

// Support for Comparable
extension Measurement : Comparable {}
public func <=(lhs: Measurement, rhs: Measurement) -> Bool {
    let lmm = lhs.value * lhs.unit.oneUnitInMillimeters
    let rmm = rhs.value * rhs.unit.oneUnitInMillimeters
    return lmm <= rmm
}
public func >=(lhs: Measurement, rhs: Measurement) -> Bool {
    let lmm = lhs.value * lhs.unit.oneUnitInMillimeters
    let rmm = rhs.value * rhs.unit.oneUnitInMillimeters
    return lmm >= rmm
}
public func >(lhs: Measurement, rhs: Measurement) -> Bool {
    let lmm = lhs.value * lhs.unit.oneUnitInMillimeters
    let rmm = rhs.value * rhs.unit.oneUnitInMillimeters
    return lmm > rmm
}
public func <(lhs: Measurement, rhs: Measurement) -> Bool {
    let lmm = lhs.value * lhs.unit.oneUnitInMillimeters
    let rmm = rhs.value * rhs.unit.oneUnitInMillimeters
    return lmm < rmm
}
public func ==(lhs: Measurement, rhs: Measurement) -> Bool {
    let lmm = lhs.value * lhs.unit.oneUnitInMillimeters
    let rmm = rhs.value * rhs.unit.oneUnitInMillimeters
    return lmm == rmm
}

// Convert the receiver's value to a raw value in our units
extension Measurement {
    func valueInUnit(toUnit:MeasurementUnit) -> Double {
        let scale = unit.oneUnitInMillimeters / toUnit.oneUnitInMillimeters
        return value * scale
    }
}

// Stepping measurements to snap points
public extension Measurement {
    // Returns a new measurement that is in the units of the receiver with value that is an even multiple of the receiver that is equal to or greater than the input measure.
    public func snapUp(m:Measurement) -> Measurement {
        let v = m.valueInUnit(unit)
        return Measurement(v.snapUp(by:value), m.unit)
    }
    
    // Returns a new measurement that is in the units of the receiver with value that is an even multiple of the receiver that is equal to or less than the input measure.
    public func snapDown(m:Measurement) -> Measurement {
        let v = m.valueInUnit(unit)
        return Measurement(v.snapDown(by:value), m.unit)
    }
    
    public func stepTo(end:Measurement, by:Measurement, perform:(Measurement)->()) {
        var step = 0.0
        while (true) {
            let v = self + step*by
            if v > end {
                break
            }
            perform(v)
            step += 1.0
        }
    }
}

// Mathematical operations on units. Results are in the unit type of the first argument

public func +(a:Measurement, b:Measurement) -> Measurement {
    let convertedB = b.to(a.unit)
    return Measurement(a.value + convertedB.value, a.unit)
}
public func -(a:Measurement, b:Measurement) -> Measurement {
    let convertedB = b.to(a.unit)
    return Measurement(a.value - convertedB.value, a.unit)
}

public prefix func -(a:Measurement) -> Measurement {
    return Measurement(-a.value, a.unit)
}

public func *(m:Measurement, scale:Double) -> Measurement {
    return Measurement(m.value * scale, m.unit)
}
public func *(scale:Double, m:Measurement) -> Measurement {
    return Measurement(m.value * scale, m.unit)
}

//
// MARK:- Measurement units
//
class StaticMeasurementUnit: MeasurementUnit {
    let abbreviation: String
    let oneUnitInMillimeters: Double
    
    init(abbreviation:String, oneUnitInMillimeters:Double) {
        self.abbreviation = abbreviation
        self.oneUnitInMillimeters = oneUnitInMillimeters
    }
    
    var zero: Measurement {
        return Measurement(0, self)
    }
}

let MillimeterUnit = StaticMeasurementUnit(abbreviation: "mm", oneUnitInMillimeters: 1.0)
let InchUnit = StaticMeasurementUnit(abbreviation: "in", oneUnitInMillimeters: 25.4)

public func Millimeter(v:Double) -> Measurement {
    return Measurement(v, MillimeterUnit)
}
public func Inch(v:Double) -> Measurement {
    return Measurement(v, InchUnit)
}
