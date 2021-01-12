//
//  PinTypes.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit
import MapKit
import CoreData

public class PinTypes: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public var pintypes: [PinType] = []
    
    enum Keys: String {
        case pintypes = "pintypes"
    }
    
    init(pintypes: [PinType]){
        self.pintypes =  pintypes
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(pintypes, forKey: Keys.pintypes.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let mPintypes = coder.decodeObject(of: [NSArray.self, PinType.self], forKey: Keys.pintypes.rawValue) as! [PinType]? ?? []
        self.init(pintypes: mPintypes)
    }
}
