import Foundation

extension Date {
    var dateTimeString: String { DateFormatter.dateTimeDefaultFormatter.string(from: self) }
}
