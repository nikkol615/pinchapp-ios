import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \SessionRecord.date, order: .reverse) private var allSessions: [SessionRecord]
    @Environment(\.modelContext) private var context

    private var sessions: [SessionRecord] { Array(allSessions.prefix(20)) }

    var body: some View {
        ZStack {
            if sessions.isEmpty {
                emptyState
            } else {
                VStack(spacing: 0) {
                    header
                    sessionList
                }
            }
        }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text("История")
                .font(.title2.weight(.semibold))
                .foregroundColor(.appPrimary)
            Spacer()
            Text("\(sessions.count) сессий")
                .font(.caption)
                .foregroundColor(.appSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: List

    private var sessionList: some View {
        List {
            ForEach(sessions) { session in
                sessionRow(session)
                    .listRowBackground(Color.appSurface)
                    .listRowSeparatorTint(Color.appSecondary.opacity(0.15))
            }
            .onDelete(perform: deleteSession)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func sessionRow(_ session: SessionRecord) -> some View {
        HStack(spacing: 14) {
            // Tea icon dot
            Circle()
                .fill(Color.appAccent.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.appAccent)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(session.teaName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.appPrimary)
                Text(session.steepLabel)
                    .font(.caption)
                    .foregroundColor(.appAccent)
            }

            Spacer()

            Text(session.relativeDate)
                .font(.caption)
                .foregroundColor(.appSecondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 10)
    }

    // MARK: Empty state

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 52))
                .foregroundColor(.appSecondary)
            Text("История пуста")
                .font(.title3.weight(.semibold))
                .foregroundColor(.appPrimary)
            Text("Завершённые сессии\nпоявятся здесь")
                .font(.subheadline)
                .foregroundColor(.appSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Delete

    private func deleteSession(at offsets: IndexSet) {
        for i in offsets { context.delete(sessions[i]) }
    }
}

#Preview {
    ZStack {
        Color.appBg.ignoresSafeArea()
        HistoryView()
    }
    .modelContainer(for: SessionRecord.self, inMemory: true)
}
