import SwiftUI

struct ContentView: View {
    @StateObject private var vm = SessionViewModel()
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            Color.appBg.ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    if selectedTab == 0 {
                        SessionView(vm: vm)
                    } else {
                        CalculatorView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                tabSwitcher
            }
        }
        .preferredColorScheme(.dark)
        #if targetEnvironment(macCatalyst)
        .onReceive(NotificationCenter.default.publisher(for: UIScene.didActivateNotification)) { note in
            guard let scene = note.object as? UIWindowScene else { return }
            scene.sizeRestrictions?.minimumSize = CGSize(width: 320, height: 620)
            scene.sizeRestrictions?.maximumSize = CGSize(width: 320, height: 620)
        }
        #endif
    }

    // MARK: Tab switcher

    private var tabSwitcher: some View {
        HStack(spacing: 0) {
            tabButton(title: "Таймер",      icon: "timer",     tag: 0)
            tabButton(title: "Калькулятор", icon: "scalemass", tag: 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appSurface)
    }

    private func tabButton(title: String, icon: String, tag: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { selectedTab = tag }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(selectedTab == tag ? .appAccent : .appSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(selectedTab == tag ? Color.appAccent.opacity(0.12) : Color.clear)
            .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
