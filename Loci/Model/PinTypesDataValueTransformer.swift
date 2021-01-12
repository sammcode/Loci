//
//  PinTypesDataValueTransformer.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit

class PinTypesDataValueTransformer: NSSecureUnarchiveFromDataTransformer {
    // The name of the transformer. This is what we will use to register the transformer `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: PinTypes.self))

    // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
    override static var allowedTopLevelClasses: [AnyClass] {
        return [PinTypes.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = PinTypesDataValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
