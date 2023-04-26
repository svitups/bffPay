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
                .frame(width: 46, height: 46)
                .foregroundColor(Color(.systemPurple))
                .overlay {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
        }
        .padding()
        
    }
}

struct CustomPlusButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomPlusButton {
            print("Test")
        }
    }
}
