//
//  PartyDetailsView.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct PartyDetailsView: View {
    var vm: PartyViewModel
    
    var body: some View {
        ScrollView {
            Text("Details!")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .overlay(CustomPlusButton {
            showCreateTransactionView = true
        }, alignment: .bottomTrailing)
        .navigationTitle(vm.party.name)
        .sheet(isPresented: $showCreateTransactionView) {
            CreateTransactionView()
//                .environmentObject(partyListVM)
        }
    }
    
    // MARK: Create transaction
    @State private var showCreateTransactionView = false
}

//struct PartyDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PartyDetailsView()
//    }
//}
