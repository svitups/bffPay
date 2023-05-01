//
//  CustomPlusButton.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct CustomPlusButton: View {
    
    var action: () -> Void
    
    var body: some View {
        
        Button {
            action()
        } label: {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemPurple))
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
        }
        .padding()
        .accessibilityIdentifier("plusButton")
    }
}

struct CustomPlusButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomPlusButton {
            print("Test")
        }
    }
}
