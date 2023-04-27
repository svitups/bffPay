//
//  Double+Ext.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import Foundation

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
