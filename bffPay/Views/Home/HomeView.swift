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
                    if partyListVM.partyViewModels.isEmpty {
                        Text("No parties found, tap on plus button to add a party!")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()                    } else {
                        ForEach(partyListVM.partyViewModels) { partyVM in
                            NavigationLink {
                                PartyDetailsView(vm: partyVM)
                            } label: {
                                PartyRowView(vm: partyVM)
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(CustomPlusButton {
                showCreatePartyView = true
            }, alignment: .bottomTrailing)
            .navigationTitle("bffPay")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    settingsNavigationButton
                }
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
    
    private var settingsNavigationButton: some View {
        Button {
            showSettings = true
        } label: {
            Image(systemName: "gear")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
