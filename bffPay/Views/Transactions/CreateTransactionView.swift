//
//  CreateTransactionView.swift
//  bffPay
//
//  Created by Eugene Ned on 26.04.2023.
//

import SwiftUI

struct CreateTransactionView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                VStack {
                    
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
    }
    
    private func createPartyAction() {
//        if name.isEmpty || currency.isEmpty {
//            showingAlert = true
//        } else {
            // create transaciton
//        }
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

struct CreateTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTransactionView()
    }
}
