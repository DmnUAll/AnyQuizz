import Foundation

extension DateFormatter {

    static let dateTimeDefaultFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY hh:mm"
        return dateFormatter
    }()
}
