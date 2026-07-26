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
    
    @EnvironmentObject private var session : SessionManager
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        
        
        ZStack {
            
            VStack(spacing: 16) {
                
                Text("Delete Users")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 32)
                
                Text("Logged in as")
                
                Text("\(session.username ?? "")")
                    .fontWeight(.semibold)
                
                PasswordField(title: "Password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                
                if let errorMessage = viewModel.errorMessage {
                    
                    Text(errorMessage)
                        .onAppear(perform: {
                            Logger.log(errorMessage)
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
                .padding(EdgeInsets(top: 6, leading: 0, bottom: 100, trailing: 0))
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.red)
                
                .onChange(of: viewModel.password) { oldValue, newValue in
                    viewModel.errorMessage = nil
                }
            }
            .blur(radius: showSuccessToast ? 6 : 0)
            .disabled(showSuccessToast)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            
            if showSuccessToast {
                
                Color.black.opacity(0.18)
                    .ignoresSafeArea()
                
                Text("Users deleted successfully.\n Total users deleted : \(viewModel.deletedUsersCount)")
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
                    
                    switch AppConfiguration.authenticationMode {
                    case .JWT :
                        
                        await viewModel.deleteUsers(nil, viewModel.password)
                        
                    case .Legacy :
                        
                        await viewModel.deleteUsers(session.username, viewModel.password)
                        
                    }
                    
                    if viewModel.isDeleted {
                        showSuccessToast = true
                        try? await Task.sleep(nanoseconds: 1_600_000_000)
                        showSuccessToast = false
                        
                        dismiss()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete all the users? This action cannot be undone.")
        }
        
    }
}

#Preview {
    DeleteUsers()
}
