//
//  BiometricsController.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//
import LocalAuthentication

final class BiometricsController {
    func authenticate(useBiometricsOnly: Bool = true, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"

        var error: NSError?
        let policy: LAPolicy = useBiometricsOnly ? .deviceOwnerAuthenticationWithBiometrics : .deviceOwnerAuthentication

        guard context.canEvaluatePolicy(policy, error: &error) else {
            completion(.failure(error ?? LAError(.biometryNotAvailable)))
            return
        }

        context.evaluatePolicy(policy, localizedReason: "Unlock with Face ID") { success, evalError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(evalError ?? LAError(.authenticationFailed)))
                }
            }
        }
    }
}
