//
//  SettingsView.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//

import SwiftUI

struct DeveloperSettingsView: View {
    
    @AppStorage("authenticationMode")
    private var authenticationMode = AuthenticationMode.JWT.rawValue
    
    @AppStorage("hashingMode")
        private var hashingMode = HashingMode.plain.rawValue
    
    @StateObject
    private var viewModel = DeveloperSettingsViewModel(
        service: DeveloperSettingsService()
    )
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                Form {
                    
                    authenticationSection
                    
                    hashingSection
                    
                    currentConfiguration
                    
                }
                
                if viewModel.isLoading {
                    
                    ProgressView()
                        .controlSize(.large)
                }
                
                if showToast {
                    
                    VStack {
                        
                        Spacer()
                        
                        Text(toastMessage)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(.black.opacity(0.85))
                            .clipShape(Capsule())
                            .padding(.bottom, 30)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut, value: showToast)
            .navigationTitle("Developer Settings")
        }
        .onChange(of: viewModel.toastMessage) { oldValue, newValue in
            guard let message = newValue else { return }
            showToast(message)
        }
    }
    
    private func showToast(_ message: String) {

        toastMessage = message

        withAnimation {
            showToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {

            withAnimation {
                showToast = false
            }
        }
    }
    
    private var authenticationSection: some View {

        Section {

            Text("""
    Choose how users are authenticated while using HashLab.
    """)
            .font(.footnote)

            SettingOptionRow(

                title: "JWT Authentication",

                subtitle:
    """
    Uses Bearer Tokens after login.
    Passwords are only requested for sensitive operations.
    """,

                isSelected: viewModel.authenticationMode == .JWT

            ) {

                Task {
                    await viewModel.updateAuthentication(.JWT)
                }
            }

            SettingOptionRow(

                title: "Legacy Authentication",

                subtitle:
    """
    Every protected request requires username and password.
    Useful for understanding traditional authentication.
    """,

                isSelected: viewModel.authenticationMode == .Legacy

            ) {

                Task {
                    await viewModel.updateAuthentication(.Legacy)
                }
            }

        } header: {

            Text("Authentication")
        }
    }
    
    private var hashingSection: some View {

        Section {

            Text("""
    Choose how passwords are stored inside the database.
    """)
            .font(.footnote)

            SettingOptionRow(

                title: "Salted Hashing",

                subtitle:
    """
    A random salt is generated for every password before hashing.
    This is the recommended production approach.
    """,

                isSelected: viewModel.hashingMode == .salted

            ) {
                Task {
                    await viewModel.updateHashing(.salted)
                }
            }

            SettingOptionRow(

                title: "Plain Hashing",

                subtitle:
    """
    Only the hash value is stored.
    Useful for demonstrating rainbow-table attacks.
    """,

                isSelected: viewModel.hashingMode == .plain

            ) {
                Task {
                    await viewModel.updateHashing(.plain)
                }
            }

        } header: {

            Text("Password Hashing")
        }
    }
    
    private var currentConfiguration: some View {

        Section("Current Configuration") {

            LabeledContent(
                "Authentication",
                value: viewModel.authenticationMode.title
            )

            LabeledContent(
                "Password Hashing",
                value: viewModel.hashingMode.title
            )
        }
    }
}

#Preview {
    DeveloperSettingsView()
}

