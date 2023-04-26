//
//  HomeView.swift
//  bffPay
//
//  Created by Eugene Ned on 21.04.2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authService: AuthService
    
    @StateObject private var partyListVM = PartyListViewModel()
    
    @State private var showCreatePartyView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(partyListVM.partyViewModels) { partyVM in
                        NavigationLink {
                            
                                PartyDetailsView(vm: partyVM)
                            
                        } label: {
                            PartyRowView(vm: partyVM)
                        }
                        
                        
//                        if partyVM == partyListVM.partyViewModels.last {
//                            Divider()
//                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(CustomPlusButton {
                showCreatePartyView = true
            }, alignment: .bottomTrailing)
            .navigationTitle("bffPay")
            .toolbar {
                settingsNavigationButton
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(authService)
            }
            .fullScreenCover(isPresented: $showCreatePartyView) {
                CreatePartyView()
                    .environmentObject(partyListVM)
            }
        }
    }
    
    // MARK: Settings
    
    @State private var showSettings = false
    
    private var settingsNavigationButton: ToolbarItem<(), Button<Image>> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gear")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
