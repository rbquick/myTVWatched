//
//  SimpleCanendarView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-12-01.
//

import SwiftUI
import Combine

final class SimpleCalendarGridState: ObservableObject {
    @Published var showUpcomingEpisodesView: Bool = false
    @Published var selectedDate: Date = Date()
}

struct SimpleCalendarGrid: View {
    @StateObject private var state = SimpleCalendarGridState()
    let currentdate: Date

    
    @EnvironmentObject var myshowsmodel: MyShowsModel

    private let calendar = Calendar.current
    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Returns the first visible date for the calendar grid of the month containing referenceDate
    // (i.e., the Sunday on or before the first day of that month)
    private func firstVisibleDateOfMonth(containing referenceDate: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        guard let monthStart = calendar.date(from: components) else { return referenceDate }
        // weekday: 1=Sunday ... 7=Saturday in Gregorian
        let weekday = calendar.component(.weekday, from: monthStart)
        // Offset back to Sunday (0 if already Sunday)
        let offset = 1 - weekday
        return calendar.date(byAdding: .day, value: offset, to: monthStart) ?? monthStart
    }


    
    var body: some View {
        // Use the provided currentdate to determine which month to show
        let monthReference = currentdate
        // First visible date (Sunday on/before the first of the month)
        let gridStart = firstVisibleDateOfMonth(containing: monthReference)
        let monthDates = generateDates(for: monthReference)

        VStack {
            Text(currentdate, format: Date.FormatStyle().month(.wide).day(.twoDigits).year())
                .font(.title2)
            // Days of week headers
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
            }
            // Calendar grid
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 8) {
                ForEach(monthDates, id: \.self) { date in
                    Button(action: {
                        state.selectedDate = date
                        state.showUpcomingEpisodesView = true
                    }) {
                        Text(dateText(date))
                            .frame(maxWidth: .infinity, minHeight: 36)
                            .background(myshowsmodel.upcomingEpisodes.keys.contains(date) ? Color.blue.opacity(0.2) : Color.clear)
                        // this colours the selected date when clicked
//                            .background(isSameDay(date1: date, date2: selectedDate) ? Color.blue.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                    }
                    .foregroundColor(isSameDay(date1: date, date2: state.selectedDate) ? .blue : .primary)
//                    .disabled(!calendar.isDate(date, equalTo: monthReference, toGranularity: .month))
                }
            }
        }
        .padding()
        .onAppear() {
            state.selectedDate = firstVisibleDateOfMonth(containing: currentdate)

        }
        .onChange(of: currentdate) {
            myshowsmodel.upcomingEpisodes = myshowsmodel.episodeDates.filter { date, _ in
                   date >= firstVisibleDateOfMonth(containing: monthDates.first ?? Date())
               }
        }
        // fixing state
//        .sheet(isPresented: $state.showUpcomingEpisodesView) {
//            UpcomingEpisodesView(selectedDate: state.selectedDate)
//        }
    }

    // Generate all days to show in the grid (including leading/trailing days for alignment)
    func generateDates(for referenceDate: Date) -> [Date] {
        let components = calendar.dateComponents([.year, .month], from: referenceDate)
        guard let monthStart = calendar.date(from: components) else { return [] }

        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        let daysInMonth = range.count

        // Compute first visible date (Sunday on or before first of month)
        let firstWeekday = calendar.component(.weekday, from: monthStart) // 1=Sun..7=Sat
        let offsetToSunday = 1 - firstWeekday
        let firstVisible = calendar.date(byAdding: .day, value: offsetToSunday, to: monthStart) ?? monthStart

        // We need enough cells to cover all days plus the leading days to align and trailing to complete weeks
        // Start from firstVisible and continue until we've covered all days of the month and completed the last week row
        var dates: [Date] = []
        var current = firstVisible

        // The grid must include at least all days of the month
        // Determine the day after the end of the month
        let endOfMonth = calendar.date(byAdding: .day, value: daysInMonth, to: monthStart) ?? monthStart

        // Keep appending days until current >= endOfMonth and we end on a Saturday (weekday 7)
        while true {
            dates.append(current)
            let next = calendar.date(byAdding: .day, value: 1, to: current) ?? current

            // Break when we've passed the month and the current day is Saturday
            let isPastEnd = next >= endOfMonth
            let weekday = calendar.component(.weekday, from: current)
            if isPastEnd && weekday == 7 { break }

            current = next
        }

        return dates
    }

    func isSameDay(date1: Date?, date2: Date?) -> Bool {
        guard let d1 = date1, let d2 = date2 else { return false }
        return calendar.isDate(d1, inSameDayAs: d2)
    }

    func dateText(_ date: Date) -> String {
        let day = calendar.component(.day, from: date)
        return "\(day)"
    }
}

//#Preview {
//    SimpleCalendarGrid(currentdate: Date())
//}
