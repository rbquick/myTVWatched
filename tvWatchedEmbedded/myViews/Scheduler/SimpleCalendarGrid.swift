//
//  SimpleCanendarView.swift
//  tvWatchedEmbedded
//
//  Created by Brian Quick on 2025-12-01.
//

import SwiftUI
import Combine

final class SimpleCalendarGridState: ObservableObject {
    @Published var selectedDate: Date = Date()
}

struct SimpleCalendarGrid: View {
    @StateObject private var state = SimpleCalendarGridState()
    let currentdate: Date

    @EnvironmentObject var myshowsmodel: MyShowsModel
    @Environment(\.selectedTab) var selectedTab
    @Environment(\.selectedShowID) var selectedShowID

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

    // Split the dates into weeks (arrays of 7 dates)
    private func generateWeeks(for referenceDate: Date) -> [[Date]] {
        let allDates = generateDates(for: referenceDate)
        var weeks: [[Date]] = []
        var currentWeek: [Date] = []
        for date in allDates {
            currentWeek.append(date)
            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }
        if !currentWeek.isEmpty {
            weeks.append(currentWeek)
        }
        return weeks
    }

    var body: some View {
        // Use the provided currentdate to determine which month to show
        let monthReference = currentdate
        // Weeks of dates (each week is 7 dates)
        let weeks = generateWeeks(for: monthReference)
        VStack {
            Text(currentdate, format: Date.FormatStyle().month(.wide).day(.twoDigits).year())
                .font(.title2)
            // Days of week headers
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .font(.headline)
                        .alignmentGuide(.top) { d in d[.top] }
                }
            }
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    Grid(alignment: .top, horizontalSpacing: 8, verticalSpacing: 8) {
                        ForEach(weeks, id: \.first!) { week in
                            GridRow(alignment: .top) {
                                ForEach(week, id: \.self) { date in
                                    calendarDayCell(for: date)
                                }
                            }
                            .id("week-\(week.first!)")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                }
                .onAppear {
                    state.selectedDate = firstVisibleDateOfMonth(containing: currentdate)
                    showEpisodes(startingAt: currentdate)
                    // Scroll to the week containing today if in the current month
                    let today = Date()
                    if calendar.isDate(today, equalTo: monthReference, toGranularity: .month) {
                        if let weekContainingToday = weeks.first(where: { week in
                            week.contains(where: { calendar.isDate($0, inSameDayAs: today) })
                        }) {
                            DispatchQueue.main.async {
                                proxy.scrollTo("week-\(weekContainingToday.first!)", anchor: .top)
                            }
                        }
                    }
                }
                .onReceive(myshowsmodel.$episodeDates) { _ in
                    showEpisodes(startingAt: currentdate)
                }
                .onChange(of: currentdate) { _, _ in
                    showEpisodes(startingAt: currentdate)
                    let today = Date()
                    if calendar.isDate(today, equalTo: currentdate, toGranularity: .month) {
                        if let weekContainingToday = weeks.first(where: { week in
                            week.contains(where: { calendar.isDate($0, inSameDayAs: today) })
                        }) {
                            DispatchQueue.main.async {
                                proxy.scrollTo("week-\(weekContainingToday.first!)", anchor: .top)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }

    private func showEpisodes(startingAt referenceDate: Date) {
        let firstVisibleDate = firstVisibleDateOfMonth(containing: referenceDate)
        myshowsmodel.upcomingEpisodes = myshowsmodel.episodeDates.filter { date, _ in
            date >= firstVisibleDate
        }
    }

    @ViewBuilder
    private func calendarDayCell(for date: Date) -> some View {
        VStack(spacing: 2) {
            Text(dateText(date))
                .frame(maxWidth: .infinity, minHeight: 36)
            // For each show/episode on that date, display grouped rows
            if let episodes = myshowsmodel.upcomingEpisodes[date] {
                let grouped = Dictionary(grouping: episodes, by: { $0.0.id })
                ForEach(grouped.keys.sorted(), id: \.self) { showID in
                    if let group = grouped[showID], let show = group.first?.0 {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(show.name).font(.footnote).fontWeight(.semibold)
                            ForEach(group, id: \.1.id) { _, episode in
                                Button("S\(episode.season), E\(episode.episode)") {
                                    if let selectedTab = selectedTab, let selectedShowID = selectedShowID {
                                        selectedTab.wrappedValue = 0
                                        selectedShowID.wrappedValue = show.id
                                    }
                                }
                                .buttonStyle(
                                    myButtonStyle(
                                        myStrokeColor: myshowsmodel.showepisodeDatewatched(
                                            myshowid: show.id,
                                            episodeid: episode.id
                                        ).isEmpty ? .black : .red
                                    )
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(myshowsmodel.upcomingEpisodes.keys.contains(date) ? Color.blue.opacity(0.2) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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

#Preview {
    SimpleCalendarGrid(currentdate: Date())
        .environmentObject(MyShowsModel())
}
