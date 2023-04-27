//
//  PartyRowView.swift
//  bffPay
//
//  Created by Eugene Ned on 22.04.2023.
//

import SwiftUI

struct PartyRowView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    
    var vm: PartyViewModel
    
    var notificationsCount: Int = 0
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                HStack {
                    
                    Text(vm.party.name)
                        .font(.callout)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                if let description = vm.party.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("No description")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            
            HStack(alignment: .center) {
                if notificationsCount > 0 {
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color(.systemPurple).opacity(0.8))
                        .overlay {
                            Text(String(Int.random(in: -10...10)))
                                .font(.caption2)
                        }
                }
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .padding()
    }
}

//struct PartyRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PartyRowView(name: "Part", description: "Description", notificationsCount: 0)
//    }
//}
