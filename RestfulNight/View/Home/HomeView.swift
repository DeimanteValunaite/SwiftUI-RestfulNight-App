//
//  HomeView.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 08/07/2024.
//

import SwiftUI
import UserNotifications

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
   
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                SleepTimeSlider()
                
                HStack {
                    Image(systemName: "moon.fill")
                    VStack {
                        Text(homeViewModel.getTime(angle: homeViewModel.startAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                        Text("Bedtime")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "alarm.fill")
                    VStack {
                        Text(homeViewModel.getTime(angle: homeViewModel.toAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                        Text("Wake up")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Choose days")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                HStack {
                    ForEach(homeViewModel.daysOfWeek, id: \.id) { day in
                        Text(day.initial)
                            .frame(width: 42, height: 42)
                            .background(homeViewModel.selectedDays.contains(day.id) ? Color.primary : Color.gray.opacity(0.3))
                            .foregroundColor(homeViewModel.selectedDays.contains(day.id) ? Color.white : Color.black)
                            .clipShape(Circle())
                            .onTapGesture {
                                if homeViewModel.selectedDays.contains(day.id) {
                                    homeViewModel.selectedDays.remove(day.id)
                                } else {
                                    homeViewModel.selectedDays.insert(day.id)
                                }
                            }
                    }
                }
                .padding(.bottom)
                
                HStack {
                    Text("Remind me to sleep")
                        .font(.headline)
                    Spacer()
                    Toggle("", isOn: $homeViewModel.isReminderEnabled)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 2)
                .tint(.primary)
                .toolbar {
                    NavigationLink {
                        SleepChartView()
                    } label: {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tint(.primary)
                }
            }
            .navigationTitle("RestfulNight")
            .navigationBarTitleDisplayMode(.large)
            .padding()
        }
    }
    
    @ViewBuilder
    func SleepTimeSlider() -> some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            ZStack {
                ZStack {
                    let numbers = [12, 15, 18, 21, 0, 3, 6, 9]
                    
                    ForEach(numbers.indices, id: \.self) { index in
                        Text("\(numbers[index])")
                            .foregroundColor(.secondary)
                            .font(.caption)
                            .rotationEffect(.init(degrees: Double(index) * -45))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 45 ))
                    }
                }
                
                Circle()
                    .stroke(Color.black.opacity(0.06), lineWidth: 40)
                
                let reverseRotation = (homeViewModel.startProgress > homeViewModel.toProgress) ? -Double((1 - homeViewModel.startProgress) * 360) : 0
                
                Circle()
                    .trim(from: homeViewModel.startProgress > homeViewModel.toProgress ? 0 : homeViewModel.startProgress, to: homeViewModel.toProgress + (-reverseRotation / 360))
                    .stroke(Color.black, style:
                                StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                Image(systemName: "moon.stars.fill")
                    .font(.callout)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -homeViewModel.startAngle))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: homeViewModel.startAngle))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                homeViewModel.onDrag(value: value, fromSlider: true)
                            }
                    )
                    .rotationEffect(.init(degrees: -90))
                
                Image(systemName: "alarm.fill")
                    .font(.callout)
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -homeViewModel.toAngle))
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: homeViewModel.toAngle))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                homeViewModel.onDrag(value: value)
                            }
                    )
                    .rotationEffect(.init(degrees: -90))
                
                HStack(spacing: 8) {
                    Text("\(homeViewModel.getTimeDifference().0)h")
                        .font(.title)
                        .fontWeight(.medium)
                    Text("\(homeViewModel.getTimeDifference().1)m")
                        .font(.title)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.4)
    }
}

extension View {
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}

#Preview {
    HomeView()
}
