import SwiftUI
import AudioToolbox
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Colors

extension Color {
    static let appBg        = Color(red: 13/255,  green: 13/255,  blue: 13/255)
    static let appSurface   = Color(red: 28/255,  green: 28/255,  blue: 30/255)
    static let appAccent    = Color(red: 214/255, green: 40/255,  blue: 40/255)
    static let appPrimary   = Color(red: 245/255, green: 245/255, blue: 245/255)
    static let appSecondary = Color(red: 142/255, green: 142/255, blue: 147/255)
}

// MARK: - Mountain decorative background

struct MountainBackgroundView: View {
    var body: some View {
        Canvas { ctx, size in
            var path = Path()
            path.move(to:     CGPoint(x: 0,                y: size.height))
            path.addLine(to:  CGPoint(x: size.width * 0.10, y: size.height * 0.76))
            path.addLine(to:  CGPoint(x: size.width * 0.28, y: size.height * 0.87))
            path.addLine(to:  CGPoint(x: size.width * 0.48, y: size.height * 0.58))
            path.addLine(to:  CGPoint(x: size.width * 0.65, y: size.height * 0.80))
            path.addLine(to:  CGPoint(x: size.width * 0.80, y: size.height * 0.63))
            path.addLine(to:  CGPoint(x: size.width,        y: size.height * 0.73))
            path.addLine(to:  CGPoint(x: size.width,        y: size.height))
            path.closeSubpath()
            ctx.fill(path, with: .color(Color.appAccent.opacity(0.05)))
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Circular timer
//
// progress: 1.0 = full (start) → 0.0 = empty (finished)
// No SwiftUI animation on the trim — smooth motion comes from TimelineView updates.
// Animation only fires on isFinished toggle (ring fill & content swap).

struct CircularTimerView: View {
    let progress: Double
    let timeText: String
    let isRinse: Bool
    let isFinished: Bool
    var diameter: CGFloat = 230
    var onNextSteep: (() -> Void)? = nil

    private var ringColor: Color { isRinse ? .appSecondary : .appAccent }
    private var lineWidth: CGFloat { diameter * 0.061 }
    private var timeFontSize: CGFloat { diameter * 0.226 }
    private var checkmarkSize: CGFloat { diameter * 0.174 }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Color.appSurface, lineWidth: lineWidth)

            // Countdown ring — no animation modifier, TimelineView handles smoothness
            if !isFinished {
                Circle()
                    .trim(from: 0, to: max(0.002, progress))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }

            // Completion ring — fades in when finished
            if isFinished {
                Circle()
                    .stroke(ringColor, lineWidth: lineWidth)
                    .transition(.opacity.combined(with: .scale(scale: 0.88)))
            }

            // Center content
            Group {
                if isFinished {
                    VStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: checkmarkSize, weight: .bold))
                            .foregroundColor(ringColor)

                        if onNextSteep != nil {
                            HStack(spacing: 4) {
                                Text("след. пролив")
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 10))
                            }
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(ringColor.opacity(0.8))
                        }
                    }
                    .transition(.scale(scale: 0.72).combined(with: .opacity))
                } else {
                    VStack(spacing: 4) {
                        Text(timeText)
                            .font(.system(size: timeFontSize, weight: .bold, design: .rounded))
                            .foregroundColor(.appPrimary)
                            .monospacedDigit()
                            .contentTransition(.numericText(countsDown: true))
                        Text("осталось")
                            .font(.caption)
                            .foregroundColor(.appSecondary)
                    }
                    .transition(.opacity)
                }
            }
        }
        // This animation only fires when isFinished flips — not on every progress tick
        .animation(.easeOut(duration: 0.38), value: isFinished)
        .frame(width: diameter, height: diameter)
        .contentShape(Circle())
        .onTapGesture {
            guard isFinished else { return }
            onNextSteep?()
        }
    }
}

// MARK: - Steep progress indicator

struct SteepDotsView: View {
    let total: Int
    let current: Int

    var body: some View {
        if total <= 10 {
            HStack(spacing: 6) {
                ForEach(0..<total, id: \.self) { i in
                    Circle()
                        .fill(i <= current ? Color.appAccent : Color.appSurface)
                        .frame(width: i == current ? 10 : 6, height: i == current ? 10 : 6)
                        .animation(.spring(response: 0.3), value: current)
                }
            }
        } else {
            Text("\(current + 1) / \(total)")
                .font(.caption.monospacedDigit())
                .foregroundColor(.appSecondary)
        }
    }
}

// MARK: - Session view

struct SessionView: View {
    @ObservedObject var vm: SessionViewModel

    // Compact sizes on Mac Catalyst
    private var circleSize:    CGFloat { isMac ? 180 : 230 }
    private var primaryBtn:    CGFloat { isMac ? 56  : 72  }
    private var secondaryBtn:  CGFloat { isMac ? 42  : 52  }
    private var timerSpacing:  CGFloat { isMac ? 14  : 20  }
    private var noteMinHeight: CGFloat { isMac ? 28  : 40  }
    private var topPad:        CGFloat { isMac ? 10  : 16  }
    private var isMac: Bool {
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return false
        #endif
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            MountainBackgroundView().ignoresSafeArea()

            VStack(spacing: 0) {
                teaPickerBlock
                    .padding(.horizontal, 16)
                    .padding(.top, topPad)
                Spacer()
                timerBlock
                Spacer()
            }
        }
        .onChange(of: vm.isFinished) { _, finished in
            guard finished else { return }
            triggerFinishedEffects()
        }
    }

    // MARK: Top block — tea picker

    private var teaPickerBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Tea selector row
            Menu {
                ForEach(vm.teas.indices, id: \.self) { i in
                    Button(vm.teas[i].name) { vm.selectedTeaIndex = i }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(vm.selectedTea.name)
                        .font(.headline)
                        .foregroundColor(.appPrimary)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.appAccent)
                }
            }

            Text(vm.selectedTea.description)
                .font(.caption)
                .foregroundColor(.appSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .transition(.opacity)
                .id(vm.selectedTea.id)

            // Options row
            HStack(spacing: 12) {
                Toggle("", isOn: $vm.skipRinse)
                    .labelsHidden()
                    .tint(.appAccent)
                Text("Без промывки")
                    .font(.caption2)
                    .foregroundColor(.appSecondary)

                Spacer()

                // Sound toggle
                Button { vm.soundEnabled.toggle() } label: {
                    Image(systemName: vm.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                        .font(.caption2.weight(.medium))
                        .foregroundColor(vm.soundEnabled ? .appAccent : .appSecondary)
                        .frame(width: 28, height: 28)
                        .background(vm.soundEnabled ? Color.appAccent.opacity(0.12) : Color.appBg.opacity(0.5))
                        .cornerRadius(6)
                }
            }
        }
        .padding(16)
        .background(Color.appSurface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 4)
    }

    // MARK: Middle block — timer
    // TimelineView drives the circle and time text at ~30fps — no SwiftUI animation lag

    private var timerBlock: some View {
        VStack(spacing: timerSpacing) {
            Text(vm.steepLabel)
                .font(.title2.weight(.semibold))
                .foregroundColor(vm.currentSteep.isRinse ? .appSecondary : .appPrimary)
                .animation(.easeOut(duration: 0.2), value: vm.currentSteepIndex)

            TimelineView(.animation(minimumInterval: 1/30)) { tl in
                CircularTimerView(
                    progress: vm.liveProgress(at: tl.date),
                    timeText: vm.formattedTime(vm.liveSecondsRemaining(at: tl.date)),
                    isRinse: vm.currentSteep.isRinse,
                    isFinished: vm.isFinished,
                    diameter: circleSize,
                    onNextSteep: vm.isLastSteep ? nil : { vm.nextSteep() }
                )
            }

            ZStack {
                if !vm.currentSteep.note.isEmpty {
                    Text(vm.currentSteep.note)
                        .font(.subheadline)
                        .foregroundColor(.appSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: 10)),
                            removal: .opacity
                        ))
                }
            }
            .frame(minHeight: noteMinHeight)
            .animation(.easeOut(duration: 0.25), value: vm.currentSteepIndex)

            controlButtons

            SteepDotsView(total: vm.selectedTea.steeps.count, current: vm.currentSteepIndex)
                .padding(.top, 4)
        }
    }

    // MARK: Control buttons

    private var controlButtons: some View {
        HStack(spacing: 16) {
            // Reset
            Button { vm.reset() } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(isMac ? .body : .title3)
                    .foregroundColor(.appSecondary)
                    .frame(width: secondaryBtn, height: secondaryBtn)
                    .background(Color.appSurface)
                    .clipShape(Circle())
            }

            // Start / Pause
            Button {
                vm.isRunning ? vm.pause() : vm.start()
            } label: {
                Image(systemName: vm.isRunning ? "pause.fill" : "play.fill")
                    .font(isMac ? .title3 : .title2)
                    .foregroundColor(vm.isFinished ? .appSecondary : .appPrimary)
                    .frame(width: primaryBtn, height: primaryBtn)
                    .background(vm.isFinished ? Color.appSurface : Color.appAccent)
                    .clipShape(Circle())
                    .shadow(color: vm.isFinished ? .clear : Color.appAccent.opacity(0.45), radius: 14, x: 0, y: 4)
                    .animation(.easeInOut(duration: 0.3), value: vm.isFinished)
            }
            .disabled(vm.isFinished)
            .keyboardShortcut(.space, modifiers: [])

            // Next steep
            Button { vm.nextSteep() } label: {
                Image(systemName: "forward.end.fill")
                    .font(isMac ? .body : .title3)
                    .foregroundColor(nextIconColor)
                    .frame(width: secondaryBtn, height: secondaryBtn)
                    .background(nextBgColor)
                    .clipShape(Circle())
                    .shadow(color: vm.isFinished ? Color.appAccent.opacity(0.55) : .clear, radius: 10)
                    .animation(.easeInOut(duration: 0.3), value: vm.isFinished)
            }
            .disabled(vm.isLastSteep)
            .keyboardShortcut(.rightArrow, modifiers: [])
        }
    }

    private var nextIconColor: Color {
        if vm.isLastSteep { return .appSecondary.opacity(0.3) }
        return vm.isFinished ? .appAccent : .appSecondary
    }

    private var nextBgColor: Color {
        vm.isFinished ? Color.appAccent.opacity(0.18) : Color.appSurface
    }

    // MARK: Finish effects

    private func triggerFinishedEffects() {
        #if canImport(UIKit)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif
        #if os(iOS)
        if vm.soundEnabled {
            AudioServicesPlaySystemSound(1007)
        }
        #endif
    }
}

#Preview {
    ZStack {
        Color.appBg.ignoresSafeArea()
        SessionView(vm: SessionViewModel())
    }
}
