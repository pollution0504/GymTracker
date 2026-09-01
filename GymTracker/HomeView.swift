//
//  HomeView.swift
//  GymTracker
//

import SwiftUI
import SwiftData
import Charts

struct HomeView: View {
    @Query private var routines: [Routine]
    @Query(sort: \LoggedDay.date, order: .reverse) private var loggedDays: [LoggedDay]
    @Environment(\.modelContext) private var modelContext
    @AppStorage("userName") private var userName: String = ""

    @State private var startingDay: RoutineDay?

    private var todaysDay: RoutineDay? {
        RoutineScheduler.todaysDay(across: routines)
    }

    private var skippedToday: Bool {
        let calendar = Calendar.current
        return loggedDays.contains { $0.isSkipped && calendar.isDateInToday($0.date) }
    }

    private var workoutsThisWeek: Int {
        HomeStats.workoutsThisWeek(loggedDays)
    }

    private var streak: Int {
        HomeStats.currentStreak(loggedDays)
    }

    private var weekData: [(day: String, count: Int)] {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return []
        }
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: weekStart) ?? weekStart
            let dayLetter = date.formatted(.dateTime.weekday(.narrow))
            let count = loggedDays.filter { !$0.isSkipped && calendar.isDate($0.date, inSameDayAs: date) }.count
            return (day: dayLetter, count: count)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(userName.isEmpty ? "Hello" : "Hello, \(userName)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 12)

                    Text(Date().formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    if skippedToday {
                        skippedCard
                    } else if let day = todaysDay {
                        planCard(for: day)
                    } else {
                        emptyPlanCard
                    }

                    HStack(spacing: 12) {
                        statCard(title: "This Week", value: "\(workoutsThisWeek)", unit: "workouts")
                        statCard(title: "Streak", value: "\(streak)", unit: "days")
                    }

                    weeklyChart

                    if !loggedDays.isEmpty {
                        recentActivity
                    }

                    if !routines.isEmpty {
                        yourRoutines
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $startingDay) { day in
                WorkoutSessionView(day: day)
            }
        }
    }

    // MARK: - Plan Card

    private func planCard(for day: RoutineDay) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's plan")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(day.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }

                Spacer()

                Button {
                    startingDay = day
                } label: {
                    Label("Start", systemImage: "play.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.white, in: RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.blue)
                }
            }

            Button {
                skipToday(day)
            } label: {
                Text("Skip today")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.85))
            }
        }
        .padding()
        .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 16))
    }

    private var emptyPlanCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No routines yet")
                .font(.headline)
            Text("Head to My Routines to set up your first workout plan")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }

    private var skippedCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's plan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Day skipped")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
            Button {
                unskipToday()
            } label: {
                Text("Undo")
                    .font(.subheadline.weight(.semibold))
            }
        }
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
    private func skipToday(_ day: RoutineDay) {
        withAnimation {
            let skipped = LoggedDay(date: Date(), routineDayName: day.name, isSkipped: true)
            modelContext.insert(skipped)
        }
    }
    
    private func unskipToday() {
        let calendar = Calendar.current
        if let skipped = loggedDays.first(where: { $0.isSkipped && calendar.isDateInToday($0.date) }) {
            withAnimation {
                modelContext.delete(skipped)
            }
        }
    }
    
    // MARK: - Stats

    private func statCard(title: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 40, weight: .bold))
                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Weekly Chart

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week's Activity")
                .font(.headline)

            Chart(weekData, id: \.day) { entry in
                BarMark(
                    x: .value("Day", entry.day),
                    y: .value("Workouts", entry.count)
                )
                .foregroundStyle(.blue.gradient)
                .cornerRadius(6)
            }
            .frame(height: 120)
        }
        .padding(20)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Recent Activity

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Activity")
                .font(.headline)

            ForEach(loggedDays.prefix(3)) { day in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(day.routineDayName)
                            .font(.subheadline)
                        Text(day.date.formatted(.relative(presentation: .named)))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(day.isSkipped ? "Skipped" : "\(day.loggedExercises.count) exercise(s)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
                Divider()
            }
        }
    }

    // MARK: - Routines

    private var yourRoutines: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Routines")
                .font(.headline)

            ForEach(routines) { routine in
                HStack {
                    Text(routine.name)
                        .font(.subheadline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}
