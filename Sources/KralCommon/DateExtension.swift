//
//  DateExtension.swift
//  KralCommons
//
//  Created by LiKai on 2022/5/20.
//  
//

import Foundation
import KralObjc

extension Date {
    
    /// 系统时区的当前时间
    public static var nowLocalTime: Date {
        get {
            return Date().nowTimeZoneDate
        }
    }
    
    /// 系统时区的时间
    public var nowTimeZoneDate: Date {
        get {
            let timezone = TimeZone.current
            let timeInterval = timezone.secondsFromGMT()
            let result = addingTimeInterval(TimeInterval(timeInterval))
            return result
        }
    }
    
    /// 0 时区时间
    public var gmtTimeZoneDate: Date {
        get {
            let timezone = TimeZone.current
            let timeInterval = timezone.secondsFromGMT()
            let result = addingTimeInterval(-TimeInterval(timeInterval))
            return result
        }
    }
}

extension Date {
    
    /// 使用 c 语言的方法来转换 date 到字符串，这里的 formatter 的格式为 c 的格式
    /// 详细格式文档：https://zetcode.com/articles/cdatetime/
    ///
    /// @param formatter "%Y-%m-%d %H:%M:%S"
    public func hbString(formatter: String) -> String {
        return HBDate.string(from: self, formatter: formatter)
    }
    
    /// 12:23 分秒类型的字符串
    /// 在这里，认为 self 是当前时区的时间
    /// 这里所有的 formatter 使用的是 c 语言的
    /// "%Y-%m-%d %H:%M:%S"
    public var hmString: String {
        get {
           return hbString(formatter: "%H:%M")
        }
    }
    
    /// 2018-08-08 08:08:08
    /// 在这里，认为 self 是当前时区的时间
    public var timeString: String {
        get {
            return hbString(formatter: "%Y-%m-%d %H:%M:%S")
        }
    }
    
    /// 2018-08-08
    public var ymdString: String {
        get {
            return hbString(formatter: "%Y-%m-%d")
        }
    }
    
    /// 2018-08-08
    public var myString: String {
        get {
            return hbString(formatter: "%m.%Y")
        }
    }
    
    /// 年
    /// 在这里，认为 self 是当前时区的时间
    public var year: Int {
        get {
            return hbString(formatter: "%Y").int
        }
    }
    
    /// 月
    /// 在这里，认为 self 是当前时区的时间
    public var month: Int {
        get {
            return hbString(formatter: "%m").int
        }
    }
    
    /// 年月 Int 值，例如 201808
    public var yearMonthInt: Int {
        get {
            return hbString(formatter: "%Y%m").int
        }
    }
    
    /// 日  01 、 02 、12
    /// 在这里，认为 self 是当前时区的时间
    public var day: Int {
        get {
            return hbString(formatter: "%d").int
        }
    }
    
    /// 单个日   1、 2、 12
    /// 在这里，认为 self 是当前时区的时间
    public var singleDay: Int {
        get {
            return  hbString(formatter: "%d").int
        }
    }
    
    /// 小时
    /// 在这里，认为 self 是当前时区的时间
    public var hour: Int {
        get {
            return  hbString(formatter: "%H").int
        }
    }
    
    /// 分钟
    /// 在这里，认为 self 是当前时区的时间
    public var min: Int {
        get {
            return hbString(formatter: "%M").int
        }
    }
    
    /// 秒
    /// 在这里，认为 self 是当前时区的时间
    public var second: Int {
        get {
            return hbString(formatter: "%S").int
        }
    }
    
    /// DateFormatter 的方式来转换时间，已经创建了一个默认的 dateformatter 对象保存在线程里
    public func string(formatter: String) -> String {
        return DateFormatter.default(formatter).string(from: self)
    }
    
    /// 月日：August 3
    /// 在这里，认为 self 是当前时区的时间
    public var monthDay: String {
        get {
            return string(formatter: "MMMM d")
        }
    }
    
    /// 月：August
    public var monthString: String {
        get {
            return string(formatter: "MMMM")
        }
    }
    
    /// 月（简写）：Aug
    public var simpleMonthString: String {
        get {
            return string(formatter: "MMM")
        }
    }
    
    /// 所在周的第一天到最后一天
    /// 例如：08.12-08.18    
    public func thisWeekDurationString(startOfWeek: Weekday = .monday) -> String {
        let firstDay = weekDates(startOfWeek: startOfWeek).first!
        let lastDay = weekDates(startOfWeek: startOfWeek).last!
        
        return "\(firstDay.simpleMonthDay)~\(lastDay.simpleMonthDay)"
    }
    
    /// 简写月日：08.3
    /// 在这里，认为 self 是当前时区的时间
    public var simpleMonthDay: String {
        get {
            return hbString(formatter: "%m.%d")
        }
    }
    
    /// 年月：2018-08
    /// 在这里，认为 self 是当前时区的时间
    public var yearMonth: String {
        get {
            return hbString(formatter: "%Y-%m")
        }
    }
    
    /// 这个时间的这一分钟的开始，即第 0 秒
    public var minuteStart: Date {
        get {
            return HBDate.date(from: "\(year)-\(month)-\(day) \(hour):\(min):\(00)")
        }
    }
    
    /// 某个日期的开始，即当天的 00:00:01
    /// 在这里，认为 self 是当前时区的时间
    public var startOfDate: Date {
        get {
            var selfString = hbString(formatter: "%Y-%m-%d")
            selfString += " 00:00:00"
            
            let resultDate = HBDate.date(from: selfString)
            
            return resultDate
        }
    }
    
    /// 某个日期的正午，即当天的 12:00:00
    /// 在这里，认为 self 是当前时区的时间
    public var middleOfDate: Date {
        get {
            var selfString = hbString(formatter: "%Y-%m-%d")
            selfString += " 12:00:00"
            
            let resultDate = HBDate.date(from: selfString)
            
            return resultDate
        }
    }
    
    /// 某个日期的结尾，即当天的 23:59:59
    /// 在这里，认为 self 是当前时区的时间
    public var endOfDate: Date {
        get {
            var selfString = hbString(formatter: "%Y-%m-%d")
            selfString += " 23:59:59"
            
            let resultDate = HBDate.date(from: selfString)
            
            return resultDate
        }
    }
    
    /// 下个月的今天
    public var nextMonth: Date {
        get {
            return monthAfterMonths(1)
        }
    }
    
    /// 上个月的今天
    public var lastMonth: Date {
        get {
            return monthAfterMonths(-1)
        }
    }
    
    /// 去年的今天
    public var lastYear: Date {
        get {
            return monthAfterMonths(-12)
        }
    }
    
    /// 当前日期月份的下几个月，上几个月的话 months 为负即可
    /// 如果今天是 31 号，而目标月没有 31 天，那么将会变成目标月最后一天
    /// 在这里，认为 self 是当前时区的时间，返回的也是当前时区的时间
    ///
    /// - Parameter months: 几个月份
    /// - Returns: 日期
    public func monthAfterMonths(_ months: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let datecomps = DateComponents(month: months)
        
        return calendar.date(byAdding: datecomps, to: self)!
    }
    
    /// 下周
    public var nextWeek: Date {
        get {
            return self.dateAfterDays(7)
        }
    }
    
    /// 当前日期所在周的下几个周，上几个周的话 weeks 为负即可
    ///
    /// - Parameter weeks: 几个周
    /// - Returns: 日期
    public func weekDateAfterWeeks(_ weeks: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let datecomps = DateComponents(weekOfYear: weeks)
        
        return calendar.date(byAdding: datecomps, to: self)!
    }
    
    /// 当月的第一天
    public var firstDayAtMonth: Date {
        get {
            return Date.firstDayOfYear(year, month: month)
        }
    }
    
    /// 当月的最后一天
    public var endDayAtMonth: Date {
        get {
            return Date.endDayOfYear(year, month: month)
        }
    }
    
    /// 本周第一天
    public func firstDayThisWeek(startOfWeek: Weekday = .monday) -> Date {
        return weekDates(startOfWeek: startOfWeek).first!
    }
    
    /// 本周最后一天
    public func lastDayThisWeek(startOfWeek: Weekday = .monday) -> Date {
        return weekDates(startOfWeek: startOfWeek).last!
    }
    
    /// 当前日期的同一周的所有日期
    /// - Parameter startOfWeek: 周的开始时间
    /// - Returns: 所有本周的七个日期
    public func weekDates(startOfWeek: Weekday = .monday) -> [Date] {
        var result: [Date] = [Date]()
        
        for i in -7..<7 {
            let date = dateAfterDays(i)
            if isSameWeekTo(date, startWeekDay: startOfWeek) {
                result.append(date)
            }
        }
        
        return result.sorted(by: { (date1, date2) -> Bool in
            return date1.daysFromStart < date2.daysFromStart
        })
    }
    
    /// 过去七天
    public var last7Dates: [Date] {
        get {
            var result: [Date] = [Date]()
            
            for i in -6..<1 {
                let date = dateAfterDays(i)
                result.append(date)
            }
            
            return result
        }
    }
    
    /// 当前日期的同一个月的所有日期
    public var monthDates: [Date] {
        get {
            var result: [Date] = [Date]()
            
            for i in -31..<31 {
                let date = dateAfterDays(i)
                if date.month == month {
                    result.append(date)
                }
            }
            
            return result
        }
    }
    
    /// 当前日期所在年的每月的这一天
    public var thisYearMonthFirstDates: [Date] {
        get {
            var result: [Date] = [Date]()
            
            for i in -12..<12 {
                let date = monthAfterMonths(i)
                if date.year == year {
                    result.append(date.firstDayAtMonth)
                }
            }
            
            return result
        }
    }
    
    /// 本年所有日期
    public var thisYearDates: [Date] {
        get {
            let year = self.year
            let results = Date.datesAtYear(year)
            
            return results
        }
    }
    
    /// 获取某一年的所有日期，时间均为当天的 00:00:00
    ///
    /// - Parameter year: 年
    /// - Returns: 日期
    public static func datesAtYear(_ year: Int) -> [Date] {
        let firstDay = "\(year)-01-01 00:00:00"
        let firstDate = HBDate.date(from: firstDay)
        
        var results: [Date] = [Date]()
        
        for i in 0..<370 {
            let date = firstDate.dateAfterDays(i)
            if date.year == year {
                results.append(date)
            }
        }
        
        return results
    }
    
    /// 过去 365 天每一天的日期
    public var past365Days: [Date] {
        get {
            let firstDate = self
            
            var results: [Date] = [Date]()
            
            for i in 0..<365 {
                let date = firstDate.dateAfterDays(i-364)
                results.append(date)
            }
            
            return results
        }
    }
    
    /// 当前日期到某一个日期中间所有的日期，包括这两个日期
    ///
    /// - Parameter date: 目标日期
    /// - Returns: 所有日期
    public func datesToDate(_ date: Date) -> [Date] {
        var startDate = self
        var endDate = date
        
        if endDate < startDate {
            startDate = date
            endDate = self
        }
        
        let numberOfDates = endDate.daysFromStart - startDate.daysFromStart + 1
        
        var dates: [Date] = [Date]()
        for i in 0..<numberOfDates {
            let newDate = dateAfterDays(i)
            dates.append(newDate)
        }
        
        return dates
    }
    
    /// 是否是今天
    public var isToday: Bool {
        get {
            return isSameDayTo(Date.nowLocalTime)
        }
    }
    
    /// 是否是昨天
    public var isYesterday: Bool {
        get {
            return isSameDayTo(Date.nowLocalTime.dateAfterDays(-1))
        }
    }
    
    /// 是否和某一天是同一个月
    public func isSameMonthTo(_ date: Date) -> Bool {
        return yearMonth == date.yearMonth
    }
    
    /// 是否和某天是同一周
    public func isSameWeekTo(_ date: Date, startWeekDay: Weekday = .monday) -> Bool {
        return weeksFromStart(startDayOfWeek: startWeekDay) == date.weeksFromStart(startDayOfWeek: startWeekDay)
    }
    
    /// 是否和某一天是同一天
    public func isSameDayTo(_ date: Date) -> Bool {
        return daysFromStart == date.daysFromStart
    }
    
    /// 是否是某一天之后，包括同一天
    public func isAfter(_ date: Date, includeDate: Bool = true) -> Bool {
        let selfTimerinteval = Int(timeIntervalSince1970 / (24*3600))
        let dateTimeInterval = Int(date.timeIntervalSince1970 / (24*3600))
        
        if includeDate {
            return selfTimerinteval >= dateTimeInterval
        } else {
            return selfTimerinteval > dateTimeInterval
        }
    }
    
    /// 是否是某一天之前，包括同一天
    public func isBefore(_ date: Date, includeDate: Bool = true) -> Bool {
        let selfTimerinteval = Int(timeIntervalSince1970 / (24*3600))
        let dateTimeInterval = Int(date.timeIntervalSince1970 / (24*3600))
        
        if includeDate {
            return selfTimerinteval <= dateTimeInterval
        } else {
            return selfTimerinteval < dateTimeInterval
        }
    }
    
    /// 将秒数转换为 1h1m1s 的字符串
    /// 这里有些情况会缺省显示：
    /// 0h0m0s -> 0
    /// 0h0m1s -> 1s
    /// 0h1m0s -> 1m
    /// 0h1m1s -> 1m1s
    /// 1h0m0s -> 1h
    /// 1h0m1s -> 1h0m1s
    /// 1h1m0s -> 1h1m
    /// 1h1m1s -> 1h1m1s
    ///
    /// - Parameter allSeconds: 总秒数
    /// - Returns: 格式化后的文字
    public static func secondsToHMS(_ totalSeconds: Int) -> String {
        if totalSeconds == 0 { return "0" }
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        
        var content: String = ""
        if hours > 0 {
            content += "\(hours) " + "时"
        }
        if minutes > 0 {
            content += " \(minutes) " + "分"
        } else if minutes == 0 {
            if hours > 0 && seconds > 0 {
                content += " \(minutes) " + "分"
            }
        }
        if seconds > 0 {
            content += " \(seconds) " + "秒"
        } else if seconds == 0 {
            if hours == 0 && minutes == 0 {
                content += " \(seconds) " + "秒"
            }
        }
        
        return content
    }
    
    /// 将秒数转为 1h1m 的字符串
    /// 规则为：
    ///
    /// 当小时数为 0，显示：2 m 2 s
    /// 当小时数为 1-100, 显示 99 h 2 m
    /// 当小时数大于 100，显示 7 d
    ///
    /// - Parameter totalSeconds: 总秒数
    /// - Returns: 格式化后的文字
    public static func secondsToSimpleHMS(_ totalSeconds: Int) -> String {
        if totalSeconds == 0 { return "0" }
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = (totalSeconds / 3600)
        let daysHours: Int = (totalSeconds / 3600) % 24
        let days: Int = (totalSeconds / (3600 * 24))
        
        var content: String = ""

        if hours <= 0 {
            if minutes > 0 {
                content += "\(minutes) " + "分"
            } else if minutes == 0 {
                if hours > 0 && seconds > 0 {
                    content += "\(minutes) " + "分"
                }
            }
            if seconds > 0 {
                content += " \(seconds) " + "秒"
            } else if seconds == 0 {
                if hours == 0 && minutes == 0 {
                    content += " \(seconds) " + "秒"
                }
            }
        } else if hours <= 100 {
            if hours > 0 {
                content += "\(hours) " + "时"
            }
            if minutes > 0 {
                content += " \(minutes) " + "分"
            } else if minutes == 0 {
                if hours > 0 && seconds > 0 {
                    content += " \(minutes) " + "分"
                }
            }
        } else {
            if days > 0 {
                content += "\(days) " + "天"
            }
            if hours > 0 {
                content += " \(daysHours) " + "时"
            }
        }
        
        
        return content
    }
    
    /// 将秒数转换为格式如 12:10:01 的字符串
    ///
    /// - Parameter allSeconds: 总秒数
    /// - Returns: 格式化后的文字
    public static func secondsToClock(_ totalSeconds: Int) -> String {
        if totalSeconds <= 0 {
            return "00:00"
        }
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        
        var content: String = ""
        if hours > 0 {
            if hours < 10 {
                content += "0"
            }
            content += "\(hours):"
        }
        if minutes >= 0 || hours > 0 {
            if minutes < 10 {
                content += "0"
            }
            content += "\(minutes):"
        }
        
        if seconds < 10 {
            content += "0"
        }
        content += "\(seconds)"
        
        return content
    }
    
    /// 这个月有几天
    /// 在这里，认为 self 是当前时区的时间
    ///
    /// - Returns: 天数
    public func numberOfDaysInThisMonth() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        if let range = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self) {
            return range.count
        }
        return 0
    }
}

/// MARK: - 时间差计算
/// 这里使用了一个基准时间：startDate，主要是为了避免时区带来的天、周、月数量计算差
/// 所有的计算，都是在 startDate 的基础上计算，然后再算差值，保证数据正确
extension Date {
    
    /// 周一到周日
    public enum Weekday: Int {
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        case sunday = 1
    }
    
    /// 基准时间
    fileprivate var startDate: Date {
        get {
            return ninteenSeventyYearFebOne
        }
    }
    
    /// 1970 年 2 月 1 号，周日，用来记录从周日开始的周，刚好也是 2 月的第一天
    fileprivate var ninteenSeventyYearFebOne: Date {
        get {
            return Date(timeIntervalSince1970: 0).dateAfterDays(31)
        }
    }
    
    /// 这几个天、周、月的对比，都要从当天的最后一秒来对比
    /// 因为切换成 0 时区的时间后，因为时差问题可能导致两个时间本来是一天后来不是一天，这样计算下来的 天、周、月 的数量就不对了
    /// 从开始的日期到现在的第几天
    fileprivate var daysFromStart: Int {
        get {
            let days = Int(timeIntervalSince1970 / (24*3600))
            return days
        }
    }
    
    /// 从开始时间到现在过去了多少周
    /// - Parameter startDayOfWeek: 每周以周几为开始的
    /// - Returns:
    fileprivate func weeksFromStart(startDayOfWeek: Weekday = .monday) -> Int {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [Calendar.Component.weekOfYear]
        let resultComponents = calendar.dateComponents(components, from: startDate.dateAfterDays(7 - startDayOfWeek.rawValue), to: startOfDate)
        
        return resultComponents.weekOfYear ?? 0
    }
    
    /// 当前日期为周几
    public var weekDay: Weekday {
        get {
            let calendar = Calendar.current
            let components: Set<Calendar.Component> = [Calendar.Component.weekday]
            let resultComponents = calendar.dateComponents(components, from: endOfDate.gmtTimeZoneDate)
            let result = resultComponents.weekday!
            
            return Weekday(rawValue: result) ?? .monday
        }
    }
 
    /// 某天的后几天，也可以是前几天，days 为负即可
    ///
    /// - Parameter days: 天数
    /// - Returns: 时间
    public func dateAfterDays(_ days: Int) -> Date {
        let oneDay: TimeInterval = (24*60*60)
        return Date(timeInterval: oneDay, since: self)
    }
    
    /// 前面多少周的日期，每一周一个日期
    ///
    /// - Parameters:
    ///   - number: 多少周
    ///   - ownSelf: 是否包含当前日期
    /// - Returns: 结果
    public func lastNumberOfWeekDates(_ number: Int, ownSelf: Bool = false) -> [Date] {
        var result: [Date] = [Date]()
        let max = ownSelf ? number : number + 1
        for i in 1..<max {
            let index = max - i
            let lastNWeekDate = self.weekDateAfterWeeks(-index)
            result.append(lastNWeekDate)
        }
        
        if ownSelf {
            result.append(self)
        }
        
        return result
    }
    
    /// 前面多少个月的每月日期
    ///
    /// - Parameters:
    ///   - number: 多少个月
    ///   - ownSelf: 是否包含当前日期
    /// - Returns: 结果
    public func lastNumberOfMonthDates(_ number: Int, ownSelf: Bool = false) -> [Date] {
        var result: [Date] = [Date]()
        let max = ownSelf ? number : number + 1
        for i in 1..<max {
            let index = max - i
            let lastNMonthsDate = self.monthAfterMonths(-index)
            result.append(lastNMonthsDate)
        }
        
        if ownSelf {
            result.append(self)
        }
        
        return result
    }
    
    /// 某年某月的第一天
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 日期
    public static func firstDayOfYear(_ year: Int, month: Int) -> Date {
        let dateString = "\(year)-\(month)-01 00:00:00"
        let resultDate = HBDate.date(from: dateString)
        return resultDate
    }
    
    /// 某年某月的最后一天
    ///
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 日期
    public static func endDayOfYear(_ year: Int, month: Int) -> Date {
        let firstDay = firstDayOfYear(year, month: month)
        let numberOfDays = firstDay.numberOfDaysInThisMonth()
        let dateString = "\(year)-\(month)-\(numberOfDays) 00:00:00"
        let resultDate = HBDate.date(from: dateString)
        return resultDate
    }
    
    /// 从自己到目标时间过去了多少天：包括自己和目标时间，每个日期算一天
    ///
    /// - Parameter toDate: 目标日期
    /// - Returns: 天数
    public func passedDays(toDate: Date = Date.nowLocalTime) -> Int {
        return toDate.daysFromStart  - daysFromStart + 1
    }
    
}

extension Array where Element == Date {
    
    public func hasSameDay(_ date: Date) -> Bool {
        for existDate in self {
            if existDate.daysFromStart == date.daysFromStart {
                return true
            }
        }
        
        return false
    }
    
    
}
