//
//  HomeViewModel.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 11/07/2024.
//

import Combine
import SwiftUI
import UserNotifications

enum TimeView: String, CaseIterable {
    case day, week, month
}

struct SleepData: Identifiable {
    let id = UUID()
    let date: Date
    let sleepDuration: Double
}

class HomeViewModel: ObservableObject {
    @Published var startAngle: Double = 0
    @Published var toAngle: Double = 180
    @Published var startProgress: CGFloat = 0
    @Published var toProgress: CGFloat = 0.5
    
    @Published var selectedDays: Set<String> = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    @Published var isReminderEnabled: Bool = false {
        didSet {
            if isReminderEnabled {
                scheduleNotification()
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        }
    }
    
    let daysOfWeek: [(id: String, initial: String)] = [
        ("Mon", "M"), ("Tue", "T"), ("Wed", "W"), ("Thu", "T"), ("Fri", "F"), ("Sat", "S"), ("Sun", "S")
    ]
    
    @Published var sleepData: [SleepData] = []
    @Published var filteredSleepData: [SleepData] = []
    @Published var timeView: TimeView = .week
    
    init() {
        generateSampleSleepData()
        filterSleepData()
    }
    
    
    private func scheduleNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        for day in selectedDays {
            let content = UNMutableNotificationContent()
            content.title = "RestfulNight"
            content.subtitle = "Time to sleep at \(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))"
            content.sound = UNNotificationSound.default
            
            let components = getDateComponents(for: day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled successfully for \(day).")
                }
            }
        }
    }
    
    private func getDateComponents(for day: String) -> DateComponents {
        var components = DateComponents()
        let startDate = getTime(angle: startAngle)
        let calendar = Calendar.current
        let notificationDate = calendar.date(byAdding: .minute, value: -30, to: startDate) ?? startDate
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notificationDate)
        components.hour = dateComponents.hour
        components.minute = dateComponents.minute
        components.second = 0
        
        switch day {
        case "Sun": components.weekday = 1
        case "Mon": components.weekday = 2
        case "Tue": components.weekday = 3
        case "Wed": components.weekday = 4
        case "Thu": components.weekday = 5
        case "Fri": components.weekday = 6
        case "Sat": components.weekday = 7
        default: break
        }
        
        return components
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        let progress = angle / 360
        if fromSlider {
            self.startAngle = angle
            self.startProgress = progress
        } else {
            self.toAngle = angle
            self.toProgress = progress
        }
    }
    
    func getTime(angle: Double) -> Date {
        let progress = angle / 15
        let hour = Int(progress)
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        var minute = remainder * 5
        minute = (minute > 55 ? 55 : minute)
        
        var components = DateComponents()
        components.hour = hour == 24 ? 0 : hour
        components.minute = Int(minute)
        components.second = 0
        
        let calendar = Calendar.current
        let currentDate = Date()
        let currentDay = calendar.component(.day, from: currentDate)
        
        let isPastMidnight = (startAngle > toAngle) && (angle == toAngle)
        components.day = currentDay + (isPastMidnight ? 1 : 0)
        
        components.year = calendar.component(.year, from: currentDate)
        components.month = calendar.component(.month, from: currentDate)
        
        return calendar.date(from: components) ?? Date()
    }
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        let result = calendar.dateComponents([.hour, .minute], from: getTime(angle: startAngle), to: getTime(angle: toAngle))
        return (result.hour ?? 0, result.minute ?? 0)
    }
    
    private func generateSampleSleepData() {
        sleepData = [
            SleepData(date: Date().addingTimeInterval(-86400 * 6), sleepDuration: 7.0),
            SleepData(date: Date().addingTimeInterval(-86400 * 5), sleepDuration: 6.5),
            SleepData(date: Date().addingTimeInterval(-86400 * 4), sleepDuration: 8.0),
            SleepData(date: Date().addingTimeInterval(-86400 * 3), sleepDuration: 7.5),
            SleepData(date: Date().addingTimeInterval(-86400 * 2), sleepDuration: 6.0),
            SleepData(date: Date().addingTimeInterval(-86400), sleepDuration: 7.2),
            SleepData(date: Date(), sleepDuration: 8.0)
        ]
    }
    
    func filterSleepData() {
        let calendar = Calendar.current
        let now = Date()
        
        switch timeView {
        case .day:
            filteredSleepData = sleepData.filter {
                calendar.isDate($0.date, inSameDayAs: now)
            }
        case .week:
            if let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) {
                filteredSleepData = sleepData.filter {
                    $0.date >= weekAgo && $0.date <= now
                }
            }
        case .month:
            if let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) {
                filteredSleepData = sleepData.filter {
                    $0.date >= monthAgo && $0.date <= now
                }
            }
        }
    }
}
