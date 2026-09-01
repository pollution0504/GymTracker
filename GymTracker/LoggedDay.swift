//
//  LoggedDay.swift
//  GymTracker
//

import Foundation
import SwiftData

@Model
final class LoggedDay {
    var date: Date
    var routineDayName: String
    var loggedExercises: [LoggedExercise]
    var notes: String?
    var isSkipped: Bool

    init(date: Date, routineDayName: String, loggedExercises: [LoggedExercise] = [], notes: String? = nil, isSkipped: Bool = false) {
        self.date = date
        self.routineDayName = routineDayName
        self.loggedExercises = loggedExercises
        self.notes = notes
        self.isSkipped = isSkipped
    }
}
