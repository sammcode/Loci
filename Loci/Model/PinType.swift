//
//  PinType.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit

public class PinType: NSObject {
    public var name: String!
    public var image: UIImage!
    
    init(name: String, image: UIImage){
        self.name = name
        self.image = image
    }
}
