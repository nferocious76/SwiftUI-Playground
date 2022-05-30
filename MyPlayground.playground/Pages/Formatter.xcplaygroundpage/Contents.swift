//: [Previous](@previous)

import Foundation

// MARK: - Date strings
// Reference: https://www.unicode.org/reports/tr35/tr35-dates.html#Date_Field_Symbol_Table
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

// MARK: - Measurements
// Reference: https://developer.apple.com/documentation/foundation/units_and_measurement
let measurementFormatter = MeasurementFormatter()
//measurementFormatter.unitOptions = .naturalScale
measurementFormatter.numberFormatter.maximumFractionDigits = 1

let temperatureCelcius = Measurement<UnitTemperature>(value: 21, unit: .celsius)
let temperatureFahrenheit = Measurement<UnitTemperature>(value: 21, unit: .fahrenheit)
measurementFormatter.string(from: temperatureCelcius)
measurementFormatter.string(from: temperatureFahrenheit)

let speed = Measurement<UnitSpeed>(value: 129, unit: .kilometersPerHour)
measurementFormatter.string(from: speed)

let pressure = Measurement<UnitPressure>(value: 1.34, unit: .bars)
measurementFormatter.string(from: pressure)

// MARK: - Name Formatter
let nameFormatter = PersonNameComponentsFormatter()
var nameComponents = PersonNameComponents()
nameComponents.familyName = "Hipona"
nameComponents.givenName = "Neil Francis"
nameComponents.middleName = "Ramirez"

// Full name
nameFormatter.style = .long
nameFormatter.string(from: nameComponents)

// First and Last name
nameFormatter.style = .medium
nameFormatter.string(from: nameComponents)

// First name
nameFormatter.style = .short
nameFormatter.string(from: nameComponents)

// Initials
nameFormatter.style = .abbreviated
nameFormatter.string(from: nameComponents)

// MARK: - Lists Formatter
ListFormatter.localizedString(byJoining: ["English, Japanese", "Spanish"])

// MARK: - Numbers
let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .percent
numberFormatter.maximumFractionDigits = 2
numberFormatter.decimalSeparator = "."
numberFormatter.string(from: 0.32940)

//: [Next](@next)
