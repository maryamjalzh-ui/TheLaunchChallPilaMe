//
//  StreakViews.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//

// MARK: - 5. StreakViews.swift

import SwiftUI

struct DynamicFlowerImage: View {
    @EnvironmentObject var appData: AppData
    
    // 🚀 الإزاحة الأفقية الوحيدة التي تحتاجها
    let horizontalOffset: CGFloat = 15

    // --- الدوال المساعدة للحجم والاسم (لم تتغير) ---
    
    private func sizeForStreak(completed: Int) -> CGFloat {
            
            // 1. 🚨 تم خفض الحجم الأساسي لـ flower1 ليصبح أصغر 🚨
            let baseSize: CGFloat = 130
            
            // 2. 🚀 تم زيادة الفارق لتصبح flower2 أكبر بـ 30 نقطة 🚀
            let sizeIncrement: CGFloat = 50

            if completed >= 15 {
                // Flower 4
                return baseSize + (sizeIncrement * 4) // 180 + 120 = 300
            }
            else if completed >= 10 {
                // Flower 3
                return baseSize + (sizeIncrement * 2) // 180 + 60 = 240
            }
            else if completed >= 5 {
                // Flower 2 (أكبر بشكل واضح من flower1)
                return baseSize + sizeIncrement // 180 + 30 = 210
            }
            else {
                // Flower 1
                return baseSize // 180
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
            
            // 1. تثبيت الأبعاد الموحدة
            .frame(width: currentSize, height: currentSize)
            
            // 2. 🚨 التعديل الرئيسي: تثبيت الأبعاد النهائية للحاوية 🚨
            // نستخدم هذا الإطار لتثبيت المساحة التي تشغلها الوردة بالكامل (على سبيل المثال 350x350)
            .frame(width: 350, height: 350)
            .contentShape(Rectangle()) // تثبيت مساحة التفاعل
            .clipped() // لضمان عدم خروج أي جزء من الصورة عن هذا الإطار
            
            .opacity(0.7)
            .animation(.easeInOut(duration: 0.5), value: name)
            .animation(.easeInOut(duration: 0.5), value: currentSize)
        
        // 3. التوسيط على مستوى الشاشة
        .frame(maxWidth: .infinity, alignment: .center)
        
        // 4. 🚀 الإزاحة الأفقية فقط (إذا كانت مطلوبة) 🚀
        // قد تحتاج إلى تعديل (Y: -30) لرفع الكتلة للأعلى لتعويض الـ Padding الذي أزلناه
        .offset(x: horizontalOffset, y: -40)
    }
}

// MARK: - 6. شاشة التقدم (StreakPage)

struct StreakPage: View {
    @EnvironmentObject var appData: AppData
    
    // 🚀 الإزاحة الأفقية الوحيدة التي تحتاجها
    let horizontalOffset: CGFloat = 15
    
    // 🚨 الإزاحة العمودية الثابتة لرفع الكتلة للأعلى لتعويض الـ Padding الذي أزلناه 🚨
    let verticalOffsetCorrection: CGFloat = 40

    // --- الدوال المساعدة للحجم والاسم (من الكود النهائي) ---
    
    private func sizeForStreak(completed: Int) -> CGFloat {
        // baseSize: 130, sizeIncrement: 50
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
        
        // حساب الحجم الحالي في بداية الـ body
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
                
                // 🌸 الصورة مع التعديل لتطبيق الأحجام الديناميكية وثبات الموقع 🌸
                Image(name)
                    .resizable()
                    .scaledToFit()
                    
                    // 1. تطبيق الحجم الديناميكي الجديد
                    .frame(width: currentSize, height: currentSize)
                    
                    // 2. تثبيت الحاوية (مهم جداً لثبات الموقع لـ flower4)
                    .frame(width: 350, height: 350)
                    .contentShape(Rectangle())
                    .clipped()
                    
                    .opacity(0.7)
                    .animation(.easeInOut(duration: 0.5), value: name)
                    .animation(.easeInOut(duration: 0.5), value: currentSize)
                    
                    // 3. التوسيط على مستوى الشاشة
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // 4. تطبيق الإزاحة النهائية (الأفقية والعمودية)
                    .offset(x: horizontalOffset, y: -verticalOffsetCorrection)
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Your Streak")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
