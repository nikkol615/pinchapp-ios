import SwiftUI

@MainActor
final class SessionViewModel: ObservableObject {
    @Published var selectedTeaIndex: Int = 0 { didSet { onTeaChanged() } }
    @Published var currentSteepIndex: Int = 0
    @Published var isRunning: Bool = false
    @Published var isFinished: Bool = false
    @Published var skipRinse: Bool = false { didSet { onSkipRinseChanged() } }
    @Published var soundEnabled: Bool = false {
        didSet { UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled") }
    }
    let teas: [TeaType] = TeaData.all

    private(set) var startDate: Date? = nil
    private(set) var pausedSecondsRemaining: Int = 0
    private var completionTask: Task<Void, Never>? = nil

    var selectedTea: TeaType { teas[selectedTeaIndex] }
    var currentSteep: Steep { selectedTea.steeps[currentSteepIndex] }
    var isLastSteep: Bool { currentSteepIndex == selectedTea.steeps.count - 1 }
    var totalSteepTime: Int { currentSteep.seconds }

    var steepLabel: String {
        currentSteep.isRinse ? "Промывка" : "Пролив \(currentSteep.number)"
    }

    init() {
        loadCurrentSteep()
        restoreSettings()
    }

    // MARK: - Public API

    func start() {
        guard pausedSecondsRemaining > 0, !isRunning else { return }
        startDate = Date()
        isRunning = true
        isFinished = false
        scheduleCompletion(after: Double(pausedSecondsRemaining))
    }

    func pause() {
        guard isRunning else { return }
        pausedSecondsRemaining = Int(ceil(liveSecondsRemaining()))
        startDate = nil
        isRunning = false
        completionTask?.cancel()
        completionTask = nil
    }

    func nextSteep() {
        cancelTimer()
        guard !isLastSteep else { return }
        currentSteepIndex += 1
        loadCurrentSteep()
    }

    func reset() {
        cancelTimer()
        currentSteepIndex = skipRinse ? 1 : 0
        loadCurrentSteep()
    }

    // MARK: - Live progress (called every frame from TimelineView)

    func liveSecondsRemaining(at date: Date = Date()) -> Double {
        guard let start = startDate, isRunning else {
            return Double(pausedSecondsRemaining)
        }
        return max(0, Double(pausedSecondsRemaining) - date.timeIntervalSince(start))
    }

    func liveProgress(at date: Date = Date()) -> Double {
        guard totalSteepTime > 0 else { return 1 }
        return liveSecondsRemaining(at: date) / Double(totalSteepTime)
    }

    func formattedTime(_ seconds: Double) -> String {
        guard seconds > 0 else { return "0" }
        if seconds < 10 { return String(format: "%.1fс", seconds) }
        let s = Int(ceil(seconds))
        if s < 60 { return "\(s)с" }
        return String(format: "%d:%02d", s / 60, s % 60)
    }

    // MARK: - Private

    private func scheduleCompletion(after interval: Double) {
        completionTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            guard !Task.isCancelled else { return }
            startDate = nil
            isRunning = false
            pausedSecondsRemaining = 0
            isFinished = true
        }
    }

    private func cancelTimer() {
        completionTask?.cancel()
        completionTask = nil
        startDate = nil
        isRunning = false
        isFinished = false
    }

    private func loadCurrentSteep() {
        pausedSecondsRemaining = currentSteep.seconds
        isFinished = false
    }

    private func onTeaChanged() {
        cancelTimer()
        currentSteepIndex = skipRinse ? 1 : 0
        loadCurrentSteep()
        UserDefaults.standard.set(selectedTeaIndex, forKey: "lastTeaIndex")
    }

    private func onSkipRinseChanged() {
        guard skipRinse, currentSteepIndex == 0, !isRunning else { return }
        currentSteepIndex = 1
        loadCurrentSteep()
    }

    private func restoreSettings() {
        let lastTea = UserDefaults.standard.integer(forKey: "lastTeaIndex")
        if lastTea < teas.count { selectedTeaIndex = lastTea }
        soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
    }
}
