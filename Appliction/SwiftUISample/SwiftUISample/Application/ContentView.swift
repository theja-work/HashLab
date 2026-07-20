//
//  ContentView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 29/03/26.
//

import SwiftUI

struct ContentView : View {
    
    @FocusState var focusedField: Field?
    
    @StateObject private var viewModel = LoginViewModel(dependency: AuthService())
    
    var body : some View {
        
        NavigationStack {
            
            VStack(spacing: 16) {
                
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .focused($focusedField, equals: .username)
                
                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .focused($focusedField, equals: .password)
                
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
                        await viewModel.login()
                    }
                    
                } label: {
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    else {
                        Text("Login")
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
                
                Text("Or")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemBlue))
                    .bold()
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.title3)
                        .underline(true)
                        .foregroundStyle(Color(.systemBlue))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeView()
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
