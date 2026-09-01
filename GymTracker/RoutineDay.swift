//
//  RoutineDay.swift
//  GymTracker
//

import Foundation
import SwiftData

@Model
final class RoutineDay {
    var name: String
    var plannedExercises: [ExerciseTemplate]
    var daysOfWeek: [Int] // used when the routine's scheduleType is .fixedWeekday. 1 = Sunday ... 7 = Saturday
    var order: Int // used when the routine's scheduleType is .rotatingCycle. 0-based position in the cycle
    var isRestDay: Bool

    init(name: String, plannedExercises: [ExerciseTemplate] = [], daysOfWeek: [Int] = [], order: Int = 0, isRestDay: Bool = false) {
        self.name = name
        self.plannedExercises = plannedExercises
        self.daysOfWeek = daysOfWeek
        self.order = order
        self.isRestDay = isRestDay
    }
}
