//
//  DeleteAccountView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI

struct DeleteAccountView: View {
    
    @StateObject private var viewModel = DeleteAccountViewModel(dependency: DeleteAccountService())
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 16) {
                
                Text("Delete Account")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 50, leading: 20, bottom: 0, trailing: 20))
                
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
                
                if let errorMessage = viewModel.errorMessage {
                    
                    Text(errorMessage)
                        .onAppear(perform: {
                            print("Login failed : \(errorMessage)")
                        })
                        .foregroundStyle(.red)
                        .font(.caption)
                }

                Button {
                    
                    Task {
                        await viewModel.deleteAccount()
                    }
                    
                } label: {
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    else {
                        Text("Delete")
                            .bold()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled((viewModel.isLoading || !viewModel.isValid))
                
                .onChange(of: viewModel.username) { oldValue, newValue in
                    viewModel.errorMessage = nil
                }
                
                .onChange(of: viewModel.password) { oldValue, newValue in
                    viewModel.errorMessage = nil
                }
                .padding(EdgeInsets(top: 100, leading: 10, bottom: 10, trailing: 10))
            }
            
            .navigationDestination(isPresented: $viewModel.isDeleted) {
                HomeView()
            }
        }
        
    }
}

#Preview {
    DeleteAccountView()
}
