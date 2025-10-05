import SwiftUI
import Combine

// MARK: - 1. الهياكل الأساسية ونموذج البيانات (Shared Data Model)

struct ClassItem: Identifiable {
    let id = UUID()
    let name: String
    let isCompleted: Bool
    let date: Date
}

// الكلاس المحدَّث
class AppData: ObservableObject {
    
    @Published var selectedClassDates: Set<Date> = Set()
    @Published var classesLeft: Int = 0
    @Published var requiredClasses: Int = 0
    
    // بيانات الـ Streak
    @Published var classesCompletedStreak: Int = 0
    @Published var consecutiveMisses: Int = 0
    
    // سجل الحضور الدائم (لن يتم حفظه بعد إغلاق التطبيق)
    // 🛑 تم التعديل إلى [Date] للسماح بحساب جميع مرات الحضور التراكمي
    @Published var attendedDates: [Date] = [] // *** تم التغيير من Set إلى Array ***

    private let calendar = Calendar.current
    
    // دالة التهيئة (Constructor) - لا تحميل للبيانات
    init() {
        // لا يتم استدعاء loadData()، تبدأ البيانات بـ 0 أو فارغة
    }
    
    // ===========================================
    // الدوال الأساسية للتطبيق
    // ===========================================

    var upcomingClasses: [ClassItem] {
        return selectedClassDates
            .filter { $0 >= calendar.startOfDay(for: Date()) }
            .sorted(by: { $0 < $1 })
            .map { date in
                let _: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE, MMM d, yyyy"
                    return formatter
                }()
                let name = "Daily Pilates Flow"
                return ClassItem(name: name, isCompleted: false, date: date)
            }
    }
    
    var nextClass: ClassItem? {
        return upcomingClasses.first
    }
    
    // دالة لحساب الحضور الكلي مدى الحياة (غير محفوظ بشكل دائم)
    func totalLifetimeClasses() -> Int {
        return attendedDates.count
    }

    // دالة إكمال الكلاس (Complete)
    func completeNextClass() {
        guard let nextClassDate = nextClass?.date else { return }
        
        let classDate = calendar.startOfDay(for: nextClassDate)
        
        // 🛑 التعديل: استخدام .append لإضافة التاريخ إلى Array
        // وتسجيل تاريخ الكلاس المُجدول (classDate) بشكل متسق
        attendedDates.append(classDate)
        selectedClassDates.remove(classDate)
        
        if classesLeft > 0 { classesLeft -= 1 }
        
        classesCompletedStreak += 1
        consecutiveMisses = 0
    }
    
    // دالة تخطي الكلاس (Skip)
    func skipNextClass() {
        guard let nextClassDate = nextClass?.date else { return }
        selectedClassDates.remove(calendar.startOfDay(for: nextClassDate))
        
        if classesLeft > 0 { classesLeft -= 1 }
        
        handleMiss() // تطبيق عقوبة الغياب
    }
    
    func updateCountsFromSelection() {
        let count = selectedClassDates.count
        self.requiredClasses = count
        self.classesLeft = count
    }
    
    func handleMiss() {
        consecutiveMisses += 1
        
        if consecutiveMisses >= 2 && classesCompletedStreak > 0 {
            classesCompletedStreak = max(0, classesCompletedStreak - 1)
            consecutiveMisses = 0
        }
    }
}

// MARK: - 2. الألوان والمساعدات (Helpers & Custom Views)

extension Color {
    static let primaryBackground = Color(red: 0.988, green: 0.973, blue: 0.941)
    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let cardBackground = Color(red: 0.973, green: 0.933, blue: 0.945)
    static let accentBrown = Color(red: 0.627, green: 0.322, blue: 0.176)
    static let completeButton = Color(red: 0.941, green: 0.882, blue: 0.894)
    static let customBackground = Color(red: 0xf5 / 255, green: 0xe8 / 255, blue: 0xd0 / 255)
    static let offWhiteBackground = Color(red: 0xFF / 255, green: 0xF7 / 255, blue: 0xE6 / 255)
    static let accentBackgroundNew = Color(red: 0xEE / 255, green: 0xD2 / 255, blue: 0xD2 / 255)
    static let primaryAccent = Color(red: 0.55, green: 0.35, blue: 0.45)
    static let faintText = Color(.systemGray3)
    static let userCardObjective = Color(red: 0.937, green: 0.937, blue: 0.937)
    static let userCardLevel = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let screenBackground = Color(red: 0.96, green: 0.94, blue: 0.89)
    static let darkBrown = Color(red: 0.28, green: 0.22, blue: 0.18)
    static let midBrown = Color(red: 0.69, green: 0.60, blue: 0.50)

    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0; Scanner(string: s).scanHexInt64(&rgb)
        self.init(red: Double((rgb >> 16) & 0xFF) / 255.0, green: Double((rgb >>  8) & 0xFF) / 255.0, blue: Double( rgb & 0xFF) / 255.0)
    }
}

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

@ViewBuilder
private func baseCard(title: String, isSelected: Bool, onTap: @escaping () -> Void, extraRightPadding: CGFloat) -> some View {
    let cardColor = Color(hex: "FFF7E6")
    let cardHeight: CGFloat = 100
    
    HStack { Text(title).font(.headline).foregroundStyle(.black); Spacer(minLength: 0) }
    .contentShape(Rectangle()).onTapGesture(perform: onTap).padding(.leading, 16).padding(.trailing, 16 + extraRightPadding).frame(height: cardHeight)
    .background(cardColor).cornerRadius(12).shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    .overlay(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(isSelected ? 0.18 : 0.0)))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.black.opacity(0.35) : .clear, lineWidth: 1))
}


// MARK: - 3. الواجهة الرئيسية الحاضنة (ContentView)

struct MainAppRootView: View {
    @StateObject var appData = AppData()
    
    // لتعيين لون سهم العودة (Arrow Back)
    init() {
        UINavigationBar.appearance().tintColor = UIColor.black // تعيين لون الأسهم في NavigationStack إلى الأسود
    }
    
    var body: some View {
        NavigationStack {
            SplashScreenUIView()
        }
        .environmentObject(appData)
        // تعيين اللون البنفسجي للعناصر النشطة في شريط التبويب
        .tint(Color.primaryAccent)
    }
}

// MARK: - 4. شاشات الإعداد الأولي (Level Selection Flow)

struct LevelSelectionView: View {
    @AppStorage("selectedLevel") private var selectedLevel = ""
    private let backgroundColor = Color.primaryBackground
    private let imageSize:  CGFloat = 115
    private let imageRightPadding: CGFloat = 12

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Level").font(.system(.largeTitle, design: .serif)).navigationTitle("").navigationBarTitleDisplayMode(.inline)
            
            baseCard(title: "Flow Easy", isSelected: selectedLevel == "Flow Easy", onTap: { selectedLevel = "Flow Easy" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("flow").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)
            baseCard(title: "Core Active", isSelected: selectedLevel == "Core Active", onTap: { selectedLevel = "Core Active" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("core").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)
            baseCard(title: "Power Sculpt", isSelected: selectedLevel == "Power Sculpt", onTap: { selectedLevel = "Power Sculpt" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("power").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)

            Spacer()

            HStack {
                Spacer()
                NavigationLink {
                    ObjectiveSelectionView(level: selectedLevel)
                } label: {
                    Image(systemName: "arrow.right").font(.system(size: 22, weight: .bold)).foregroundStyle(.black).padding(14).background(Color.white).clipShape(Circle()).shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }.disabled(selectedLevel.isEmpty).opacity(selectedLevel.isEmpty ? 0.4 : 1.0)
            }
        }.padding(24).background(backgroundColor.ignoresSafeArea())
    }
}

// شاشة اختيار الهدف
struct ObjectiveSelectionView: View {
    @AppStorage("selectedObjective") private var selectedObjective = ""
    let level: String
    private let backgroundColor = Color.primaryBackground
    private let imageSize:  CGFloat = 115
    private let imageRightPadding: CGFloat = 12

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Objective").font(.system(.largeTitle, design: .serif)).navigationTitle("").navigationBarTitleDisplayMode(.inline)

            baseCard(title: "Physical", isSelected: selectedObjective == "Physical", onTap: { selectedObjective = "Physical" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("physical").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)
            baseCard(title: "Mental", isSelected: selectedObjective == "Mental", onTap: { selectedObjective = "Mental" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("mental").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)
            baseCard(title: "Both", isSelected: selectedObjective == "Both", onTap: { selectedObjective = "Both" }, extraRightPadding: imageSize + imageRightPadding).overlay(Image("both").resizable().scaledToFit().frame(width: imageSize, height: imageSize), alignment: .trailing).padding(.trailing, imageRightPadding)

            Spacer()
            HStack { Spacer()
                NavigationLink { MainAppTabsView(userLevel: level, userObjective: selectedObjective) } label: {
                    Image(systemName: "arrow.right").font(.system(size: 22, weight: .bold)).foregroundStyle(.black).padding(14).background(Color.white).clipShape(Circle()).shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                }.disabled(selectedObjective.isEmpty).opacity(selectedObjective.isEmpty ? 0.4 : 1.0)
            }
        }.padding(24).background(backgroundColor.ignoresSafeArea())
    }
}

// شاشة البداية - مع الحركة الجديدة
struct SplashScreenUIView: View {
    
    // حالة للحركة: تجعل الرِجل ترتفع وتنخفض
    @State private var legOffset: CGFloat = 0
    
    private let screenBackground = Color.screenBackground
    private let darkBrown = Color.darkBrown
    
    var body: some View {
        ZStack {
            screenBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // العنوان
                Text("Pila-Me")
                    .font(.custom("Palatino-Italic", size: 40))
                    .foregroundColor(darkBrown)
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                
                // الصورة المتحركة
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 400) // الحجم الذي اخترته
                    // تطبيق الحركة على Offset الرأسي
                    .offset(y: 20 + legOffset)
                    .onAppear {
                        // بدء الحركة بمجرد ظهور الشاشة
                        withAnimation(
                            .easeInOut(duration: 2.5)
                            .repeatForever(autoreverses: true)
                        ) {
                            legOffset = 25
                        }
                    }
                
                // 🛑 هذا هو التعديل الأساسي لرفع النص 🛑
                Spacer().frame(height: 10)
                
                // زر الدخول الجديد
                NavigationLink { LevelSelectionView() } label: {
                    BottomContentLayer()
                        .frame(height: 180)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// Bottom Content Block - تصميم أكثر نظافة
struct BottomContentLayer: View {
    private let darkBrown = Color.darkBrown
    private let cardColor = Color.screenBackground
    let cardCornerRadius: CGFloat = 40
    
    var body: some View {
        ZStack {
            // البطاقة الخلفية
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .fill(cardColor)
                .frame(height: 180)
                .padding(.horizontal, 20)
                .shadow(color: darkBrown.opacity(0.3), radius: 5, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 5) {
                
                // الرسالة
                Text("You're doing your best,\nkeep going")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(darkBrown)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5)
                
                // زر الدخول الرئيسي
                HStack {
                    Text("Start your journey")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.midBrown)
                .cornerRadius(15)
                .padding(.top, 10)
                
            }
            .padding(.horizontal, 40)
        }
    }
}


// MARK: - 5. شاشات التتبع والتقويم (Main App Tabs)

// الهيكل الذي يحمل الـ TabView
struct MainAppTabsView: View {
    @EnvironmentObject var appData: AppData
    @State private var selectedTab = 0
    
    let userLevel: String
    let userObjective: String
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // شاشة التتبع (التاب الأول)
            MainPageUIview(userObjective: userObjective, userLevel: userLevel)
                .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            
            // شاشة إضافة الكلاسات (التاب الثاني)
            AddClassesUIView()
                .tabItem { Label("Calendar", systemImage: "calendar.badge.plus") }.tag(1) // تم تغيير الاسم إلى Calendar
        }
        .navigationBarBackButtonHidden(true)
    }
}


// MainPageUIview (صفحة التتبع)
struct MainPageUIview: View {
    @EnvironmentObject var appData: AppData
    
    let userObjective: String
    let userLevel: String

    var body: some View {
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    HeaderView()
                    
                    UserInfoCards(objective: userObjective, level: userLevel)
                    
                    ClassesLeftCard()
                    
                    // استخدام UpcomingClassesSection مع خيارين للإكمال/التخطي
                    UpcomingClassesSection(
                        nextClass: appData.nextClass,
                        completeAction: { appData.completeNextClass() },
                        skipAction: { appData.skipNextClass() }
                    )
                    
                    // استخدام الـ NavigationLink حول الوردة
                    NavigationLink(destination: StreakPage()) {
                        DynamicFlowerImage()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 20)

                }.padding(.horizontal)
            }
        }
    }
}

// مكونات فرعية لـ MainPageUIview
struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Hello!").font(.largeTitle).fontWeight(.bold).foregroundColor(Color.darkBrown)
            Spacer()
        }.padding(.top, 10)
    }
}

struct UserInfoCards: View {
    let objective: String
    let level: String
    
    var body: some View {
        HStack(spacing: 0) {
            // بطاقة الهدف
            InfoCard(title: "Your Objective", value: objective, backgroundColor: Color.userCardObjective)
                .padding(.trailing, -0.5)
            
            // بطاقة المستوى
            InfoCard(title: "Your level of actvitity", value: level, backgroundColor: Color.userCardLevel)
                .padding(.leading, -0.5)
        }
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        .padding(.horizontal, 5)
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.gray)
            Text(value).font(.headline).fontWeight(.medium).foregroundColor(Color.darkBrown)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(15).background(backgroundColor)
    }
}

struct ClassesLeftCard: View {
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 5).frame(width: 60, height: 60)
                Text("\(appData.classesLeft)").font(.system(size: 38, weight: .bold)).foregroundColor(Color.darkBrown)
            }.padding(.leading, 5)

            VStack(alignment: .leading, spacing: 5) {
                Text("Class Left").font(.title2).fontWeight(.semibold).foregroundColor(Color.darkBrown)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill").foregroundColor(Color.gray.opacity(0.5)).font(.title2).padding(.trailing, 10)

        }
        .padding(.vertical, 25)
        .padding(.horizontal, 20)
        .background(Color.cardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// تم تعديل هذا الـ Struct ليدعم دالة Skip الجديدة
struct UpcomingClassesSection: View {
    let nextClass: ClassItem?
    var completeAction: () -> Void
    var skipAction: () -> Void

    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Upcaming Class").font(.title2).fontWeight(.bold).foregroundColor(Color.darkBrown)
            
            if let nextClass = nextClass {
                ClassRow(item: nextClass, completeAction: completeAction, skipAction: skipAction)
            } else {
                Text("No upcoming classes scheduled. Please add classes from the 'Add Classes' tab.").foregroundColor(.gray).padding().background(Color.white).cornerRadius(15)
            }
        }.padding(.bottom, 20)
    }
}

// تم تعديل ClassRow ليحتوي على زري Complete و Skip
struct ClassRow: View {
    let item: ClassItem
    var completeAction: () -> Void
    var skipAction: () -> Void

    
    private func getFormattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Daily Pilates Flow").font(.body).foregroundColor(Color.darkBrown)
                
                // عرض التاريخ
                Text(getFormattedDate(from: item.date)).font(.caption).foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                
                // 1. زر Skip (تخطي) - شكل كبسولي وإطار أحمر ناعم
                Button(action: skipAction) {
                    Text("Skip")
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding(.vertical, 5).padding(.horizontal, 2)
                        .background(Color.white)
                        .overlay(
                            Capsule().stroke(Color.red.opacity(2), lineWidth: 0.25)
                        )
                        .clipShape(Capsule()) // شكل دائري كامل
                }.buttonStyle(PlainButtonStyle())
                
                // 2. زر Complete (إكمال) - شكل كبسولي وإطار بنفسجي بارز
                Button(action: completeAction) {
                    Text("Complete")
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundColor(Color.primaryAccent) // لون النص بنفسجي
                        .padding(.vertical, 5).padding(.horizontal, 2)
                        .background(Color.white)
                        .overlay(
                            Capsule().stroke(Color.primaryAccent, lineWidth: 2.0)
                        )
                        .clipShape(Capsule()) // شكل دائري كامل
                }.buttonStyle(PlainButtonStyle())
                
            }
            
        }.padding(15).background(Color.userCardLevel).cornerRadius(15).shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

struct DynamicFlowerImage: View {
    @EnvironmentObject var appData: AppData
    
    // 🚀 يمكنك تعديل قيمة الإزاحة اليدوية هنا، مثلاً:
    // - إذا كانت تميل لليسار، زد القيمة (مثل: 5, 8, 10)
    // - إذا كانت تميل لليمين، أنقص القيمة أو اجعلها سالبة (مثل: 0, -5)
    let horizontalOffset: CGFloat = 15
    
    private var flowerImageName: String {
        // يعتمد على الـ Streak المحسوب (30 يومًا)
        let completed = appData.classesCompletedStreak
        
        if completed >= 15 { return "flower4" }
        else if completed >= 10 { return "flower3" }
        else if completed >= 5 { return "flower2" }
        else if completed >= 1 { return "flower1" }
        else { return "flower1" }
    }
    
    var body: some View {
        Image(flowerImageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 200, maxHeight: 200) // نحدد حجم الصورة الأقصى
            .opacity(0.7)
            .padding(.top, 40)
            // 🚀 التعديل: نطلب من الإطار النهائي أن يمتد لأقصى عرض متاح (لضمان التوسيط) 🚀
            .frame(maxWidth: .infinity, alignment: .center)
            // 🎯 تطبيق الإزاحة اليدوية 🎯
            .offset(x: horizontalOffset, y: 0)
            .animation(.easeInOut(duration: 0.5), value: flowerImageName)
    }
}



// MARK: - 6. شاشة التقدم (StreakPage)

// MARK: - 6. شاشة التقدم (StreakPage)

// MARK: - 6. شاشة التقدم (StreakPage)

struct StreakPage: View {
    @EnvironmentObject var appData: AppData
    
    // 🚀 يمكنك تعديل قيمة الإزاحة اليدوية هنا 🚀
    // (5) تدفعها 5 نقاط إلى اليمين لتعويض الانحراف
    let horizontalOffset: CGFloat = 15
    
    private var flowerImageName: String {
        let completed = appData.classesCompletedStreak
        
        if completed >= 15 { return "flower4" }
        else if completed >= 10 { return "flower3" }
        else if completed >= 5 { return "flower2" }
        else if completed >= 1 { return "flower1" }
        else { return "flower1" }
    }

    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer(minLength: 80)
                
                Text("Total Classes Attended")
                    .font(.custom("Times New Roman", size: 25))
                    .foregroundColor(Color.darkBrown)
                    .padding(.bottom, 30)
                
                // الدائرة والعداد
                ZStack {
                    Circle()
                        .fill(Color.customBackground)
                        .overlay(Circle().stroke(Color.darkBrown.opacity(0.1), lineWidth: 1))
                        .shadow(color: Color.darkBrown.opacity(0.2), radius: 5, x: 0, y: 0)
                    
                    Text("\(appData.totalLifetimeClasses())")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(Color.darkBrown)
                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 1, y: 1)
                }
                .frame(width: 180, height: 180)
                .padding(.bottom, 30)

                Text("classes")
                    .font(.custom("Times New Roman", size: 25))
                    .foregroundColor(Color.darkBrown)
                    .padding(.bottom, 50)
                
                // 🌸 الصورة مع التعديل اليدوي 🌸
                Image(flowerImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // الحجم الذي طلبته
                    .opacity(0.7) // الشفافية التي طلبتها
                    .padding(.top, 50) // المسافة العلوية التي طلبتها
                    .frame(maxWidth: .infinity, alignment: .center) // ضمان التوسيط الأولي
                    // 🎯 تطبيق الإزاحة اليدوية 🎯
                    .offset(x: horizontalOffset, y: 1)
                    .animation(.easeInOut(duration: 0.5), value: flowerImageName)
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Your Streak")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/// MARK: - 7. شاشات التقويم (AddClassesUIView)
struct AddClassesUIView: View {
    @EnvironmentObject var appData: AppData
    
    @State private var currentMonth: Date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()
    
    let daysOfWeek: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let calendar = Calendar.current
    
    // 💡 تم تغيير المتغير ليعكس الخلفية الموحدة الفاتحة 💡
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
    
    private func toggleDateSelection(date: Date) {
        let dayStart = calendar.startOfDay(for: date)
        
        if appData.selectedClassDates.contains(dayStart) {
            appData.selectedClassDates.remove(dayStart)
        } else {
            appData.selectedClassDates.insert(dayStart)
        }
    }

    private func unselectAllDates() {
        appData.selectedClassDates.removeAll()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            // 💡 توحيد الخلفية العلوية والسفلية باللون الفاتح 💡
            mainBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 125)
                
                // 💡 إزالة الخلفية السفلية الداكنة والاعتماد على خلفية الـ ZStack 💡
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
                        Text("Selected Classes: \(appData.selectedClassDates.count)")
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
                            // 💡 استخدام لون خلفية فاتح بديل للزر 💡
                            .background(Color.primaryBackground) // تم التغيير إلى primaryBackground
                            .cornerRadius(10)
                        }
                        .opacity(appData.selectedClassDates.isEmpty ? 0 : 1)
                        .animation(.easeOut(duration: 0.2), value: appData.selectedClassDates.isEmpty)
                    }
                    .padding(.horizontal, 25)
                    
                }
                .padding(.vertical, 25)
                // 💡 استخدام خلفية فاتحة لبطاقة التقويم 💡
                .background(Color.primaryBackground) // تم التغيير إلى primaryBackground
                .cornerRadius(30)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
                
                Button(action: {
                    appData.updateCountsFromSelection()
                    print("Selected Classes confirmed: \(appData.selectedClassDates.count)")
                }) {
                    Text("Confirm Selection ")
                        .font(.headline)
                        .fontWeight(.bold)
                        // 💡 تغيير لون النص ليتناسب مع الخلفية البنفسجية 💡
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryAccent)
                        .cornerRadius(15)
                        .shadow(color: Color.primaryAccent.opacity(0.4), radius: 8, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
}

// 💡 تم تحديث DateCell لاستخدام اللون الموحد 💡
struct DateCell: View {
    let date: Date
    @Binding var selectedDates: Set<Date>
    let toggleDateSelection: (Date) -> Void
    let calendar: Calendar
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    private var isSelected: Bool {
        selectedDates.contains(calendar.startOfDay(for: date))
    }
    
    var body: some View {
        Button(action: {
            toggleDateSelection(date)
        }) {
            Text("\(dayNumber)").font(.body).fontWeight(.regular).frame(width: 35, height: 35)
                .background(
                    Group {
                        // 💡 استخدام اللون البنفسجي كلون خلفية عند الاختيار 💡
                        if isSelected { Circle().fill(Color.primaryAccent.opacity(0.15)) } else { EmptyView() }
                    }
                ).foregroundColor(isSelected ? .primaryAccent : Color(white: 0.3))
        }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppRootView()
    }
}
