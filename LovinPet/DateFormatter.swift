//
//  DateFormatter.swift
//  LovinPet
//
//  Created by 吳孟儒 on 2021/1/11.
//

import Foundation
import Charts

class IAxisDateFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: value)
        return formatter.string(from: date)
    }

}
