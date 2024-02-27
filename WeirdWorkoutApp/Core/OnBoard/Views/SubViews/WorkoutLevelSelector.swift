import SwiftUI



struct WorkoutLevelSelector: View {
    @Namespace private var animationNamespace
    @Binding var activeWorkoutLevel: Int
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<3) { level in
                    Button(action: {
                        withAnimation {
                            activeWorkoutLevel = level
                        }
                    }, label: {
                        Text(levelText(for: level))
                            .padding(.vertical, 12)
                            .padding(.horizontal)
                            .foregroundColor(activeWorkoutLevel == level ? .theme.darkBlue : .white)
                            .font(.system(size: 18, weight: .semibold))
                            .background(
                                ZStack {
                                    if activeWorkoutLevel == level {
                                        Capsule()
                                            .fill(Color.white)
                                            .matchedGeometryEffect(id: "backgroundCapsule", in: animationNamespace)
                                            .padding(.horizontal, level == 2 ? -30 : -2)
                                    }
                                }
                            )
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
            }
            .background(Capsule().fill(Color.theme.darkBlue).frame(height: 44))
            .padding()
            
            HStack(spacing: 80) {
                HStack {
                    Text("+1")
                        .font(.theme.semiBold(18))
                        .foregroundColor(.theme.yellow)
                    Image("trophy")
                }
                .opacity(activeWorkoutLevel == 0 ? 1 : 0.6)
                
                HStack {
                    Text("+2")
                        .font(.theme.semiBold(18))
                        .foregroundColor(.theme.yellow)
                    Image("trophy")
                }
                .opacity(activeWorkoutLevel == 1 ? 1 : 0.6)
                
                HStack {
                    Text("+3")
                        .font(.theme.semiBold(18))
                        .foregroundColor(.theme.yellow)
                    Image("trophy")
                }
                .opacity(activeWorkoutLevel == 2 ? 1 : 0.6)
                
            }
        }
        
    }
    
    func levelText(for level: Int) -> String {
        switch level {
        case 0: return "Beginner"
        case 1: return "Medium"
        case 2: return "Pro"
        default: return ""
        }
    }
}
