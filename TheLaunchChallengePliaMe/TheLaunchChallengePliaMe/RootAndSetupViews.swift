//
//  RootAndSetupViews.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//

// MARK: - 3. RootAndSetupViews.swift

import SwiftUI

// MARK: - MainAppRootView

struct MainAppRootView: View {
    @StateObject var appData = AppData()
    // تم إزالة @AppStorage("hasCompletedSetup")
    
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


// MARK: - SplashScreenUIView

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

// MARK: - LevelSelectionView

struct LevelSelectionView: View {
    // تم استخدام @AppStorage للحالة المخزنة، وسنقوم بمسحها عند الظهور.
    @AppStorage("selectedLevel") private var selectedLevel = ""
    private let backgroundColor = Color.primaryBackground
    private let imageSize: CGFloat = 115
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
        }
        // **التعديل رقم 1:** مسح الاختيار عند ظهور الشاشة لضمان عدم وجود اختيار افتراضي
        .onAppear {
            selectedLevel = ""
        }
        .padding(24).background(backgroundColor.ignoresSafeArea())
    }
}

// MARK: - ObjectiveSelectionView

struct ObjectiveSelectionView: View {
    // **التعديل رقم 2:** تم تغيير @AppStorage إلى @State لكي لا يتم حفظ القيمة بشكل افتراضي
    @State private var selectedObjective = ""
    let level: String
    private let backgroundColor = Color.primaryBackground
    private let imageSize: CGFloat = 115
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
