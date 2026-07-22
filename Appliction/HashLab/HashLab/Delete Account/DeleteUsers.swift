//
//  DeleteUsers.swift
//  HashLab
//
//  Created by Thejas Kasaba on 21/07/26.
//

import SwiftUI

struct DeleteUsers: View {
    
    @FocusState var focusedField : Field?
    
    @StateObject private var viewModel : DeleteAccountViewModel = DeleteAccountViewModel(dependency: DeleteAccountService())
    
    @State var showDeleteAlert : Bool = false
    @State var showSuccessToast : Bool = false
    @State var navigateToLogin : Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                VStack(spacing: 16) {
                    
                    Text("Delete Users")
                        .font(.largeTitle)
                        .bold()
                    
                    Form {
                        
                        TextField("Email", text: $viewModel.username)
                            .focused($focusedField, equals: .username)
                        
                        SecureField("Password", text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                        
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .focused($focusedField, equals: .confirmPassword)
                        
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        
                        Text(errorMessage)
                            .onAppear(perform: {
                                print("Login failed : \(errorMessage)")
                            })
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        
                        if viewModel.isLoading {
                            ProgressView()
                        }
                        else {
                            Text("Delete")
                                .bold()
                        }
                    }
                    .disabled(viewModel.isLoading || !viewModel.isValid)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.red)
                    
                    .onChange(of: viewModel.username) { oldValue, newValue in
                        viewModel.errorMessage = nil
                    }
                    .onChange(of: viewModel.password) { oldValue, newValue in
                        viewModel.errorMessage = nil
                    }
                }
                .blur(radius: showSuccessToast ? 6 : 0)
                .disabled(showSuccessToast)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    //print("VStack tapped")
                    focusedField = nil
                }
                
                if showSuccessToast {
                    
                    Color.black.opacity(0.18)
                                .ignoresSafeArea()
                    
                    Text("Users deleted successfully. Total users deleted : \(viewModel.deletedUsersCount)")
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.bottom, 40)
                        .shadow(radius: 8)
                        .transition(.scale.combined(with: .opacity))
                }
                
            }
            .animation(.easeInOut(duration: 0.25), value: showSuccessToast)
            
            .alert("Delete Users", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                
                Button("OK", role: .destructive) {
                    Task {
                        await viewModel.deleteUsers()
                        
                        if viewModel.isDeleted {
                            showSuccessToast = true
                            try? await Task.sleep(nanoseconds: 1_600_000_000)
                            showSuccessToast = false
                            
                            navigateToLogin = true
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete all the users? This action cannot be undone.")
            }
            
            .navigationDestination(isPresented: $navigateToLogin) {
                LoginView()
            }
            
        }
        
    }
}

#Preview {
    DeleteUsers()
}
