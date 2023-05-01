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
    @State private var selectedCategory: PartyCategory = .roommates
    
    @State private var selectedAction: PartyAction = .create
    
    @State private var invitationLink: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedAction) {
                    ForEach(PartyAction.allCases, id: \.self) { action in
                        Text(action.rawValue.capitalized).tag(action)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                
                
                dynamicForm
                
            }
            .navigationTitle("New Party")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    actionButton
                }
            }
        }
    }
    
    @ViewBuilder
    private var dynamicForm: some View {
        TabView(selection: $selectedAction) {
            ForEach(PartyAction.allCases, id: \.self) { action in
                Form {
                    LazyVStack {
                        switch selectedAction {
                        case .create:
                            TextField("Name", text: $name)
                                .accessibilityIdentifier("partyNameTextField")
                            
                            TextField("Description (Optional)", text: $description)
                                .accessibilityIdentifier("partyDescriptionTextField")
                            
                            TextField("Currency", text: $currency)
                                .accessibilityIdentifier("partyCurrencyTextField")
                            
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(PartyCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue.capitalized).tag(category)
                                }
                            }
                        case .join:
                            TextField("Party ID", text: $invitationLink)
                        }
                    }
                }
                .tag(action)
            }
        }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    
    private func createPartyAction() {
        if name.isEmpty || currency.isEmpty {
            showingAlert = true
        } else {
            let party = Party(name: name,
                              description: description,
                              currency: currency,
                              category: selectedCategory,
                              ownerUserID: UserRepository.shared.userId,
                              participants: [UserRepository.shared.userId: UserRepository.shared.userInfo?.displayName ?? "No name"])
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
    
    @State private var errorMessage = ""
    
    @ViewBuilder
    private var actionButton: some View {
        switch selectedAction {
        case .create:
            Button {
                createPartyAction()
            } label: {
                Text("Create")
            }
            .accessibilityIdentifier("createPartyButton")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"),
                      message: Text("Name and Currency fields are required."),
                      dismissButton: .default(Text("OK")))
            }
        case .join:
            Button {
                PartyRepository.shared.joinParty(with: invitationLink) { result in
                    switch result {
                    case .success:
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let failure):
                        errorMessage = failure.localizedDescription
                    }
                }
            } label: {
                Text("Join")
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"),
                      message: Text(errorMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private enum PartyAction: String, CaseIterable {
        case create, join
    }
}

struct CreatePartyView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePartyView()
    }
}

