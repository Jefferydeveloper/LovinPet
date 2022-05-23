//
//  ChangeCollectionViewCell.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/20.
//

import UIKit

class ChangeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var changeCellImageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.cornerRadius = self.frame.width / 2
                self.clipsToBounds = true
                self.layer.borderWidth = 3
                self.layer.borderColor = UIColor.link.cgColor
            } else {
                self.clipsToBounds = true
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
