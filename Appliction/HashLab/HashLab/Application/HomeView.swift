//
//  HomeView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject private var session : SessionManager

    var body: some View {

        VStack {

            Text("Welcome Home 🚀")
                .font(.largeTitle)
                .bold()
                .padding(.top, 50)

            Spacer()
            
            Button("Logout") {
                
                session.logout()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            .buttonStyle(.borderless)
            
            NavigationLink("Delete Account") {
                DeleteAccountView()
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
            NavigationLink("Delete Users") {
                DeleteUsers()
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
            
        }
    }
}

#Preview {
    HomeView()
}
