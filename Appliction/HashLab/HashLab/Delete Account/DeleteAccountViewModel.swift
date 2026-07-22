//
//  DeleteAccountViewModel.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import SwiftUI
import Combine

@MainActor
class DeleteAccountViewModel : ObservableObject {
    
    @Published var isDeleted : Bool = false
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var confirmPassword : String = ""
    @Published var deletedUsersCount : Int = 0
    
    private let deleteService : DeleteAccountServiceProtocol
    
    var isValid : Bool { password.count >= 6 }
    
    init(dependency : DeleteAccountServiceProtocol) {
        deleteService = dependency
    }
    
    func deleteAccount() async {
        
        guard isValid else {
            errorMessage = "Invalid credentials"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isDeleted = false
        
        do {
            
            let token = try await deleteService.deleteAccount(username, password)
            Logger.log(token.message)
            
            isDeleted = token.success
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
    }
    
    func deleteUsers() async {
        
        guard isValid else {
            errorMessage = "Invalid Credentials"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords should match"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isDeleted = false
        
        do {
            let response = try await deleteService.deleteUsers(username, password)
            
            Logger.log(response.message)
            Logger.log(response.deletedUserCount)
            self.deletedUsersCount = response.deletedUserCount
            isDeleted = response.success
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
    }
}
