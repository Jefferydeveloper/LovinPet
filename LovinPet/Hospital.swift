//
//  Hospital.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2021/1/1.
//

import Foundation

class Hospital {
    var address: String
    var image: String
    
    init(address: String, image: String) {
        self.address = address
        self.image = image
    }
    
    convenience init() {
        self.init(address: "", image: "")
    }
}
