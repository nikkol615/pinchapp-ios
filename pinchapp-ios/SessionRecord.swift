import Foundation
import SwiftData

@Model
final class SessionRecord {
    var date: Date
    var teaName: String
    var steepCount: Int

    init(date: Date = .now, teaName: String, steepCount: Int) {
        self.date = date
        self.teaName = teaName
        self.steepCount = steepCount
    }

    var relativeDate: String {
        let cal = Calendar.current
        let time = date.formatted(date: .omitted, time: .shortened)
        if cal.isDateInToday(date)     { return "Сегодня, \(time)" }
        if cal.isDateInYesterday(date) { return "Вчера, \(time)" }
        return date.formatted(.dateTime.day().month(.abbreviated).hour().minute())
    }

    // Correct Russian plural for "пролив"
    var steepLabel: String {
        let n = steepCount
        let lastTwo = n % 100
        let last    = n % 10
        if lastTwo >= 11 && lastTwo <= 19 { return "\(n) проливов" }
        switch last {
        case 1:       return "\(n) пролив"
        case 2, 3, 4: return "\(n) пролива"
        default:      return "\(n) проливов"
        }
    }
}
