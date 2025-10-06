//
//  StreakViews.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//

// MARK: - 5. StreakViews.swift

import SwiftUI

struct DynamicFlowerImage: View {
    @EnvironmentObject var appData: AppData
    
    // متغير حالة للتحكم في تأثير النبض
    @State private var pulse: Bool = false
    
    let horizontalOffset: CGFloat = 15

    // --- الدوال المساعدة للحجم والاسم (لم تتغير) ---
    private func sizeForStreak(completed: Int) -> CGFloat {
        let baseSize: CGFloat = 130
        let sizeIncrement: CGFloat = 50

        if completed >= 15 {
            return baseSize + (sizeIncrement * 4) // Flower 4: 330
        }
        else if completed >= 10 {
            return baseSize + (sizeIncrement * 2) // Flower 3: 230
        }
        else if completed >= 5 {
            return baseSize + sizeIncrement // Flower 2: 180
        }
        else {
            return baseSize // Flower 1: 130
        }
    }
    
    private var flowerImageName: String {
        let completed = appData.classesCompletedStreak
        if completed >= 15 { return "flower4" }
        else if completed >= 10 { return "flower3" }
        else if completed >= 5 { return "flower2" }
        else if completed >= 1 { return "flower1" }
        else { return "flower1" }
    }
    
    // --- الجسم (Body) المصحح والمُبسَّط ---

    var body: some View {
        let currentSize = sizeForStreak(completed: appData.classesCompletedStreak)
        let name = flowerImageName
        
        Image(name)
            .resizable()
            .scaledToFit()
            
            // 1. تطبيق الحجم الأصلي
            .frame(width: currentSize, height: currentSize)
            
            // 🟢 التعديل: زيادة مدى النبض لجعله أوضح (1.0 إلى 1.15) 🟢
            .scaleEffect(pulse ? 1.15 : 1.0)
            
            // 2. تثبيت الأبعاد النهائية للحاوية
            .frame(width: 350, height: 350)
            .contentShape(Rectangle())
            .clipped()
            
            .opacity(0.7)
            .animation(.easeInOut(duration: 0.1), value: currentSize)
            .animation(.easeInOut(duration: 0.1), value: name)
            
            
            // 3. التوسيط على مستوى الشاشة
            .frame(maxWidth: 350, alignment: .center)
            
            // 4. الإزاحة
            .offset(x: horizontalOffset, y: -40)
            
            // السرعة: 3.0 ثوانٍ (كما هي)
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    pulse.toggle()
                }
            }
    }
}

// MARK: - 6. شاشة التقدم (StreakPage)

struct StreakPage: View {
    @EnvironmentObject var appData: AppData
    
    let horizontalOffset: CGFloat = 15
    let verticalOffsetCorrection: CGFloat = 40

    // متغير حالة للتحكم في تأثير النبض
    @State private var pulse: Bool = false
    
    // --- الدوال المساعدة للحجم والاسم (لم تتغير) ---
    private func sizeForStreak(completed: Int) -> CGFloat {
        let baseSize: CGFloat = 130
        let sizeIncrement: CGFloat = 50

        if completed >= 15 {
            return baseSize + (sizeIncrement * 4) // Flower 4: 330
        }
        else if completed >= 10 {
            return baseSize + (sizeIncrement * 2) // Flower 3: 230
        }
        else if completed >= 5 {
            return baseSize + sizeIncrement // Flower 2: 180
        }
        else {
            return baseSize // Flower 1: 130
        }
    }
    
    private var flowerImageName: String {
        let completed = appData.classesCompletedStreak
        
        if completed >= 15 { return "flower4" }
        else if completed >= 10 { return "flower3" }
        else if completed >= 5 { return "flower2" }
        else if completed >= 1 { return "flower1" }
        else { return "flower1" }
    }

    // --- الجسم (Body) المُحدَّث ---
    var body: some View {
        
        let currentSize = sizeForStreak(completed: appData.classesCompletedStreak)
        let name = flowerImageName
        
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
                
                // 🌸 الصورة مع التعديل 🌸
                Image(name)
                    .resizable()
                    .scaledToFit()
                    
                    // 1. تطبيق الحجم الديناميكي الجديد
                    .frame(width: currentSize, height: currentSize)
                    
                    // 🟢 التعديل: زيادة مدى النبض لجعله أوضح (1.0 إلى 1.15) 🟢
                    .scaleEffect(pulse ? 1.15 : 1.0)
                    
                    // 2. تثبيت الحاوية
                    .frame(width: 350, height: 350)
                    .contentShape(Rectangle())
                    .clipped()
                    
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 0.1), value: name)
                    .animation(.easeInOut(duration: 0.1), value: currentSize)
                    
                    // 3. التوسيط على مستوى الشاشة
                    .frame(maxWidth: 350, alignment: .center)
                    
                    // 4. تطبيق الإزاحة
                    .offset(x: horizontalOffset, y: -verticalOffsetCorrection)
                    
                    // السرعة: 3.0 ثوانٍ (كما هي)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                            pulse.toggle()
                        }
                    }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Your Streak")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
