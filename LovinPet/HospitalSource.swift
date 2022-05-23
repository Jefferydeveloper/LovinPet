//
//  HospitalSource.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2020/12/9.
//

import Foundation

struct FinalResult: Codable {
    let result: Result
}

struct Result: Codable {
    let limit: Int
    let offset: Int
    let count: Int
    let sort: String
    let results: [hospital]
}

struct hospital: Codable {
    let addr: String
    let _id: Int
    let phone: String
    let Hname: String
    let owner: String
    enum CodingKeys: String, CodingKey {
        case addr = "地址"
        case _id
        case phone = "電話"
        case Hname = "動物醫院名稱"
        case owner = "負責人"
    }
}
