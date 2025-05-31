import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var isExpandedSettings = false
    @State private var isExpandedTweaks = false
    @State private var isExpandedAuthors = false
    @State private var isHidden = false
    @State private var pathText = ""
    @State private var hapticEngine: CHHapticEngine?

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("NowFine")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.top, 60)
                    .padding(.bottom, 40)

                VStack(spacing: 16) {
                    // Кнопка "Настроить"
                    ExpandingButton(title: "Настроить", systemImage: "gearshape", isExpanded: $isExpandedSettings) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpandedSettings.toggle()
                            triggerHaptic()
                        }
                    }
                    
                    if isExpandedSettings {
                        VStack(spacing: 12) {
                            Toggle("", isOn: $isHidden)
                                .toggleStyle(MinimalToggleStyle())
                                .transition(.opacity)
                            TextField("Введите путь", text: $pathText)
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .padding(10)
                                .background(
                                    Color(.systemBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color(.separator), lineWidth: 1)
                                        )
                                )
                                .transition(.opacity)
                        }
                        .padding(20)
                        .background(
                            Color(.secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color(.separator), lineWidth: 1.5)
                                )
                        )
                    }
                    // Кнопка "Твики"
                    ExpandingButton(title: "Твики", systemImage: "wrench.and.screwdriver", isExpanded: $isExpandedTweaks) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpandedTweaks.toggle()
                            triggerHaptic()
                        }
                    }
                    
                    if isExpandedTweaks {
                        VStack(spacing: 12) {
                            Text("Настройки твиков скоро появятся")
                                .font(.system(size: 16, weight: .regular, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .background(
                            Color(.secondarySystemBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color(.separator), lineWidth: 1.5)
                                )
                        )
                    }

                    // Кнопка "Авторы"
                    ExpandingButton(title: "Авторы", systemImage: "person.3", isExpanded: $isExpandedAuthors) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpandedAuthors.toggle()
                            triggerHaptic()
                        }
                    }
                    
                    if isExpandedAuthors {
                        VStack(spacing: 12) {
                            AuthorAsset(name: "Melont1s", imageName: "person.circle.fill")
                        }
                        .padding(20)
                        .background(
                            Color(.secondarySystemBackground).opacity(0.7)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(Color(.separator), lineWidth: 1.5)
                                )
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .onAppear {
            prepareHaptics()
        }
    }

    // Подготовка haptic-эффектов
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Ошибка инициализации haptic engine: \(error)")
        }
    }

    // Запуск haptic-эффекта
    private func triggerHaptic() {
        guard let engine = hapticEngine else { return }
        var events = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Ошибка воспроизведения haptic: \(error)")
        }
    }
}

// Компонент кнопки с раскрытием
struct ExpandingButton: View {
    let title: String
    let systemImage: String
    @Binding var isExpanded: Bool
    let action: () -> Void
var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
            }
            .foregroundColor(.primary)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                Color(.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color(.separator), lineWidth: 1.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// Компонент для отображения автора с ассетом
struct AuthorAsset: View {
    let name: String
    let imageName: String // Имя системной иконки или ассета
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color(.separator), lineWidth: 1)
                )
            Text(name)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
        }
    }
}

// Стиль для переключателя
struct MinimalToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        configuration.isOn
                            ? LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.purple.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            : LinearGradient(
                                gradient: Gradient(colors: [Color(.systemGray4)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                    .frame(width: 52, height: 32)
                    .shadow(color: .blue.opacity(0.4), radius: 8, x: 0, y: 0)
                    .shadow(color: .purple.opacity(0.2), radius: 4, x: 0, y: 0)

                Circle()
                    .fill(.white)
                    .frame(width: 28, height: 28)
                    .offset(x: configuration.isOn ? 10 : -10)
                    .scaleEffect(configuration.isOn ? 1.05 : 1.0)
                    .shadow(color: .blue.opacity(0.5), radius: 6, x: 0, y: 0)
            }
            .contentShape(.rect)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}
