//
//  CreatePetCollectionViewCell.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/19.
//

import UIKit

protocol CreateCollectionViewCellDelegate: class {
    func cratePet(_ sender: UIButton)
}

class CreatePetCollectionViewCell: UICollectionViewCell {
    weak var delegate: CreateCollectionViewCellDelegate?
    
    @IBAction func cratePet(_ sender: UIButton) {
        delegate?.cratePet(sender)
    }
}
