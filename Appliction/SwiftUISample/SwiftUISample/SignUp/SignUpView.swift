//
//  SignUpView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 29/06/26.
//

import SwiftUI

public struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel(dependency: SignUpService())
    
    public var body: some View {
        
        NavigationStack {
            
            TextField("Email", text: $viewModel.username)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))
            
            if let errorMessage = viewModel.errorMessage {
                
                Text(errorMessage)
                    .onAppear(perform: {
                        print("Signup failed : \(errorMessage)")
                    })
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            
            Button {
                
                Task {
                    await viewModel.signUp()
                }
                
            } label: {
                
                if viewModel.isLoading {
                    ProgressView()
                }
                else {
                    Text("Sign Up")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            
        }
        .navigationTitle("Sign Up")
        .navigationDestination(isPresented: $viewModel.isSignedUp) {
            HomeView()
        }
        
    }
}

#Preview {
    SignUpView()
}
