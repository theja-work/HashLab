//
//  HomeView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI

struct HomeView: View {

    @State private var navigateToDeleteAccount = false
    @State private var navigateToDeleteUsers = false

    var body: some View {

        VStack {

            Text("Welcome Home 🚀")
                .font(.largeTitle)
                .bold()
                .padding(.top, 50)

            Spacer()
            
            Button("Sample button") {
                print("Sample button functionality")
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .buttonStyle(.borderless)

            Button("Delete Account") {
                navigateToDeleteAccount = true
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
            Button("Delete Users") {
                navigateToDeleteUsers = true
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))

        }
        .navigationDestination(isPresented: $navigateToDeleteAccount) {
            DeleteAccountView()
        }
        
        .navigationDestination(isPresented: $navigateToDeleteUsers) {
            DeleteUsers()
        }
    }
}

#Preview {
    HomeView()
}
