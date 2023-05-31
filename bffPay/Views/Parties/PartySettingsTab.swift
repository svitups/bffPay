//
//  PartySettingsTab.swift
//  bffPay
//
//  Created by Eugene Ned on 30.05.2023.
//

import SwiftUI

struct PartySettingsTab: View {
    @ObservedObject var vm: PartyViewModel
    
    var body: some View {
            Form {
                HStack(spacing: 0) {
                    Text("Name")
                    Spacer()
                    TextField("Name", text: $vm.party.name)
                        .multilineTextAlignment(.trailing)
                }
//                    .frame(maxWidth: .infinity)
//                    .onSubmit {
//                        guard userInfoViewModel.userInfo.displayName.count >= 4 else {
//                            withAnimation {
//                                error = "display name is too short"
//                            }
//                            return
//                        }
//                        userInfoViewModel.update()
//                        editUserName.toggle()
//                    }
//                    .onChange(of: userInfoViewModel.userInfo.displayName) { newValue in
//                        if newValue.count > 50 {
//                            withAnimation {
//                                error = "display name is too long"
//                            }
//                        } else if newValue.count < 4 {
//                            withAnimation {
//                                error = "display name is too short"
//                            }
//                        } else {
//                            withAnimation {
//                                error = ""
//                            }
//                        }
//                    }
            }
        
    }
}
