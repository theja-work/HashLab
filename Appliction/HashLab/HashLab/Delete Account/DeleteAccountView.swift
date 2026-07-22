//
//  DeleteAccountView.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI

enum Field: Hashable {
    case username
    case password
    case confirmPassword
}

struct DeleteAccountView: View {
    
    @FocusState var focusedField: Field?
    
    @StateObject private var viewModel = DeleteAccountViewModel(dependency: DeleteAccountService())
    
    @State private var showDeleteAlert : Bool = false
    @State private var showSuccessToast: Bool = false
    
    @State private var navigateToLogin = false
    
    @EnvironmentObject private var session : SessionManager
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 16) {
                
                Text("Delete Account")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 32)
                
                Text("Logged in as")
                
                Text("\(session.username ?? "")")
                    .fontWeight(.semibold)
                
                PasswordField(title: "Password", text: $viewModel.password)
                    .keyboardType(.emailAddress)
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
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
                .buttonStyle(.borderedProminent)
                .disabled((viewModel.isLoading || !viewModel.isValid))
                
                
                .onChange(of: viewModel.password) { oldValue, newValue in
                    viewModel.errorMessage = nil
                }
                .padding(EdgeInsets(top: 32, leading: 10, bottom: 10, trailing: 10))
                .foregroundStyle(.red)
                
            }
            .blur(radius: showSuccessToast ? 6 : 0)
            .disabled(showSuccessToast)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                print("VStack tapped")
                focusedField = nil
            }
            
            if showSuccessToast {
                
                Color.black.opacity(0.18)
                            .ignoresSafeArea()
                
                Text("Account deleted successfully")
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
        
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            
            Button("OK", role: .destructive) {
                Task {
                    
                    guard let username = session.username else {return}
                    
                    await viewModel.deleteAccount(username)
                    
                    if viewModel.isDeleted {
                        showSuccessToast = true
                        try? await Task.sleep(nanoseconds: 1_600_000_000)
                        showSuccessToast = false
                        
                        Task {
                            await session.accountDeleted()
                        }
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        
    }
}

#Preview {
    DeleteAccountView()
}
