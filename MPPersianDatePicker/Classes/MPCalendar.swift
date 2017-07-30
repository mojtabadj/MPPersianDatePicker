//
//  MPCalendar.swift
//  MPCalendarSwift
//
//  Created by Ali on 4/11/17.
//  Copyright © 2017 Ali Azadeh. All rights reserved.
//

import Foundation
public class MPCalendar {
    
    
   public static func getCurrentGregorianDate() -> DateType{
        
        let miladiDay = MPGregorianCalendar.getGregorianDayNumber()
        let miladiMonth = MPGregorianCalendar.getGregorianMonthNumber()
        let miladiYear = MPGregorianCalendar.getGregorianYearNumber()
        
        return DateType.init(day: miladiDay, month: miladiMonth, year: miladiYear)
        
    }
   public static func getCurrentPersianDate() -> DateType{
        
        let persianDay = MPPersianCalendar.getPersianDayNumber()
        let persianMonth = MPPersianCalendar.getPersianMonthNumber()
        let persianYear = MPPersianCalendar.getPersianYearNumber()
        
        return DateType.init(day: persianDay, month: persianMonth, year: persianYear)
    }
  public  static func getCurrentHijriDate() -> DateType {
    
    let hijriDay = MPHijriCalendar.getHijriDayNumber()
    let hijriMonth = MPHijriCalendar.getHijriMonthNumber()
    let hijriYear = MPHijriCalendar.getHijriYearNumber()
    
    return DateType.init(day: hijriDay, month: hijriMonth, year: hijriYear)
    
    }
    
    public static func  convertDate(inputType : CalendarType , inputDate : DateType , outputType : CalendarType)->DateType {
    
        let result = MPConvertorCalendar.convertDate(inputType: inputType, inputDate: inputDate, outputType: outputType)
        return result
    }
    
    public static func getDayIndex (date : DateType , calendar : CalendarType) -> Int {
    var result = 0

        var type = Calendar.Identifier.persian
        

        
        switch calendar {
        case .persian:
            type = .persian
            break
        case .gregorian :
            type = .gregorian
            break
        case .hijri :
            type = .islamicCivil
            break
        }
        
      
        
        let myCal = Calendar.init(identifier: type)
        
        
        var component = DateComponents.init()
        component.day = date.day
         component.month = date.month
         component.year = date.year
        
       let formatter = DateFormatter.init()
        formatter.dateFormat = "EEE"
        
        
       
        
        let myDate = myCal.date(from: component)
        
       
        switch formatter.string(from: myDate!) {
        case "Sun":
            result = 0
            break
        case "Mon":
            result = 1
            break
        case "Tue":
            result = 2
            break
        case "Wed":
            result = 3
            break
        case "Thu":
            result = 4
            break
        case "Fri":
            result = 5
            break
        case "Sat":
            result = 6
            break
        default:
            break
        }
        
        
        
    return result
    }
    
    public static func getDayName (calendar : CalendarType , date : DateType) -> String {
        var result = "Oops :|"
        var type = Calendar.Identifier.persian
        
        switch calendar {
        case .persian:
            type = .persian
            break
        case .gregorian :
            type = .gregorian
            break
        case .hijri :
            type = .islamicCivil
            break
        }
        
      
        
        let myCal = Calendar.init(identifier: type)
        
        
        var component = DateComponents.init()
        component.day = date.day
        component.month = date.month
        component.year = date.year
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "EEE"
            let myDate = myCal.date(from: component)
        result = formatter.string(from: myDate!)
        return result
    }
    
    /*public static func getMonthName (calendar : CalendarType , date : DateType) -> String{
        
       
       return MPMonthName.getMonthName(calendar: calendar, date: date)
        
        
       }*/
    
    
}
