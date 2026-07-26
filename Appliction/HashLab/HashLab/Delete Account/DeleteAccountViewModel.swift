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
    @Published var password : String = ""
    @Published var deletedUsersCount : Int = 0
    
    private let deleteService : DeleteAccountServiceProtocol
    
    var isValid : Bool { password.count >= 6 }
    
    init(dependency : DeleteAccountServiceProtocol) {
        deleteService = dependency
    }
    
    func deleteAccount(_ username : String? = nil, _ password : String) async {
        
        guard isValid else {
            errorMessage = "Invalid credentials"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isDeleted = false
        
        do {
            
            let usernameToSend: String?

            switch AppConfiguration.authenticationMode {

            case .JWT:
                usernameToSend = nil

            case .Legacy:
                
                guard let username = username else {
                    errorMessage = "Username unavailable"
                    isLoading = false
                    return
                }
                
                usernameToSend = username
            }

            let response = try await deleteService.deleteAccount(
                usernameToSend,
                password
            )
            
            isDeleted = response.success
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
    }
    
    func deleteUsers(_ username : String? = nil, _ password : String) async {
        
        guard isValid else {
            errorMessage = "Invalid Credentials"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isDeleted = false
        
        do {
            
            let usernameToSend: String?

            switch AppConfiguration.authenticationMode {

            case .JWT:
                usernameToSend = nil

            case .Legacy:
                
                guard let username = username else {
                    errorMessage = "Username unavailable"
                    isLoading = false
                    return
                }
                
                usernameToSend = username
            }
            
            let response = try await deleteService.deleteUsers(
                usernameToSend,
                password
            )
            
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
