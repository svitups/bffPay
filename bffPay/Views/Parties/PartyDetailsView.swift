//
//  PartyDetailsView.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct PartyDetailsView: View {
    @ObservedObject var vm: PartyViewModel
    
    @ObservedObject private var transactionsListVM: TransactionsListViewModel
    
    init(vm: PartyViewModel) {
        self.vm = vm
        self.transactionsListVM = TransactionsListViewModel(partyID: vm.party.id!)
    }
    
    var body: some View {
        VStack {
            Picker("", selection: $shownTab) {
                ForEach(PartyTabs.allCases, id: \.self) { tab in
                    Text(tab.rawValue.capitalized)
                }
            }.pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            
            TabView(selection: $shownTab) {
                transactionsTab
                    .tag(PartyTabs.transactions)
                
                debtsTab
                    .tag(PartyTabs.debts)
            }
        }
    }
    
    @State private var shownTab: PartyTabs = .transactions
    
    enum PartyTabs: String, CaseIterable {
        case transactions, debts
    }
    
    private var transactionsTab: some View {
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
        .onReceive(transactionsListVM.$transactions) { transactions in
            DispatchQueue.global(qos: .userInitiated).async {
                if !transactions.isEmpty {
                    vm.resolveDebts(transactions: transactions)
                }
            }
        }
    }
    
    private var debtsTab: some View {
        ScrollView {
            ForEach(vm.debts, id: \.id) { debt in
                HStack(spacing: 0) {
                    Text(PartyRepository.shared.getNameOfUser(withID: debt.fromID, in: vm.party.id!) ?? "Unknown user")
                    
                    Image(systemName: "arrow.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .padding(.horizontal, 4)
                    
                    Text(PartyRepository.shared.getNameOfUser(withID: debt.toID, in: vm.party.id!) ?? "Unknown user")
                    
                    Spacer()
                    
                    Text("\(debt.amount.stringWithoutZeroFraction) \(vm.party.currency)")
                        .bold()
                }
                .padding()
            }
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
