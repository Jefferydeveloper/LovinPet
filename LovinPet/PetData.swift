//
//  PetData.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/18.
//

import Foundation
import UIKit
import CoreData

class PetData: NSManagedObject {
    @NSManaged var petName : String?
    @NSManaged var imageName : String?
    @NSManaged var birth : String?
    @NSManaged var beginDay : String?
    @NSManaged var sex : String?
    @NSManaged var petID : String
    
    override func awakeFromInsert() {
        self.petID = UUID().uuidString
    }
    
    func image() -> UIImage? {
        if let name = self.imageName {
            let homeUrl = URL(fileURLWithPath: NSHomeDirectory())
            let docUrl = homeUrl.appendingPathComponent("Documents")
            let fileUrl = docUrl.appendingPathComponent(name)
            return UIImage(contentsOfFile: fileUrl.path)
        }
        return nil
    }
}

class WeightData: NSManagedObject {
    @NSManaged var weightDate : Date?
    @NSManaged var weight : Double
    @NSManaged var weightID : String
    override func awakeFromInsert() {
        self.weightID = UUID().uuidString
    }
}

class TableData: NSManagedObject {
    @NSManaged var reminderTitle: String?
    @NSManaged var reminderContent: String?
    @NSManaged var reminderDate: Date
    @NSManaged var reminderID: String
    
    override func awakeFromInsert() {
        self.reminderID = UUID().uuidString
    }
}
