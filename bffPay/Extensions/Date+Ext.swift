//
//  Date+Ext.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import Foundation

extension Date {
    func compactDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm"
        return formatter.string(from: self)
    }
}
