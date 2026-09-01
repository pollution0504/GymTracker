//
//  HomeStats.swift
//  GymTracker
//

import Foundation

enum HomeStats {
    static func workoutsThisWeek(_ loggedDays: [LoggedDay]) -> Int {
        let calendar = Calendar.current
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return 0
        }
        return loggedDays.filter { $0.date >= weekStart }.count
    }

    static func currentStreak(_ loggedDays: [LoggedDay]) -> Int {
        let calendar = Calendar.current
        let sortedDates = loggedDays
            .map { calendar.startOfDay(for: $0.date) }
            .sorted(by: >)

        guard !sortedDates.isEmpty else { return 0 }

        var streak = 0
        var expectedDay = calendar.startOfDay(for: Date())

        // Allow the streak to still count if today hasn't been logged yet,
        // as long as yesterday was logged.
        if sortedDates.first != expectedDay {
            expectedDay = calendar.date(byAdding: .day, value: -1, to: expectedDay) ?? expectedDay
        }

        for date in Set(sortedDates).sorted(by: >) {
            if date == expectedDay {
                streak += 1
                expectedDay = calendar.date(byAdding: .day, value: -1, to: expectedDay) ?? expectedDay
            } else if date < expectedDay {
                break
            }
        }

        return streak
    }
}
