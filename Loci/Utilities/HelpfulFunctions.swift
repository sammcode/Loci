//
//  HelpfulFunctions.swift
//  Loci
//
//  Created by Sam McGarry on 1/10/21.
//

import Foundation
import UIKit

public class HelpfulFunctions {
    public static func resizeImage(size: CGFloat, image: UIImage) -> UIImage {
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else { return Images.filledpin! }
        return resizedImage
    }
}
