//
//  CreateNewPinPopUp.swift
//  Loci
//
//  Created by Sam McGarry on 1/11/21.
//

import UIKit

protocol CreateNewPinPopUpDelegate {
    func buttonTapped()
}

class CreateNewPinPopUp: UIView {

    var createNewPopUpDelegate: CreateNewPinPopUpDelegate?
    public var title: String?
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.text = "New Ingredient"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let addName: NameTextField = {
        let textfield = NameTextField(insets: UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "Ingredient Name"
        //textfield.height(40)
        return textfield
    }()

}
