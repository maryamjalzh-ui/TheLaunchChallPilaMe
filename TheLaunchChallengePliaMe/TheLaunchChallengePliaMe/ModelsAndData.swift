//
//  ModelsAndData.swift
//  TheLaunchChallengePliaMe
//
//  Created by lamess on 14/04/1447 AH.
//

//// MARK: - 1. ModelsAndData.swift

// MARK: - 1. ModelsAndData.swift

import SwiftUI
import Combine

struct ClassItem: Identifiable {
    let id = UUID()
    let name: String
    let isCompleted: Bool
    let date: Date
}

class AppData: ObservableObject {
    
    @Published var selectedClassDates: Set<Date> = Set()
    @Published var classesLeft: Int = 0
    @Published var requiredClasses: Int = 0
    
    // بيانات الـ Streak
    @Published var classesCompletedStreak: Int = 0
    @Published var consecutiveMisses: Int = 0
    
    // 🚨 الخاصية الجديدة لتعقب التخطي (مفتاح تصغير الوردة) 🚨
    @Published var hasSkippedStreak: Bool = false
    
    // سجل الحضور الدائم
    @Published var attendedDates: [Date] = []

    private let calendar = Calendar.current
    
    init() {
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
    
    func totalLifetimeClasses() -> Int {
        return attendedDates.count
    }

    // دالة إكمال الكلاس (Complete)
    func completeNextClass() {
        guard let nextClassDate = nextClass?.date else { return }
        let classDate = calendar.startOfDay(for: nextClassDate)
        
        attendedDates.append(classDate)
        selectedClassDates.remove(classDate)
        
        if classesLeft > 0 { classesLeft -= 1 }
        
        classesCompletedStreak += 1
        consecutiveMisses = 0
        
        // 💡 إلغاء حالة التخطي عند إكمال كلاس بنجاح
        if classesCompletedStreak >= 1 {
            hasSkippedStreak = false
        }
    }
    
    // دالة تخطي الكلاس (Skip) - تم التعديل
    func skipNextClass() {
        guard let nextClassDate = nextClass?.date else { return }
        selectedClassDates.remove(calendar.startOfDay(for: nextClassDate))
        
        if classesLeft > 0 { classesLeft -= 1 }
        
        // 🛑 التعديل الأول: تعيين حالة التخطي إلى true فوراً (لتصغير الوردة)
        hasSkippedStreak = true
        
        handleMiss()
    }
    
    func updateCountsFromSelection() {
        let count = selectedClassDates.count
        self.requiredClasses = count
        self.classesLeft = count
    }
    
    // 🛑 دالة handleMiss() - تم التعديل لجعل التخطي الواحد يكسر الـ Streak 🛑
    func handleMiss() {
        consecutiveMisses += 1
        
        // إذا كان هناك تخطي (miss) واحد أو أكثر وكان هناك Streak موجود:
        if consecutiveMisses >= 1 && classesCompletedStreak > 0 {
            // كسر الـ Streak بالكامل للعودة إلى 0 عند أول تخطي
            classesCompletedStreak = 0
        }
    }
}
