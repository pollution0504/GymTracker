//
//  HistoryView.swift
//  GymTracker
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \LoggedDay.date, order: .reverse) private var loggedDays: [LoggedDay]
    @Environment(\.modelContext) private var modelContext
    @State private var dayPendingDeletion: LoggedDay?
    
    var body: some View {
        NavigationStack {
            Group {
                if loggedDays.isEmpty {
                    ContentUnavailableView(
                        "No Workouts Yet",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Finish a session to see it here")
                    )
                } else {
                    List {
                        ForEach(loggedDays) { day in
                            NavigationLink {
                                LoggedDayDetailView(loggedDay: day)
                            } label: {
                                HistoryRow(day: day)
                            }
                            .transition(.opacity.combined(with: .slide))
                        }
                        .onDelete { offsets in
                            dayPendingDeletion = offsets.map { loggedDays[$0] }.first
                        }
                    }
                    .listStyle(.plain)
                    .alert("Delete this workout?", isPresented: Binding(
                        get: { dayPendingDeletion != nil },
                        set: { if !$0 { dayPendingDeletion = nil } }
                    )) {
                        Button("Cancel", role: .cancel) {
                            dayPendingDeletion = nil
                        }
                        Button("Delete", role: .destructive) {
                            if let day = dayPendingDeletion {
                                withAnimation {
                                    modelContext.delete(day)
                                }
                            }
                            dayPendingDeletion = nil
                        }
                    } message: {
                        if let day = dayPendingDeletion {
                            Text("This will permanently delete your \(day.routineDayName) session from \(day.date.formatted(date: .abbreviated, time: .omitted)).")
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

private struct HistoryRow: View {
    let day: LoggedDay

    private var totalSets: Int {
        day.loggedExercises.reduce(0) { $0 + $1.sets.count }
    }

    private var swappedCount: Int {
        day.loggedExercises.filter { $0.wasSwapped }.count
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(day.date.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.8))
                Text(day.date.formatted(.dateTime.day()))
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            .background(.orange.gradient, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(day.routineDayName)
                    .font(.headline)

                HStack(spacing: 8) {
                    Label("\(day.loggedExercises.count) exercises", systemImage: "figure.strengthtraining.traditional")
                    Label("\(totalSets) sets", systemImage: "checkmark.circle")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if swappedCount > 0 {
                    Text("\(swappedCount) swapped")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.orange.opacity(0.15))
                        .foregroundStyle(.orange)
                        .clipShape(Capsule())
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}
