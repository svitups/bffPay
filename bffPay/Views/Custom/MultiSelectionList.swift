//
//  MultiSelectionList.swift
//  bffPay
//
//  Created by Eugene Ned on 27.04.2023.
//

import SwiftUI

struct MultipleSelectionRow: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
