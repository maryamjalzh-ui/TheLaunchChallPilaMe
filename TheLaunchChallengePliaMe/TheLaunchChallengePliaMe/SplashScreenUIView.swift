//
//  SplashScreenUIView.swift
//  TheLaunchChallengePliaMe
//
//  Created by Danah AlQahtani on 10/04/1447 AH.
//

//
//  SplashScreenIView.swift
//  TheLaunchChallengePliaMe
//
//  Created by Danah AlQahtani on 10/04/1447 AH.
//

import SwiftUI


    struct SplashScreenUIView: View {
        // الألوان بالـ RGB لـ (F5F0E3) و (47382F)
        private let screenBackground = Color(red: 0.96, green: 0.94, blue: 0.89) // #F5F0E3
        private let darkBrown = Color(red: 0.28, green: 0.22, blue: 0.18)      // #47382F
        private let midBrown = Color(red: 0.69, green: 0.60, blue: 0.50)       // لون بني وسط جديد للعناصر المنحنية
        
        var body: some View {
            ZStack {
                // 1. Full Screen Background
                screenBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 2. Title
                    Text("Pila-Me")
                        .font(.custom("Palatino-Italic", size: 40))
                        .foregroundColor(darkBrown)
                        .padding(.top, 50)
                        .padding(.bottom, 30)
                    
                    // 3. Main Graphic (تمت إعادتها)
                    // تأكد من أن اسم الصورة هو "logo" أو "main_graphic" حسب اسم الملف لديك
                    Image("logo") // غير "logo" إلى اسم ملف الصورة لديك
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                        .offset(y: 50) // تعديل الإزاحة لوضعها في مكانها الصحيح فوق الانحناء
                    
                    // 4. Pushes content up to make space for the bottom card
                    Spacer()
                    
                    // 5. Bottom Content Section
                    BottomContentLayer()
                        .frame(height: 200) // التحكم في ارتفاع الكتلة السفلية بأكملها
                }
            }
        }
    }
    
    // --- Bottom Content Block (تم إصلاح الطبقات والخلفية) ---
    struct BottomContentLayer: View {
        private let darkBrown = Color(red: 0.28, green: 0.22, blue: 0.18)
        private let midBrown = Color(red: 0.69, green: 0.60, blue: 0.50)
        private let cardColor = Color(red: 0.96, green: 0.94, blue: 0.89)
        let cardCornerRadius: CGFloat = 40
        
        var body: some View {
            // ZStack لجعل النص والأيقونة في المقدمة
            ZStack(alignment: .bottom) {
                
                // الطبقة الخلفية (الـ RoundedRectangle لضمان الأبعاد الصحيحة)
                // هذه الطبقة هي التي تعطي شكل البطاقة البيج الفاتح
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .fill(cardColor)
                    .frame(height: 180) // ارتفاع البطاقة نفسها
                    .padding(.horizontal, 20)
                    .shadow(color: darkBrown.opacity(0.3), radius: 5, x: 0, y: 5)
                
                // صورة الانحناء العلوي (يجب أن تحتوي هذه الصورة على الانحناءات البنية فقط بخلفية شفافة)
                // تم تغيير اسمها من "logopilame" إلى "bottom_curves" لتكون أكثر وضوحًا
                Image("") // غير "logopilame" إلى اسم ملف الصورة لديك الذي يحتوي على الانحناءات
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150) // ارتفاع أكبر لضمان عدم الاقتصاص
                    .offset(y: -150) // إزاحتها للأعلى لتظهر كطبقة علوية فوق البطاقة
                    .padding(.horizontal, 20)
                
                // النص والسهم (في المقدمة دائمًا)
                VStack {
                    HStack {
                        Text("You're doing your best,\nkeep going")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(darkBrown)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.title2)
                            .fontWeight(.regular)
                            .foregroundColor(darkBrown)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40) // Spacing from the very bottom
                }
            }
        }
    }

#Preview {
    SplashScreenUIView()
}
