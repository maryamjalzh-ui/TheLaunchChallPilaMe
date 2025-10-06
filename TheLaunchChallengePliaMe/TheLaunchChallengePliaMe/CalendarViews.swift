//
//  CalendarViews.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//
// MARK: - 6. CalendarViews.swift
// MARK: - 6. CalendarViews.swift

// MARK: - 6. CalendarViews.swift (Updated with Old Design)

// MARK: - 6. CalendarViews.swift

import SwiftUI

/// MARK: - 7. شاشات التقويم (AddClassesUIView)
struct AddClassesUIView: View {
    @EnvironmentObject var appData: AppData
    
    @State private var currentMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    
    let daysOfWeek: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let calendar = Calendar.current
    
    private let mainBackgroundColor = Color.primaryBackground

    // الدوال المساعدة للتقويم (fetchMonthDates, changeMonth, toggleDateSelection) موجودة في ملف ModelsAndData.swift
    
    private func unselectAllDates() {
        let attended = Set(appData.attendedDates.map { calendar.startOfDay(for: $0) })
        appData.selectedClassDates.removeAll()
        
        for date in attended {
             appData.selectedClassDates.insert(date)
        }
    }

    // دالة تبديل تحديد التاريخ (مكررة هنا للوضوح)
    private func toggleDateSelection(date: Date) {
        let dayStart = calendar.startOfDay(for: date)
        
        if appData.attendedDates.contains(dayStart) {
            return
        }
        
        if appData.selectedClassDates.contains(dayStart) {
            appData.selectedClassDates.remove(dayStart)
        } else {
            appData.selectedClassDates.insert(dayStart)
        }
    }

    private func fetchMonthDates() -> [Date?] {
        // تم استيراد الدالة من AppData لكي يعمل الكود بشكل كامل
        // (يجب أن يتم نسخ هذه الدالة من AppData أو ModelsAndData)
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        
        let firstOfMonth = monthInterval.start
        let startWeekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingSpaces = (startWeekday - 1)
        var dates: [Date?] = Array(repeating: nil, count: leadingSpaces)
        
        var current = firstOfMonth
        while current < monthInterval.end {
            dates.append(current)
            guard let next = calendar.date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }
        
        let totalCells = dates.count
        if totalCells % 7 != 0 {
            dates.append(contentsOf: Array(repeating: nil, count: 7 - (totalCells % 7)))
        }
        
        return dates
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text("Add Your Classes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkBrown)
                
                Spacer()
                
                Button(action: unselectAllDates) {
                    Text("Clear All")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(Color.red)
                }
            }
            .padding(.top, 20)
            
            MonthHeader(currentMonth: $currentMonth, changeMonth: changeMonth)
            
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(fetchMonthDates(), id: \.self) { date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: appData.selectedClassDates.contains(calendar.startOfDay(for: date)),
                            isAttended: appData.attendedDates.contains(calendar.startOfDay(for: date)),
                            action: { toggleDateSelection(date: date) }
                        )
                    } else {
                        Color.clear.frame(height: 40)
                    }
                }
            }
            .padding(.horizontal, 5)
            
            Spacer()
            
            Button {
                appData.updateCountsFromSelection()
            } label: {
                Text("Save Selections (\(appData.selectedClassDates.count - Set(appData.attendedDates).count))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.midBrown)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.vertical, 10)


        }
        .padding(.horizontal)
        .background(mainBackgroundColor.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - مكونات التقويم (Calendar Components)

struct MonthHeader: View {
    @Binding var currentMonth: Date
    var changeMonth: (Int) -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    // تم استخدام الكود الذي أرسلته لـ MonthHeader
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text(dateFormatter.string(from: currentMonth))
                    .font(.headline)
                    .foregroundColor(.primaryAccent)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.primaryAccent.opacity(0.4), lineWidth: 1)
                            .padding(-4)
                    )
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title3)
            .foregroundColor(.faintText)
        }
        .padding(.horizontal, 15)
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isAttended: Bool
    var action: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        let day = calendar.component(.day, from: date)
        let isToday = calendar.isDateInToday(date)
        let isInPast = date < calendar.startOfDay(for: Date()) && !calendar.isDateInToday(date)
        
        ZStack {
            Circle()
                .fill(fillColor)
                .frame(width: 40, height: 40)
            
            Text("\(day)")
                .font(.body)
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(textColor(isInPast: isInPast))
            
            if isAttended {
                Circle()
                    .stroke(Color.primaryAccent, lineWidth: 2)
                    .frame(width: 48, height: 48)
            }
            
            if isSelected && !isAttended {
                Circle()
                    .fill(Color.primaryAccent)
                    .frame(width: 5, height: 5)
                    .offset(y: 15)
            }
        }
        .frame(height: 40)
        .contentShape(Circle())
        .onTapGesture {
            if !isInPast || isToday {
                action()
            }
        }
    }
    
    private var fillColor: Color {
        if isAttended { return Color.primaryAccent.opacity(0.5) }
        else if isSelected { return Color.primaryAccent.opacity(0.3) }
        else if calendar.isDateInToday(date) { return Color.midBrown.opacity(0.3) }
        else { return .clear }
    }
    
    private func textColor(isInPast: Bool) -> Color {
        if isAttended { return .white }
        else if isSelected { return Color.darkBrown }
        else if isInPast { return .gray.opacity(0.6) }
        else { return Color.darkBrown }
    }
}
