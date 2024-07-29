//
//  SettingsViewModel.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 11/07/2024.
//

import SwiftUI
import UserNotifications

class SettingsViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var isNotificationsEnabled = false {
        didSet {
            if isNotificationsEnabled {
                enableNotifications()
            }
        }
    }
    
    private func enableNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error {
                print(error.localizedDescription)
            }
        }
    }
}
