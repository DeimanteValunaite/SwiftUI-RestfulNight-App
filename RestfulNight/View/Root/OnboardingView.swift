//
//  OnboardingView.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 07/07/2024.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("isBoarding") var isOnBoarding: Bool = true
    
    var body: some View {
        if isOnBoarding {
            NavigationStack {
                TabView {
                    VStack() {
                        Image("Logo design")
                            .resizable()
                            .scaledToFit()
                        
                        VStack(spacing: 15) {
                            Text("Track Your Sleep Pattern and Improve it")
                                .font(.largeTitle)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                            Text("Get insights into your sleep habits and wake up refreshed with Zzz Track")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)
                                .padding(.bottom)
                            
                            Button("Get Started") {
                                isOnBoarding.toggle()
                            }
                            .padding()
                            .frame(width: 384, height: 55)
                            .cornerRadius(20)
                            .font(.title2)
                            .background(Color.primary)
                            .foregroundColor(.white)
                            .frame(width: 325, height: 55)
                            .cornerRadius(10)
                            
                            VStack{
                                Text("By continuing, you agree to RestfulNight's " + "\n") +
                                Text("Terms of Service").bold() +
                                Text(" and ") +
                                Text("Privacy Policy.").bold()
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                }
                .navigationTitle("RestfulNight")
                .navigationBarTitleDisplayMode(.inline)
                .tabViewStyle(.automatic)
            }
          } else {
            TabBarView()
        }
    }
}

#Preview {
    OnboardingView()
}
