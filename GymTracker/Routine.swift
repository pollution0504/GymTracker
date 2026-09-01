//
//  Routine.swift
//  GymTracker
//

import Foundation
import SwiftData

enum RoutineType: String, Codable {
    case ppl
    case arnold
    case custom
}

enum ScheduleType: String, Codable {
    case fixedWeekday
    case rotatingCycle
}

@Model
final class Routine {
    var name: String
    var type: RoutineType
    var days: [RoutineDay]
    var scheduleType: ScheduleType
    var cycleStartDate: Date
    var isMainRoutine: Bool

    init(name: String, type: RoutineType, days: [RoutineDay] = [], scheduleType: ScheduleType = .fixedWeekday, cycleStartDate: Date = Date(), isMainRoutine: Bool = false) {
        self.name = name
        self.type = type
        self.days = days
        self.scheduleType = scheduleType
        self.cycleStartDate = cycleStartDate
        self.isMainRoutine = isMainRoutine
    }
}
