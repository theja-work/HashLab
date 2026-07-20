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
            
            isDeleted = true
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
    }
}
