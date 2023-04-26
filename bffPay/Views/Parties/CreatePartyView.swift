//
//  CreatePartyView.swift
//  bffPay
//
//  Created by Eugene Ned on 23.04.2023.
//

import SwiftUI

struct CreatePartyView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var partyListVM: PartyListViewModel
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var currency: String = ""
    @State private var selectedCategory: PartyCategory = .couple
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    TextField("Name", text: $name)
                    
                    TextField("Description (Optional)", text: $description)
                    
                    TextField("Currency", text: $currency)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(PartyCategory.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                }
                .navigationTitle("New Party")
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
    }
    
    
    private func createPartyAction() {
        if name.isEmpty || currency.isEmpty {
            showingAlert = true
        } else {
            let party = Party(name: name,
                              description: description,
                              currency: currency,
                              category: selectedCategory,
                              ownerUserID: "V5zmJHC038Ri1jt8UwLpG51uXYD2",
                              participantIDs: ["V5zmJHC038Ri1jt8UwLpG51uXYD2"])
            partyListVM.add(party) {
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
        Button(action: createPartyAction) {
            Text("Create")
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text("Name and Currency fields are required."), dismissButton: .default(Text("OK")))
        }
    }
}

struct CreatePartyView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePartyView()
    }
}

