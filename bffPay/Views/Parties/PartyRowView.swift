//
//  PartyRowView.swift
//  bffPay
//
//  Created by Eugene Ned on 22.04.2023.
//

import SwiftUI

struct PartyRowView: View {
    
    var vm: PartyViewModel
    
//    var color: Color?
//    var name: String
//    var description: String
    var notificationsCount: Int = 0
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                HStack {
//                    if let color = color {
//                        Circle()
//                            .foregroundColor(color)
//                            .frame(width: 4, height: 4)
//                    }
                    Text(vm.party.name)
                        .font(.callout)
//                        .bold()
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
    //                            .foregroundColor(.gray)
                        }
                }
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
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
