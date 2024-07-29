//
//  SleepChartView.swift
//  RestfulNight
//
//  Created by Deimante Valunaite on 22/07/2024.
//

import Charts
import SwiftUI

struct SleepChartView: View {
    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Picker("Time View", selection: $homeViewModel.timeView) {
                ForEach(TimeView.allCases, id: \.self) { view in
                    Text(view.rawValue.capitalized).tag(view)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: homeViewModel.timeView) { _ in
                homeViewModel.filterSleepData()
            }
            
            Chart {
                RuleMark(y: .value("Goal", 7.5))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Goal")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                
                ForEach(homeViewModel.filteredSleepData) { data in
                    BarMark(
                        x: .value("Date", data.date, unit: .day),
                        y: .value("Sleep Duration", data.sleepDuration)
                    )
                    .foregroundStyle(.blue.gradient)
                }
            }
            .frame(height: 300)
            .chartYScale(domain: 0...8)
            .padding()
        }
        .navigationTitle("Sleep Duration")
        
        Spacer()
    }
}

#Preview {
    SleepChartView()
}
