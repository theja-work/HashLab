//
//  DeveloperSettingsViewModel.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//

import Combine
import SwiftUI

@MainActor
final class DeveloperSettingsViewModel: ObservableObject {

    @Published var authenticationMode: AuthenticationMode = AppConfiguration.authenticationMode
    @Published var hashingMode: HashingMode = AppConfiguration.hashingMode

    @Published var isLoading = false
    @Published var toastMessage: String?

    private let service: DeveloperSettingsServiceProtocol

    init(service: DeveloperSettingsServiceProtocol) {
        self.service = service
    }

    // MARK: Authentication

    func updateAuthentication(
        _ mode: AuthenticationMode
    ) async {

        guard authenticationMode != mode else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let response = try await service.updateAuthentication(mode)

            authenticationMode = mode
            
            AppConfiguration.authenticationMode = .from(mode.rawValue)

            toastMessage = response.message

        } catch {

            toastMessage = error.localizedDescription
        }
    }

    // MARK: Hashing

    func updateHashing(
        _ mode: HashingMode
    ) async {

        guard hashingMode != mode else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let response = try await service.updateHashing(mode)

            hashingMode = mode

            AppConfiguration.hashingMode = .from(mode.rawValue)

            toastMessage = response.message

        } catch {

            toastMessage = error.localizedDescription
        }
    }

    // MARK: Initial Sync

    func loadConfiguration() async {

        do {

            let authentication = try await service.fetchAuthenticationMode()

            authenticationMode = AuthenticationMode(
                rawValue: authentication.mode
            ) ?? .JWT

            AppConfiguration.authenticationMode = .from(authentication.mode)
            
            let hashing = try await service.fetchHashingMode()

            hashingMode = HashingMode(
                rawValue: hashing.mode
            ) ?? .plain
            
            AppConfiguration.hashingMode = .from(hashing.mode)

        } catch {

            toastMessage = error.localizedDescription
        }
    }
}
