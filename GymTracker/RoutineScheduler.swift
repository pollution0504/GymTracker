//
//  RoutineScheduler.swift
//  GymTracker
//

import Foundation

enum RoutineScheduler {
    static func todaysDay(for routine: Routine, on date: Date = Date()) -> RoutineDay? {
        switch routine.scheduleType {
        case .fixedWeekday:
            let weekday = Calendar.current.component(.weekday, from: date)
            return routine.days.first { $0.daysOfWeek.contains(weekday) }

        case .rotatingCycle:
            guard !routine.days.isEmpty else { return nil }
            let calendar = Calendar.current
            let startDay = calendar.startOfDay(for: routine.cycleStartDate)
            let today = calendar.startOfDay(for: date)
            let daysSinceStart = calendar.dateComponents([.day], from: startDay, to: today).day ?? 0
            let cycleLength = routine.days.count
            let position = ((daysSinceStart % cycleLength) + cycleLength) % cycleLength
            return routine.days.first { $0.order == position }
        }
    }

    static func todaysDay(across routines: [Routine], on date: Date = Date()) -> RoutineDay? {
        let ordered = routines.sorted { $0.isMainRoutine && !$1.isMainRoutine }
        for routine in ordered {
            if let day = todaysDay(for: routine, on: date) {
                return day
            }
        }
        return nil
    }
}
