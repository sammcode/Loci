//
//  PinsDataValueTransformer.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit

final class PinsDataValueTransformer: NSSecureUnarchiveFromDataTransformer {
    // The name of the transformer. This is what we will use to register the transformer `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: Pins.self))

    // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
    override static var allowedTopLevelClasses: [AnyClass] {
        return [Pins.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = PinsDataValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
