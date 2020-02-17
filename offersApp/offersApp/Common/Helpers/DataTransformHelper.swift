//
//  DataTransformHelper.swift
//  offersApp
//
//  Created by Роман Плахов on 13.02.2020.
//  Copyright © 2020 Роман Плахов. All rights reserved.
//

import Foundation
import RSBarcodes_Swift
import AVFoundation

enum barCodeTypes: String {
	case code128 = "code128"
	case code39 = "code39"
}

class DataTransformHelper {
	static func generateBarcode(from contentString: String, type: String) -> UIImage? {
		switch (type) {
		case "code128":
			return RSCode128Generator(codeTable: .auto).generateCode(contentString, machineReadableCodeObjectType: AVMetadataObject.ObjectType.code128.rawValue)
		case "code39":
			return RSCode39Generator.generateCode(contentString, filterName: RSAbstractCodeGenerator.filterName(AVMetadataObject.ObjectType.code39.rawValue))
		default:
			return nil
		}
	}
	
	static func formattedEndTime(endDate: Date) -> String {
		let calendar = Calendar.current
		let formattedEndDate = "\(calendar.component(.day, from: endDate)) " + transformedMonthName(from: endDate) + " \(calendar.component(.year, from: endDate))"
		
		return "до \(formattedEndDate)"
	}
	
	static func formattedTimeInterval(beginDate: Date, endDate: Date) -> String {
		let calendar = Calendar.current
		let formattedBeginDate = "\(calendar.component(.day, from: beginDate)) " + transformedMonthName(from: beginDate) + (calendar.component(.year, from: beginDate) != calendar.component(.year, from: endDate) ? " \(calendar.component(.year, from: beginDate))" : "")
		
		return "с \(formattedBeginDate) \(formattedEndTime(endDate: endDate))"
	}
	
	static func timeRemaining(from endDate: Date) -> String {
		let calendar = Calendar.current
	
		let unit: Calendar.Component
		if endDate.timeIntervalSinceNow < 24 * 60 * 60 {
			unit = .hour
		} else {
			unit = .day
		}
		let components = calendar.dateComponents([unit], from: Date(), to: endDate)
		let units = unit == .day ? components.day! : components.hour!
		
		if units < 0 {
			return "акция окончена"
		}
		
		return (units % 10 == 1 && units % 100 != 11 ? "остался " : "осталось ") + "\(units) \(transformedTimeRemainingUnitName(from: endDate))"
	}
	
	static private func transformedMonthName(from date: Date) -> String {
		let calendar = Calendar.current
		
		switch calendar.component(.month, from: date) {
		case 1:
			return "января"
		case 2:
			return "февраля"
		case 3:
			return "марта"
		case 4:
			return "апреля"
		case 5:
			return "мая"
		case 6:
			return "июня"
		case 7:
			return "июля"
		case 8:
			return "августа"
		case 9:
			return "сентября"
		case 10:
			return "октября"
		case 11:
			 return "ноября"
		case 12:
			return "декабря"
		default:
			return ""
		}
	}
	
	static private func transformedTimeRemainingUnitName(from date: Date) -> String {
		let calendar = Calendar.current
	
		let unit: Calendar.Component
		if date.timeIntervalSinceNow < 24 * 60 * 60 {
			unit = .hour
		} else {
			unit = .day
		}
		
		let units = calendar.component(unit, from: date) - calendar.component(unit, from: Date())
		
		switch units % 10 {
		case 1 where units % 100 != 11:
			return unit == .hour ? "час" : "день"
		case 2...4 where !(12...14).contains(units % 100):
			return unit == .hour ? "часа" : "дня"
		default:
			return unit == .hour ? "часов" : "дней"
		}
	}
}
