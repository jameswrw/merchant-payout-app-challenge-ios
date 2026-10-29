//
//  PayoutView.swift
//  ios-interview
//
//  Created by James Weatherley on 27/10/2026.
//

import SwiftUI

struct PayoutView: View {
    
    @State var viewModel: PayoutViewModel
    @State private var showAuthError = false
    @State private var lastAuthError: Error?
    @State private var showToast = false
    @Environment(\.navigation) private var navigation

    let biometrics = BiometricsController()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Currency")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Picker("Currency", selection: $viewModel.currency) {
                        Text("GBP").tag(Currency.GBP)
                        Text("EUR").tag(Currency.EUR)
                    }
                    .pickerStyle(.tabs)

                    Text("Amount")
                        .foregroundStyle(.secondary)
                    TextField("Amount", text: Binding(
                        get: { viewModel.formattedAmount },
                        set: { newValue in
                            viewModel.updateAmount(from: newValue)
                        }
                    ))
                    .accessibilityIdentifier("amount")
                    .keyboardType(.decimalPad)
                    .textContentType(.none)
                    .padding()
                    .background(Color(uiColor: .systemBackground), in: Capsule())
                    .onChange(of: viewModel.currency) { _, _ in
                        viewModel.updateAmount(from: viewModel.formattedAmount)
                    }

                    Text("IBAN")
                        .foregroundStyle(.secondary)
                    TextField(
                        "IBAN",
                        text: $viewModel.iban,
                        prompt: Text("GB29NWBK60161331926819")
                    )
                    .accessibilityIdentifier("iban")
                    .textInputAutocapitalization(.characters)
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)
                    .padding()
                    .background(Color(uiColor: .systemBackground), in: Capsule())

                    if !viewModel.iban.isEmpty && !viewModel.isIBANValid {
                        Text("Please enter a valid IBAN. It should start with two letters and pass the checksum.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }

                    Text("International Bank Account Number. At least 15 characters starting with two uppercase country code letters (e.g. GB29NWBK60161331926819).")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
            }
            // Ensure the button is not covered by keyboard by adding a safe area inset
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    ProceedButton("Continue", accessibilityIdentifier: "continue", isDisabled: (viewModel.amount <= 0 || !viewModel.isIBANValid)) {
                        if viewModel.amount > 100_000 {
                            biometrics.authenticate { result in
                                switch result {
                                case .success:
                                    makePayment()
                                case .failure(let error):
                                    lastAuthError = error
                                    showAuthError = true
                                }
                            }
                        } else {
                            makePayment()
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Send Payout")
        .alert("Authentication Failed", isPresented: $showAuthError) {
            Button("OK", role: .confirm) {
                // Do nothing
            }
        } message: {
            Text(lastAuthError?.localizedDescription ?? "Authentication failed")
        }
        .toast(
            isPresented: $showToast,
            config: ToastConfig(
                style: .warning,
                title: "Security Notice",
                subtitle: "Screenshots of financial data may be a security risk.",
                duration: 5.0
            )
        )
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
            showToast = true
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    func makePayment() {
        let payoutDetailsViewModel = PayoutDetailsViewModel(
            amount: viewModel.amount,
            currency: viewModel.currency,
            iban: viewModel.iban,
            device_id: viewModel.deviceIdentity
        )
        navigation.path.append(Route.payoutConfirm(payoutDetailsViewModel))
    }
}

#Preview {
    PayoutView(viewModel: .init(deviceIdentity: nil))
}
