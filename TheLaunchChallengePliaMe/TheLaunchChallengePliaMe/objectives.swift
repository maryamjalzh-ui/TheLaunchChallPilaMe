import SwiftUI

// MARK: - Hex color helper
extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0; Scanner(string: s).scanHexInt64(&rgb)
        self.init(
            red:   Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >>  8) & 0xFF) / 255.0,
            blue:  Double( rgb        & 0xFF) / 255.0
        )
    }
}

// MARK: - ContentView (Your level)
struct obectives: View {
    @AppStorage("selectedLevel") private var selectedLevel = ""

    private let backgroundColor = Color(hex: "F5E8D0")
    private let cardColor       = Color(hex: "FFF7E6")

    private let cardHeight: CGFloat = 100
    private let imageSize:  CGFloat = 115
    private let imageRightPadding: CGFloat = 12

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Your Level")
                    .font(.system(.largeTitle, design: .serif))

                // Flow easy
                baseCard(title: "Flow easy",
                         isSelected: selectedLevel == "Flow easy",
                         onTap: { selectedLevel = "Flow easy" },
                         extraRightPadding: imageSize + imageRightPadding)
                .overlay(
                    Image("flow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize),
                 
                    alignment: .trailing
                )
                .padding(.trailing, imageRightPadding)

                // Core Active
                baseCard(title: "Core Active",
                         isSelected: selectedLevel == "Core Active",
                         onTap: { selectedLevel = "Core Active" },
                         extraRightPadding: imageSize + imageRightPadding)
                .overlay(
                    Image("core")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize),
                    alignment: .trailing
                )
                .padding(.trailing, imageRightPadding)

                // Power Sculpt
                baseCard(title: "Power Sculpt",
                         isSelected: selectedLevel == "Power Sculpt",
                         onTap: { selectedLevel = "Power Sculpt" },
                         extraRightPadding: imageSize + imageRightPadding)
                .overlay(
                    Image("power")
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize),
                    alignment: .trailing
                )
                .padding(.trailing, imageRightPadding)

                Spacer()

                // Arrow button
                HStack {
                    Spacer()
                    NavigationLink {
                        ObjectiveView()
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(14)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
                    }
                    .disabled(selectedLevel.isEmpty)
                    .opacity(selectedLevel.isEmpty ? 0.4 : 1.0)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 24)
            }
            .padding(24)
            .background(backgroundColor)
        }
    }

    // BaseCard reusable
    @ViewBuilder
    private func baseCard(title: String,
                          isSelected: Bool,
                          onTap: @escaping () -> Void,
                          extraRightPadding: CGFloat) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .padding(.leading, 16)
        .padding(.trailing, 16 + extraRightPadding)
        .frame(height: cardHeight)
        .background(cardColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        // ✅ Dim effect (instead of light)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(isSelected ? 0.18 : 0.0))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black.opacity(0.35) : .clear, lineWidth: 1)
        )
    }
}

// MARK: - ObjectiveView (Next screen)
struct ObjectiveView: View {
    @AppStorage("selectedObjective") private var selectedObjective = ""

    private let backgroundColor = Color(hex: "F5E8D0")
    private let cardColor       = Color(hex: "FFF7E6")

    private let cardHeight: CGFloat = 100
    private let imageSize:  CGFloat = 115
    private let imageRightPadding: CGFloat = 12

    var body: some View {
        VStack(spacing: 24) {
            Text("Your Objective")
                .font(.system(.largeTitle, design: .serif))

            baseCard(title: "Physical",
                     isSelected: selectedObjective == "Physical",
                     onTap: { selectedObjective = "Physical" },
                     extraRightPadding: imageSize + imageRightPadding)
            .overlay(
                Image("physical")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize),
                alignment: .trailing
            )
            .padding(.trailing, imageRightPadding)

            baseCard(title: "Mental",
                     isSelected: selectedObjective == "Mental",
                     onTap: { selectedObjective = "Mental" },
                     extraRightPadding: imageSize + imageRightPadding)
            .overlay(
                Image("mental")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize),
                alignment: .trailing
            )
            .padding(.trailing, imageRightPadding)

            baseCard(title: "Both",
                     isSelected: selectedObjective == "Both",
                     onTap: { selectedObjective = "Both" },
                     extraRightPadding: imageSize + imageRightPadding)
            .overlay(
                Image("both")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize),
                alignment: .trailing
            )
            .padding(.trailing, imageRightPadding)

            Spacer()
        }
        .padding(24)
        .background(backgroundColor)
    }

    @ViewBuilder
    private func baseCard(title: String,
                          isSelected: Bool,
                          onTap: @escaping () -> Void,
                          extraRightPadding: CGFloat) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundStyle(.black)
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .padding(.leading, 16)
        .padding(.trailing, 16 + extraRightPadding)
        .frame(height: cardHeight)
        .background(cardColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
        // ✅ Dim effect
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(isSelected ? 0.18 : 0.0))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.black.opacity(0.35) : .clear, lineWidth: 1)
        )
    }
}

#Preview { obectives() }
