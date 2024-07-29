//
//  SleepSettingsViewModel.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 22/07/2024.
//

import CoreML
import Foundation

class SleepSettingsViewModel: ObservableObject {
    @Published var wakeUp = defaultWakeTime
    @Published var sleepAmount = 8.0
    @Published var coffeeAmount = 1
    
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var showingAlert: Bool = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}
