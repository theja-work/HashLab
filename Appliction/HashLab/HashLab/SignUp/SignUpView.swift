//
//  SignUpView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 29/06/26.
//

import SwiftUI

public struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel(dependency: SignUpService())
    
    @State var isAdmin : Bool = false
    @State var showAdminPopup : Bool = false
    
    @FocusState var focusedField: Field?
    
    @EnvironmentObject private var session: SessionManager
    
    public var body: some View {
        
        NavigationStack {
            
            VStack {
                
                TextField("Email", text: $viewModel.username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .focused($focusedField, equals: .username)
                
                PasswordField(title: "Password", text: $viewModel.password)
                    .keyboardType(.emailAddress)
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))
                    .focused($focusedField, equals: .password)
                
                PasswordField(title: "Password", text: $viewModel.confirmPassword)
                    .keyboardType(.emailAddress)
                    .padding(EdgeInsets(top: 6, leading: 20, bottom: 0, trailing: 20))
                    .focused($focusedField, equals: .confirmPassword)
                
                Button {
                    if !viewModel.isAdmin {
                        showAdminPopup = true
                    } else {
                        viewModel.isAdmin = false
                    }
                    
                } label: {

                    HStack(spacing: 10) {

                        Image(systemName: viewModel.isAdmin ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(.blue)

                        Text("Sign up as Admin")
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .padding(EdgeInsets(top: 15, leading: 18, bottom: 0, trailing: 0))
                
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
                        
                        guard let response = await viewModel.signUp() else { return }
                        
                        session.login(as: UserSession(username: response.username , isAdmin: response.isAdmin))
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            
            
            
        }
        .navigationTitle("Sign Up")
        
        .alert(
            "Admin Privileges",
            isPresented: $showAdminPopup
        ) {

            Button("Cancel", role: .cancel) {
                viewModel.isAdmin = false
            }

            Button("Continue") {
                viewModel.isAdmin = true
            }

        } message: {

            Text("""
            Admin users can delete all users from the database.

            Do you want to continue?
            """)
        }
    }
}

#Preview {
    SignUpView()
}
