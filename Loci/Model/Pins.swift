//
//  Pins.swift
//  Loci
//
//  Created by Sam McGarry on 1/10/21.
//

import UIKit
import MapKit
import CoreData

public class Pins: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public var pins: [Pin] = []
    
    enum Keys: String {
        case pins = "pins"
    }
    
    init(pins: [Pin]) {
        self.pins = pins
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(pins, forKey: Keys.pins.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mPins = coder.decodeObject(of: [NSArray.self, Pin.self], forKey: Keys.pins.rawValue) as! [Pin]? ?? []
        self.init(pins: mPins)
    }
}
