//
//  HospitalTableViewCell.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/31.
//

import UIKit

class HospitalTableViewCell: UITableViewCell {

    @IBOutlet weak var hospitalImageView: UIImageView!
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var hospitalAddress: UILabel!
    @IBOutlet weak var hospitalPhoneNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
