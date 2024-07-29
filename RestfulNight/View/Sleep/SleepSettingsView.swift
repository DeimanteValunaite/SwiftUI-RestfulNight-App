//
//  SleepSettingsView.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 07/07/2024.
//

import CoreML
import SwiftUI

struct SleepSettingsView: View {
    @ObservedObject var sleepingViewModel = SleepSettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $sleepingViewModel.wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepingViewModel.sleepAmount.formatted()) hours", value: $sleepingViewModel.sleepAmount, in: 4...12, step: 0.25)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper("^[\(sleepingViewModel.coffeeAmount) cup](inflect: true)", value: $sleepingViewModel.coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("Best Sleeping Time")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button("Calculate", action: sleepingViewModel.calculateBedTime)
            }
            .alert(sleepingViewModel.alertTitle, isPresented: $sleepingViewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(sleepingViewModel.alertMessage)
            }
        }
    }
}

#Preview {
    SleepSettingsView()
}
