//: Playground - noun: a place where people can play

import UIKit

let startDate = Date()


var dateFormatter = DateFormatter()

dateFormatter.locale = Locale(identifier: "en_US")
dateFormatter.dateStyle = .long
dateFormatter.timeStyle = .full

let dateString = dateFormatter.string(from: startDate)

let returnDate = dateFormatter.date(from: dateString)

