//
//  MainAppViews.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//

// MARK: - 4. MainAppViews.swift

import SwiftUI

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
            CalendarViews()
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
            Text("Upcaming Class").font(.title2).fontWeight(.bold).foregroundColor(Color.darkBrown) // 🛑 النص الأصلي "Upcaming Class" 🛑
            
            if let nextClass = nextClass {
                ClassRow(item: nextClass, completeAction: completeAction, skipAction: skipAction)
            } else {
                Text("No upcoming classes scheduled. Please add classes from the 'Add Classes' tab.").foregroundColor(.gray).padding().background(Color.white).cornerRadius(15)
            }
        }.padding(.bottom, 20)
    }
}


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
            
            HStack(spacing: 15) {
                
                // 1. زر Skip (تخطي)
                Button(action: skipAction) {
                    Text("Skip")
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundColor(.red)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .overlay(
                            Capsule().stroke(Color.red.opacity(2), lineWidth: 0.25)
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                
                
                // 2. زر Completed (إكمال) - تم تغيير النص
                Button(action: completeAction) {
                    Text("Complete")
                        .font(.subheadline).fontWeight(.medium)
                        .foregroundColor(Color.primaryAccent)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .background(Color.white)
                        .overlay(
                            Capsule().stroke(Color.primaryAccent, lineWidth: 2.0)
                        )
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                
            }
            // 🛑 التعديل: زيادة العرض الأقصى إلى 220 ليتناسب مع "Completed" 🛑
            .frame(maxWidth: 220)
            
        }
        .padding(15)
        .background(Color.userCardLevel)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}
