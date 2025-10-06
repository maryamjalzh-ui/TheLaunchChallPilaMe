// MARK: - 6. CalendarViews.swift
import SwiftUI

/// MARK: - شاشات التقويم (AddClassesUIView)
struct CalendarViews: View {
    @EnvironmentObject var appData: AppData
    @State private var currentMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    
    let daysOfWeek: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    private let calendar = Calendar.current
    private let mainBackgroundColor = Color.primaryBackground
    
    private func fetchMonthDates() -> [Date?] {
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
    
    // الفنكشن المحدثة: تسمح بإلغاء التحديد فقط إذا لم يكن التاريخ في attendedDates وتمنع الماضي
    private func toggleDateSelection(date: Date) {
        let dayStart = calendar.startOfDay(for: date)
        
        // منع التحديد إذا كان التاريخ في الماضي
        if dayStart < calendar.startOfDay(for: Date()) && !calendar.isDateInToday(date) {
            return
        }
        
        // لا يمكن تغيير حالة التواريخ التي تم حضورها بالفعل
        if appData.attendedDates.contains(dayStart) {
            return
        }
        
        if appData.selectedClassDates.contains(dayStart) {
            appData.selectedClassDates.remove(dayStart)
        } else {
            appData.selectedClassDates.insert(dayStart)
        }
    }
    
    // الفنكشن المحدثة: تزيل التحديد من جميع التواريخ ما عدا those in attendedDates
    private func unselectAllDates() {
        let attended = Set(appData.attendedDates.map { calendar.startOfDay(for: $0) })
        appData.selectedClassDates.removeAll()
        
        // إعادة إضافة التواريخ التي لا يمكن إلغاء تحديدها
        for date in attended {
            appData.selectedClassDates.insert(date)
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            //  توحيد الخلفية العلوية والسفلية باللون الفاتح
            mainBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 125)
                //  إزالة الخلفية السفلية الداكنة والاعتماد على خلفية الـ ZStack
                Color.primaryBackground
                    .cornerRadius(40, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Add Your Classes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.darkBrown)
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 30)
                
                VStack(spacing: 25) {
                    MonthNavigationHeader(currentMonth: $currentMonth, changeMonth: changeMonth)
                    
                    HStack(spacing: 0) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.faintText)
                        }
                    }
                    
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(fetchMonthDates().indices, id: \.self) { index in
                            if let date = fetchMonthDates()[index] {
                                DateCell(
                                    date: date,
                                    selectedDates: $appData.selectedClassDates,
                                    // تم تحويلattendedDates إلى Set<Date> لحل مشكلة النوع
                                    attendedDates: Set(appData.attendedDates),
                                    toggleDateSelection: toggleDateSelection,
                                    calendar: calendar
                                )
                            } else {
                                Text("")
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    HStack {
                        let currentlySelectedCount = appData.selectedClassDates.count
                        let attendedCount = Set(appData.attendedDates).count
                        let newSelectedCount = currentlySelectedCount - attendedCount
                        
                        Text("New Selections: \(newSelectedCount)")
                            .font(.subheadline)
                            .foregroundColor(.primaryAccent)
                        
                        Spacer()
                        
                        Button(action: unselectAllDates) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark.circle.fill")
                                Text("Clear All")
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primaryAccent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.primaryBackground)
                            .cornerRadius(10)
                        }
                        .opacity(newSelectedCount <= 0 ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: newSelectedCount)
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.vertical, 25)
                .background(Color.primaryBackground)
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
                
                //                Button(action: {
                //                    appData.updateCountsFromSelection()
                //                    print("Selected Classes confirmed: \(appData.selectedClassDates.count)")
                //                }) {
                //                    Text("Confirm Selection ")
                //                        .font(.headline)
                //                        .fontWeight(.bold)
                //                        .foregroundColor(.white)
                //                        .frame(maxWidth: .infinity)
                //                        .padding()
                //                        .background(Color.primaryAccent)
                //                        .cornerRadius(15)
                //                        .shadow(color: Color.primaryAccent.opacity(0.4), radius: 8, x: 0, y: 5)
                //                }
                //                .padding(.horizontal, 20)
                //                Spacer()
                //            }
                //            .padding(.top, 40)
                //        }
                //        .navigationBarHidden(true)
                //    }
                //}
                NavigationLink(destination: MainAppTabsView(userLevel: "", userObjective: "")) {
                    // الـ Action يجب أن يتم داخل الـ Button Label قبل الانتقال
                    Text("Confirm Selection ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryAccent)
                        .cornerRadius(15)
                        .shadow(color: Color.primaryAccent.opacity(0.4), radius: 8, x: 0, y: 5)
                }
                // تنفيذ الـ Action قبل الانتقال
                .simultaneousGesture(TapGesture().onEnded {
                    appData.updateCountsFromSelection()
                    print("Selected Classes confirmed: \(appData.selectedClassDates.count)")
                })
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - مكونات التقويم (Calendar Components)
    
    // تم إعادة DateCell إلى تصميم الكود الأول مع إضافة منطق isAttended و isInPast
    struct DateCell: View {
        let date: Date
        @Binding var selectedDates: Set<Date>
        let attendedDates: Set<Date>
        let toggleDateSelection: (Date) -> Void
        let calendar: Calendar
        
        private var dayNumber: Int {
            calendar.component(.day, from: date)
        }
        
        private var isSelected: Bool {
            selectedDates.contains(calendar.startOfDay(for: date))
        }
        
        private var isAttended: Bool {
            attendedDates.contains(calendar.startOfDay(for: date))
        }
        
        private var isInPast: Bool {
            date < calendar.startOfDay(for: Date()) && !calendar.isDateInToday(date)
        }
        
        private var isDisabled: Bool {
            isAttended || isInPast
        }
        
        var body: some View {
            Button(action: { toggleDateSelection(date) }) {
                Text("\(dayNumber)")
                    .font(.body)
                    .fontWeight(.regular)
                    .frame(width: 35, height: 35)
                // تصميم الخلفية الأصلي (الكود الأول)
                    .background(
                        Group {
                            // عند الحضور نستخدم دائرة بلون أغمق كدليل واضح
                            if isAttended {
                                Circle().fill(Color.primaryAccent)
                            } else if isSelected {
                                // اللون الأصلي عند التحديد
                                Circle().fill(Color.primaryAccent.opacity(0.15))
                            } else {
                                EmptyView()
                            }
                        }
                    )
                // تعديل لون النص للحفاظ على التصميم والوضوح
                    .foregroundColor(
                        isAttended ? .white : // التواريخ المحضورة باللون الأبيض
                        (isInPast ? Color(white: 0.3).opacity(0.4) : // التواريخ الماضية باهتة
                         (isSelected ? .primaryAccent : Color(white: 0.3))) // التواريخ المحددة/الافتراضية
                    )
            }
            .disabled(isDisabled)
        }
    }
    
    struct MonthNavigationHeader: View {
        @Binding var currentMonth: Date
        let changeMonth: (Int) -> Void
        private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter
        }()
        
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
}
