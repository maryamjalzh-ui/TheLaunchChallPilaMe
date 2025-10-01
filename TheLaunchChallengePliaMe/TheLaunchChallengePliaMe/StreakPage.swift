//
//  StreakPage.swift
//  TheLaunchChallengePliaMe
//
//  Created by Elham Alhemidi on 09/04/1447 AH.
//

//
//  ContentView.swift
//  Pila-me-project
//
//  Created by Elham Alhemidi on 06/04/1447 AH.
//

import SwiftUI

struct StreakPage: View {
    @State private var classesCompleted: Int = 0

    var body: some View {
        ZStack {
            Color(red: 1.0, green: 247.0/255.0, blue: 230.0/255.0)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer(minLength: 80)
                Text("You‘ve attended")
                    .font(.custom("Times New Roman", size: 25))
                    .foregroundColor(.black)
                    .padding(.bottom, 30)
              
                ZStack {
                   Circle()
                       .fill(Color(red: 245.0/255.0, green: 232.0/255.0, blue: 208.0/255.0))
                       .padding(.bottom, 30)
                   
                   Text("\(classesCompleted)")
                       .font(.system(size: 40, weight: .bold))
                       .foregroundColor(.black)
                       .padding(.bottom, 10)
                }
                
        
                Text("classes")
                    .font(.custom("Times New Roman", size: 25))
                    .foregroundColor(.black)
                    .padding(.bottom, 100)
                
                Image("flower4")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                    .opacity(0.9)
                    .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    StreakPage()
}
