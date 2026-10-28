import SwiftUI

struct ProceedButton: View {
    let title: LocalizedStringKey
    let accessibilityIdentifier: String?
    let action: () -> Void
    var isDisabled: Bool

    init(_ title: LocalizedStringKey,
         accessibilityIdentifier: String? = nil,
         isDisabled: Bool = false,
         action: @escaping () -> Void) {
        self.title = title
        self.accessibilityIdentifier = accessibilityIdentifier
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .accessibilityIdentifier(accessibilityIdentifier ?? "")
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        ProceedButton("Primary Enabled") { }
        ProceedButton("Primary Disabled", isDisabled: true) { }
        ProceedButton("With ID", accessibilityIdentifier: "proceed") { }
    }
    .padding()
}
