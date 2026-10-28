//
//  ToastView.swift
//  ios-interview
//
//  Created by James Weatherley on 28/10/2026.
//

import SwiftUI

public enum ToastStyle: Equatable {
    case success
    case error
    case info
    case warning
    
    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        case .warning: return .orange
        }
    }
}

public struct ToastConfig: Equatable {
    public var style: ToastStyle
    public var title: String
    public var subtitle: String?
    public var duration: TimeInterval
    public var haptics: Bool

    public init(style: ToastStyle, title: String, subtitle: String? = nil, duration: TimeInterval = 2.0, haptics: Bool = true) {
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.duration = duration
        self.haptics = haptics
    }
}

public struct ToastView: View {
    let config: ToastConfig

    public init(config: ToastConfig) {
        self.config = config
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: config.style.iconName)
                .font(.title3)
                .foregroundStyle(config.style.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text(config.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let subtitle = config.subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08))
        )
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 8)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(config.title + (config.subtitle != nil ? ": " + (config.subtitle ?? "") : "")))
    }
}

private struct ToastPresenter<Content: View>: View {
    @Binding var isPresented: Bool
    let config: ToastConfig
    let content: Content

    @State private var workItem: DispatchWorkItem?

    init(isPresented: Binding<Bool>, config: ToastConfig, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.config = config
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            content

            if isPresented {
                ToastView(config: config)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear(perform: scheduleAutoDismiss)
                    .onChange(of: isPresented) { _, newValue in
                        if newValue { scheduleAutoDismiss() }
                    }
                    .padding(.bottom, 24)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isPresented)
    }

    private func scheduleAutoDismiss() {
        workItem?.cancel()
        let item = DispatchWorkItem {
            withAnimation { isPresented = false }
        }
        workItem = item
        if config.haptics {
            #if os(iOS)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            #endif
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + config.duration, execute: item)
    }
}

public extension View {
    func toast(isPresented: Binding<Bool>, config: ToastConfig) -> some View {
        ToastPresenter(isPresented: isPresented, config: config) { self }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Demo below")
        Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemGroupedBackground))
    .modifier(ToastPreviewHelper())
}

private struct ToastPreviewHelper: ViewModifier {
    @State private var show = true
    func body(content: Content) -> some View {
        content
            .toast(isPresented: $show, config: .init(style: .success, title: "Payout sent", subtitle: "£123.45 to GB...6819"))
    }
}
