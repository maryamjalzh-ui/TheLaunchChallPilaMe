//
//  MainPageUIview.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 09/04/1447 AH.
//

//
//  ContentView.swift
//  FirstChallengePillame
//
//  Created by lamess on 06/04/1447 AH.
//

//
//import SwiftUI
//
//// 1. تعريف الألوان المخصصة (بدون تغيير)
//extension Color {
//    static let primaryBackground = Color(red: 0.988, green: 0.973, blue: 0.941) // Soft beige
//    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.2)
//    static let cardBackground = Color(red: 0.973, green: 0.933, blue: 0.945) // Light pinkish
//    static let accentBrown = Color(red: 0.627, green: 0.322, blue: 0.176) // Sienna/Brown
//    static let completeButton = Color(red: 0.941, green: 0.882, blue: 0.894) // Soft pink for button
//    static let cardWhite = Color(red: 0.96, green: 0.96, blue: 0.96) // Off-white for small cards
//}
//
//// 2. هيكل البيانات (بدون تغيير)
//struct ClassItem: Identifiable {
//    let id = UUID()
//    let name: String
//    var isCompleted: Bool
//}
//
//// 3. الصفحة الرئيسية (ContentView) - تم تغيير الاتجاه إلى LTR
//struct ContentView: View {
//
//    // البيانات الافتراضية
//    @State var userObjective: String = "Mental"
//    @State var userLevel: String = "Flow Easy"
//    @State var classesLeft: Int = 14
//    @State var upcomingClasses: [ClassItem] = [
//        ClassItem(name: "Daily Pilates Flow", isCompleted: false)
//    ]
//
//    func completeClass(id: UUID) {
//        if let index = upcomingClasses.firstIndex(where: { $0.id == id }) {
//            upcomingClasses[index].isCompleted.toggle()
//        }
//    }
//
//    var body: some View {
//        ZStack {
//            // الخلفية
//            Color.primaryBackground.edgesIgnoringSafeArea(.all)
//
//            ScrollView {
//                VStack(alignment: .leading, spacing: 25) { // المحاذاة الرئيسية: اليسار (.leading)
//
//                    // 1. Header
//                    HeaderView()
//
//                    // 2. User Info Cards
//                    UserInfoCards(objective: userObjective, level: userLevel)
//
//                    // 3. Classes Left Card
//                    ClassesLeftCard(count: classesLeft)
//
//                    // 4. Upcoming Classes Section
//                    UpcomingClassesSection(classes: upcomingClasses) { classID in
//                        completeClass(id: classID)
//                    }
//
//                    // 5. Decorative Image
//                    LotusFlowerImage()
//
//                }
//                .padding(.horizontal)
//            }
//        }
//    }
//}
//
//// --- مكونات واجهة المستخدم (تغيير المحاذاة) ---
//
//// 1. مكون الرأس
//struct HeaderView: View {
//    var body: some View {
//        HStack {
//            // "Hello, Yara!" على اليسار
//            Text("Hello, Yara!")
//                .font(.custom("Tajawal", size: 28))
//                .fontWeight(.bold)
//                .foregroundColor(.primaryText)
//
//            Spacer() // يدفع الأيقونة لليمين
//
//            Image(systemName: "calendar")
//                .font(.title2)
//                .foregroundColor(.primaryText)
//        }
//        .padding(.top, 10)
//    }
//}
//
//// 2. مكون بطاقات الهدف والمستوى
//struct UserInfoCards: View {
//    let objective: String
//    let level: String
//
//    var body: some View {
//        HStack(spacing: 10) {
//
//            // بطاقة الهدف (Objective) - تبدأ من اليسار
//            InfoCard(title: "Your Objective", value: objective, alignment: .leading)
//
//            // بطاقة المستوى (Level) - تتبعها
//            InfoCard(title: "Your level of activity", value: level, alignment: .leading)
//        }
//    }
//}
//
//// 2.1. هيكل البطاقة الفردية
//struct InfoCard: View {
//    let title: String
//    let value: String
//    let alignment: HorizontalAlignment // .leading
//
//    var body: some View {
//        VStack(alignment: alignment, spacing: 5) {
//            Text(title)
//                .font(.caption)
//                .foregroundColor(.gray)
//
//            Text(value)
//                .font(.headline)
//                .fontWeight(.medium)
//                .foregroundColor(.primaryText)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading) // تثبيت المحاذاة لليسار
//        .padding(15)
//        .background(Color.cardWhite) // لون فاتح
//        .cornerRadius(15)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
//    }
//}
//
//
//// 3. مكون بطاقة الحصص المتبقية
//struct ClassesLeftCard: View {
//    let count: Int
//
//    var body: some View {
//        HStack(spacing: 20) {
//
//            // الرقم (على اليسار)
//            Text("\(count)")
//                .font(.system(size: 48, weight: .bold))
//                .foregroundColor(.accentBrown)
//
//            // النص
//            VStack(alignment: .leading, spacing: 5) { // المحاذاة لليسار
//                Text("Class Left")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .foregroundColor(.primaryText)
//
//                // أيقونة الإكمال
//                Image(systemName: "checkmark.circle.fill")
//                    .foregroundColor(Color.accentBrown)
//            }
//
//            Spacer() // يدفع المحتوى لليسار
//        }
//        .padding(20)
//        .background(Color.cardBackground)
//        .cornerRadius(25)
//    }
//}
//
//// 4. قسم الحصص القادمة
//struct UpcomingClassesSection: View {
//    let classes: [ClassItem]
//    var completeAction: (UUID) -> Void
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 15) { // المحاذاة لليسار
//
//            Text("Upcoming Class")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(.primaryText)
//
//            // عرض الحصص القادمة
//            ForEach(classes) { item in
//                ClassRow(item: item, action: completeAction)
//            }
//        }
//    }
//}
//
//// 4.1. صف الحصة الواحدة
//struct ClassRow: View {
//    let item: ClassItem
//    var action: (UUID) -> Void
//
//    var body: some View {
//        HStack {
//
//            // اسم الحصة (على اليسار)
//            Text(item.name)
//                .font(.body)
//                .foregroundColor(item.isCompleted ? .gray : .primaryText)
//                .strikethrough(item.isCompleted)
//
//            Spacer()
//
//            // زر الإكمال (على اليمين)
//            Button(action: {
//                action(item.id)
//            }) {
//                Text(item.isCompleted ? "Completed" : "Complete")
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                    .foregroundColor(item.isCompleted ? .white : .accentBrown)
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 15)
//                    .background(item.isCompleted ? Color.accentBrown : Color.completeButton)
//                    .cornerRadius(20)
//            }
//            .buttonStyle(PlainButtonStyle())
//        }
//        .padding(.vertical, 5)
//    }
//}
//
//// 5. صورة اللوتس الزخرفية
//struct LotusFlowerImage: View {
//    // يجب إضافة صورة باسم "LotusPlaceholder" في Assets
//    var body: some View {
//        Image("LotusPlaceholder")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 200, height: 150) // حجم مناسب
//            .opacity(0.7)
//            .padding(.top, 40)
//            .frame(maxWidth: .infinity, alignment: .center) // توسيط الصورة
//    }
//}
//
//// 6. معاينة الكود في Xcode
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI

// 1. تعريف الألوان المخصصة
extension Color {
    static let primaryBackground = Color(red: 0.988, green: 0.973, blue: 0.941) // Soft beige
    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let cardBackground = Color(red: 0.973, green: 0.933, blue: 0.945) // Light pinkish (للـ Class Left)
    static let accentBrown = Color(red: 0.627, green: 0.322, blue: 0.176) // Sienna/Brown
    static let completeButton = Color(red: 0.941, green: 0.882, blue: 0.894) // Soft pink for button background
    static let cardWhite = Color(red: 0.96, green: 0.96, blue: 0.96) // Off-white for small cards
}

// 2. هيكل البيانات (بدون تغيير)
struct ClassItem: Identifiable {
    let id = UUID()
    let name: String
    let isCompleted: Bool
}

// 3. الصفحة الرئيسية (ContentView)
struct MainPageUIview: View {
    
    // البيانات الافتراضية
    @State var userObjective: String = "Mental"
    @State var userLevel: String = "Flow Easy"
    @State var classesLeft: Int = 14
    @State var upcomingClasses: [ClassItem] = [
        ClassItem(name: "Daily Pilates Flow", isCompleted: false)
    ]
    
    func completeClass(id: UUID) {
        if let index = upcomingClasses.firstIndex(where: { $0.id == id }) {
            // قم بتحديث حالة الإكمال
            upcomingClasses[index] = ClassItem(name: upcomingClasses[index].name, isCompleted: true)
            // يمكن هنا إضافة منطق تحديث classesLeft
            // classesLeft -= 1
        }
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 1. Header (تم تحديثه ليتضمن الصورة الجديدة كخلفية جزئية)
                    HeaderView()
                    
                    // 2. User Info Cards
                    UserInfoCards(objective: userObjective, level: userLevel)
                    
                    // 3. Classes Left Card (تم تغيير الشكل)
                    ClassesLeftCard(count: classesLeft)
                    
                    // 4. Upcoming Classes Section (تم تغيير الشكل)
                    UpcomingClassesSection(classes: upcomingClasses) { classID in
                        completeClass(id: classID)
                    }
                    
                    // 5. Decorative Image (Lotus Flower)
                    LotusFlowerImage()

                }
                .padding(.horizontal)
            }
        }
    }
}

// --- مكونات واجهة المستخدم ---

// 1. مكون الرأس
struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Hello, Yara!")
                .font(.custom("Tajawal", size: 28))
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Image(systemName: "calendar")
                .font(.title2)
                .foregroundColor(.primaryText)
        }
        .padding(.top, 10)
    }
}

// 2. مكون بطاقات الهدف والمستوى (بدون تغيير جوهري في الشكل)
struct UserInfoCards: View {
    let objective: String
    let level: String
    
    var body: some View {
        HStack(spacing: 10) {
            InfoCard(title: "Your Objective", value: objective)
            InfoCard(title: "Your level of activity", value: level)
        }
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .background(Color.cardWhite)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}


// 3. مكون بطاقة الحصص المتبقية (Classes Left)
struct ClassesLeftCard: View {
    let count: Int
    
    var body: some View {
        HStack(spacing: 15) {
            
            // دائرة الرقم
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                    .frame(width: 60, height: 60)
                
                Text("\(count)")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundColor(.primaryText)
            }
            .padding(.leading, 5)

            // النص
            VStack(alignment: .leading, spacing: 5) {
                Text("Class Left")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
            }
            
            Spacer()
            
            // أيقونة الإكمال (علامة الصح)
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color.gray.opacity(0.5)) // لون باهت كما في التصميم
                .font(.title2)
                .padding(.trailing, 10)

        }
        .padding(.vertical, 15)
        .padding(.horizontal, 10)
        .background(Color.cardBackground) // لون وردي فاتح
        .cornerRadius(25) // حدود مستديرة كبيرة
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// 4. قسم الحصص القادمة
struct UpcomingClassesSection: View {
    let classes: [ClassItem]
    var completeAction: (UUID) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("Upcoming Class")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            ForEach(classes) { item in
                ClassRow(item: item, action: completeAction)
            }
        }
    }
}

// 4.1. صف الحصة الواحدة (Class Row)
struct ClassRow: View {
    let item: ClassItem
    var action: (UUID) -> Void
    
    var body: some View {
        HStack {
            
            // اسم الحصة
            Text(item.name)
                .font(.body)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            // زر الإكمال
            Button(action: {
                if !item.isCompleted {
                    action(item.id)
                }
            }) {
                Text(item.isCompleted ? "Completed" : "Complete")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(item.isCompleted ? .white : .accentBrown)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 15)
                    .background(item.isCompleted ? Color.accentBrown : Color.completeButton)
                    .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(15) // إضافة حشوة داخلية للبطاقة
        .background(Color.white) // خلفية بيضاء للبطاقة
        .cornerRadius(15) // حدود مستديرة
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

// 5. صورة اللوتس الزخرفية (بدون تغيير)
struct LotusFlowerImage: View {
    var body: some View {
        // يجب إضافة الصورة في Assets
        Image("LotusPlaceholder")
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 150)
            .opacity(0.7)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainPageUIview()
    }
}
