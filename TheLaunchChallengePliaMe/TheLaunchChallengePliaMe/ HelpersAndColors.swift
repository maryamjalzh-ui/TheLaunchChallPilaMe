//
//   HelpersAndColors.swift
// TheLaunchChallengePliaMe
//
// Created by lamess on 14/04/1447 AH.
//
// MARK: - 2. HelpersAndColors.swift

import SwiftUI

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
func baseCard(title: String, isSelected: Bool, onTap: @escaping () -> Void, extraRightPadding: CGFloat) -> some View {
    // 🟢 التعديل: تم تغيير اللون من "FFF7E6" إلى "F0E0C8" ليصبح أغمق قليلاً 🟢
    let cardColor = Color(hex: "F0E0C8")
    let cardHeight: CGFloat = 100
    
    HStack { Text(title).font(.headline).foregroundStyle(.black); Spacer(minLength: 0) }
    .contentShape(Rectangle()).onTapGesture(perform: onTap).padding(.leading, 16).padding(.trailing, 16 + extraRightPadding).frame(height: cardHeight)
    .background(cardColor).cornerRadius(12).shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    .overlay(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(isSelected ? 0.18 : 0.0)))
    .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.black.opacity(0.35) : .clear, lineWidth: 1))
}
