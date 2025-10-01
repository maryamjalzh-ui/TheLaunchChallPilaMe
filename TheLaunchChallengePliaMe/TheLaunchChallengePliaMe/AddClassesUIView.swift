//
//  AddClassesUIView.swift
//  TheLaunchChallengePliaMe
// هذي صفحة اضافة الكلاسات
//  Created by Maryam Jalal Alzahrani on 09/04/1447 AH.
//

import SwiftUI

// MARK: - Helper for Custom Corner Radius (لجعل الزوايا العلوية فقط مدورة)
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// تعريف الألوان المخصصة
extension Color {
    // الخلفية الأساسية (البيج / الكريمي)
    static let customBackground = Color(red: 0xf5 / 255, green: 0xe8 / 255, blue: 0xd0 / 255)
    
    // اللون البيج الفاتح لخلفية البطاقة الكبيرة (FFF7E6)
    static let offWhiteBackground = Color(red: 0xFF / 255, green: 0xF7 / 255, blue: 0xE6 / 255)
    
    // اللون الغامق الجديد للنص والأزرار (F3E6E8)
    // هذا اللون فاتح جداً للاستخدام كنص، لذا سنستخدمه كلون 'تأكيد' رئيسي فاتح
    static let accentFaint = Color(red: 0xF3 / 255, green: 0xE6 / 255, blue: 0xE8 / 255)

    // **تصحيح:** اللون الفاتح الجديد لخلفية التحديد هو الآن #EED2D2
    static let accentBackgroundNew = Color(red: 0xEE / 255, green: 0xD2 / 255, blue: 0xD2 / 255)
    
    // سنستخدم لون أغمق قليلاً للنصوص والأزرار لضمان الرؤية الجيدة (Contrast)
    static let primaryAccent = Color(red: 0.55, green: 0.35, blue: 0.45) // لون أحمر طيني/خمري
    
    // نص خافت
    static let faintText = Color(.systemGray3)
}

struct AddClassesUIView: View {
    // نجعل الشهر الافتراضي هو الشهر الحالي تلقائياً
    @State private var currentMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    
    // مجموعة التواريخ المختارة
    @State private var selectedDates: Set<Date> = Set()

    let daysOfWeek: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    private let calendar = Calendar.current
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy" // مثال: "Sat, Apr 5, 2025"
        return formatter
    }()
    
    // دالة لجلب جميع التواريخ التي ستعرض في التقويم لهذا الشهر
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
    
    // دالة جديدة لتحديد/إلغاء تحديد تاريخ واحد
    private func toggleDateSelection(date: Date) {
        let dayStart = calendar.startOfDay(for: date)
        
        if selectedDates.contains(dayStart) {
            selectedDates.remove(dayStart)
        } else {
            selectedDates.insert(dayStart)
        }
    }

    // دالة لمسح جميع التواريخ المختارة
    private func unselectAllDates() {
        selectedDates.removeAll()
    }

    var body: some View {
        ZStack(alignment: .top) {
            
            // 1. الخلفية الرئيسية (اللون البيج)
            Color.customBackground.edgesIgnoringSafeArea(.all)
            
            // 2. الخلفية البيج الفاتح الكبيرة التي تبدأ من منتصف الشاشة
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 125) // مسافة لبدء الخلفية
                
                Color.offWhiteBackground // الخلفية البيج الفاتح الكبيرة
                    .cornerRadius(40, corners: [.topLeft, .topRight])
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            // 3. المحتوى الرئيسي
            VStack(alignment: .leading, spacing: 30) {
                
                // العنوان
                Text("Add Your Classes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(white: 0.2))
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 30)
                
                // بطاقة التقويم الداخلية (Calendar Card)
                VStack(spacing: 25) {
                    
                    // شريط الشهر والتنقل
                    MonthNavigationHeader(currentMonth: $currentMonth, changeMonth: changeMonth)
                    
                    // شريط أيام الأسبوع
                    HStack(spacing: 0) {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.faintText)
                        }
                    }
                    
                    // شبكة الأرقام (التقويم التفاعلي)
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(fetchMonthDates().indices, id: \.self) { index in
                            if let date = fetchMonthDates()[index] {
                                DateCell(
                                    date: date,
                                    selectedDates: $selectedDates,
                                    toggleDateSelection: toggleDateSelection,
                                    calendar: calendar
                                )
                            } else {
                                Text("") // خلايا فارغة
                                    .frame(width: 35, height: 35)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    // عرض عدد الكلاسات المختارة وزر مسح التحديد
                    HStack {
                        Text("Selected Classes: \(selectedDates.count)")
                            .font(.subheadline)
                            .foregroundColor(.primaryAccent) // **استخدام اللون الأغمق للنص**
                        
                        Spacer()

                        // زر إلغاء تحديد الكل
                        Button(action: unselectAllDates) {
                            HStack(spacing: 4) {
                                Image(systemName: "xmark.circle.fill")
                                Text("Clear All")
                            }
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primaryAccent) // **استخدام اللون الأغمق للنص**
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.accentBackgroundNew.opacity(0.8)) // **الخلفية الفاتحة الجديدة المصححة**
                            .cornerRadius(10)
                        }
                        .opacity(selectedDates.isEmpty ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: selectedDates.isEmpty)
                    }
                    .padding(.horizontal, 25)
                    
                } // نهاية VStack داخل البطاقة
                .padding(.vertical, 25)
                .background(Color.customBackground) // هذه الخلفية هي لون البيج الأساسي
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
                
                // زر التأكيد (يقع على الخلفية البيج الفاتح الكبيرة)
                Button(action: {
                    let sortedDates = self.selectedDates.sorted()
                    let formattedDates = sortedDates.map { self.displayDateFormatter.string(from: $0) }
                    print("Selected Classes confirmed: \(formattedDates.joined(separator: ", "))")
                }) {
                    Text("Confirm Selection ")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.offWhiteBackground) // لون النص أوف وايت
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryAccent) // **استخدام اللون الأغمق للزر**
                        .cornerRadius(15)
                        .shadow(color: Color.primaryAccent.opacity(0.4), radius: 8, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 40) // لتجنب التداخل مع شريط الحالة
        }
    }
}

// MARK: - مكونات فرعية تفاعلية

// 1. شريط التنقل بين الأشهر
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
            // اسم الشهر والسنة
            HStack(spacing: 4) {
                Text(dateFormatter.string(from: currentMonth))
                    .font(.headline)
                    .foregroundColor(.primaryAccent) // **استخدام اللون الأغمق للنص**
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.primaryAccent.opacity(0.4), lineWidth: 1) // **استخدام اللون الأغمق للإطار**
                            .padding(-4)
                    )
            }
            
            Spacer()
            
            // أزرار التنقل بين الأشهر
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

// 2. خلية التاريخ التفاعلية
struct DateCell: View {
    let date: Date
    @Binding var selectedDates: Set<Date>
    let toggleDateSelection: (Date) -> Void
    let calendar: Calendar
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    // التحقق مما إذا كان التاريخ محددًا
    private var isSelected: Bool {
        selectedDates.contains(calendar.startOfDay(for: date))
    }
    
    var body: some View {
        Button(action: {
            toggleDateSelection(date)
        }) {
            Text("\(dayNumber)")
                .font(.body)
                .fontWeight(.regular)
                .frame(width: 35, height: 35)
                .background(
                    Group {
                        if isSelected {
                            // تمييز التاريخ المحدد بخلفية دائرية
                            Circle()
                                .fill(Color.accentBackgroundNew) // **الخلفية الفاتحة الجديدة المصححة**
                        } else {
                            EmptyView()
                        }
                    }
                )
                .foregroundColor(
                    isSelected ? .primaryAccent : Color(white: 0.3) // **استخدام اللون الأغمق للنص**
                )
        }
    }
}

// لمعاينة الكود في Xcode
struct AddPackageCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassesUIView()
            .previewDevice("iPhone 15 Pro")
    }
}
