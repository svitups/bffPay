//
//  CreateTransactionView.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct CreateTransactionView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var transactionsListVM: TransactionsListViewModel
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var currency: String = ""
    @State private var date = Date()
    @State private var paidByID: String = ""
    @State private var paidForIDs: [String] = []
    
    let party: Party
    
    init(party: Party) {
           self.party = party
           _paidByID = State(initialValue: party.participants.keys.sorted().first ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Transaction details") {
                    TextField("Title", text: $title)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
//                    TextField("Currency", text: $currency)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    Picker("Paid By", selection: $paidByID) {
                        ForEach(party.participants.keys.sorted(), id: \.self) { userId in
                            Text(party.participants[userId]!)
                        }
                    }
                }
                Section("Paid for") {
                    List {
                        ForEach(party.participants.keys.sorted(), id: \.self) { userId in
                            MultipleSelectionRow(title: party.participants[userId]!, isSelected: self.paidForIDs.contains(userId)) {
                                if self.paidForIDs.contains(userId) {
                                    self.paidForIDs.removeAll(where: { $0 == userId })
                                }
                                else {
                                    self.paidForIDs.append(userId)
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    createButton
                }
            }
        }
    }
    
    private func createTransactionAction() {
        if title.isEmpty || amount.isEmpty || paidForIDs.isEmpty {
            showingAlert = true
        } else {
            let transaction = Transaction(title: title,
                                          amount: Double(amount) ?? 0,
                                          currency: party.currency,
                                          date: date,
                                          paidByID: paidByID,
                                          paidForIDs: paidForIDs,
                                          partyID: party.id!)
            transactionsListVM.create(transaction) {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    @State private var showingAlert = false
    
    private var createButton: some View {
        Button(action: createTransactionAction) {
            Text("Create")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Title, amount, paid for fields are required."), dismissButton: .default(Text("OK")))
        }
    }
}
