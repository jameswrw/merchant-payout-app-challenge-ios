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
        HStack {
            Button(action: action) {
                Text(title)
                    .fontWeight(.semibold)
                    .padding(8)
            }
            .accessibilityIdentifier(accessibilityIdentifier ?? "")
            .buttonStyle(.borderedProminent)
            .clipShape(Capsule())
            .disabled(isDisabled)
        }
        .frame(maxWidth: .infinity)
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
