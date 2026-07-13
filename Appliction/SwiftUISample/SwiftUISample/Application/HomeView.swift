//
//  HomeView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI

struct HomeView : View {
    
    @State private var navigateToDeleteAccount = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Text("Welcome Home 🚀")
                    .font(.largeTitle)
                    .bold()
                    .padding(EdgeInsets(top: 50, leading: 10, bottom: 10, trailing: 10))

                Spacer()

                Button {
                    Logger.log("execute delete account")
                    navigateToDeleteAccount = true
                } label: {
                    Text("Delete Account")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationDestination(isPresented: $navigateToDeleteAccount) {
                DeleteAccountView()
            }
        }
    }
}

#Preview {
    HomeView()
}
