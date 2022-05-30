//: [Previous](@previous)

import Foundation

// MARK: - Date strings
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .medium
dateFormatter.timeStyle = .short
dateFormatter.string(from: Date())

dateFormatter.setLocalizedDateFormatFromTemplate("EEEEMMMd")

// do not use as much as possible if you plan to localize the output. use a template.
//dateFormatter.dateFormat = "dMMM"

// use this format as much as possible
dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: .current)
dateFormatter.string(from: Date())

// MARK: - Date and Time components
let dateComponentsFormatter = DateComponentsFormatter()
dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
dateComponentsFormatter.zeroFormattingBehavior = .pad

dateComponentsFormatter.unitsStyle = .abbreviated
dateComponentsFormatter.string(from: 50)
dateComponentsFormatter.string(from: 131)

dateComponentsFormatter.unitsStyle = .positional
dateComponentsFormatter.string(from: 50)
dateComponentsFormatter.string(from: 131)

// MARK: - Date and Time Intervals
let startDate = Date()
let endDate = startDate.addingTimeInterval(200000)
let dateIntervalFormatter = DateIntervalFormatter()
dateIntervalFormatter.dateTemplate = "dMMM"
dateIntervalFormatter.string(from: startDate, to: endDate)

// MARK: - Relative Dates
let relativeDateFormatter = RelativeDateTimeFormatter()
relativeDateFormatter.dateTimeStyle = .named
relativeDateFormatter.localizedString(from: DateComponents(day: -13))

//: [Next](@next)
