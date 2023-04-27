//
//  PartyDetailsView.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct PartyDetailsView: View {
    var vm: PartyViewModel
    
    @StateObject private var transactionsListVM: TransactionsListViewModel
    
    init(vm: PartyViewModel) {
        self.vm = vm
        self._transactionsListVM = StateObject(wrappedValue: TransactionsListViewModel(partyID: vm.party.id!))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if transactionsListVM.transactions.isEmpty {
                    Text("No transaciton found, tap on plus button to add the first one!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                } else {
                    ForEach(transactionsListVM.transactions) { transaciton in
                        NavigationLink {
                            TransactionDetailsView(transaciton)
                                .environmentObject(transactionsListVM)
                        } label: {
                            TransactionRowView(transaciton)
                        }
                    }
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .overlay(CustomPlusButton {
            showCreateTransactionView = true
        }, alignment: .bottomTrailing)
        .navigationTitle(vm.party.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
        .sheet(isPresented: $showCreateTransactionView) {
            CreateTransactionView(party: vm.party)
                .environmentObject(transactionsListVM)
        }
    }
    
    // MARK: Share button
    
    private var shareButton: some View{
        Button {
            if let partyID = vm.party.id {
                let invitationText = "The party \"\(vm.party.name)\" is accessible using this invitation code: \(partyID)"

                let av = UIActivityViewController(activityItems: [invitationText], applicationActivities: nil)

                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene

                windowScene?.keyWindow?.rootViewController?.present(av, animated: true, completion: nil)
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    // MARK: Create transaction
    @State private var showCreateTransactionView = false
}
