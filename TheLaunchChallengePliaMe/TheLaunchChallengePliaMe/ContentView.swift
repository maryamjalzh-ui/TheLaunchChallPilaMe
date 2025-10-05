
//
// ContentView.swift
// يحتوي على: struct ContentView
// الوظيفة: نقطة البداية التي تقوم بإنشاء AppData وNavigationStack
//
import SwiftUI

struct ContentView: View {
    // إنشاء AppData مرة واحدة وتمريرها عبر البيئة
    @StateObject var appData = AppData()
    
    var body: some View {
        NavigationStack {
            // يبدأ من شاشة البداية
            SplashScreenUIView()
        }
        // يجعل AppData متاحاً لجميع المشاهدات الفرعية
        .environmentObject(appData)
    }
}
