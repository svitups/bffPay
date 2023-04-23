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
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    //                    Section("Party") {
                    //                        TextField("Name", text: $userInfoViewModel.userInfo.displayName)
                    //                            .multilineTextAlignment(.trailing)
                    //                    }
                    //                    Section("Participants (0/30)") {
                    //                        <#code#>
                    //                    }
                }
            }
            .navigationTitle("New party")
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
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    @State private var isCreatingParty = false
    
    private var createButton: some View {
        Button {
            isCreatingParty = true
            
            partyListVM.add(Party(name: "Test",
                                  description: "test descp",
                                  currency: "USD",
                                  category: .couple,
                                  ownerUserID: "V5zmJHC038Ri1jt8UwLpG51uXYD2",
                                  participantIDs: ["V5zmJHC038Ri1jt8UwLpG51uXYD2"])) {
                isCreatingParty = false
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            if isCreatingParty {
                ProgressView()
            } else {
                Text("Create")
            }
        }
    }
}

struct CreatePartyView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePartyView()
    }
}
