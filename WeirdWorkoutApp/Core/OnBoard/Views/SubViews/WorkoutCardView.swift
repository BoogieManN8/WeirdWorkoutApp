import SwiftUI

struct WorkoutCardView: View {
    let bounds = UIScreen.main.bounds
    let image: String
    let title: String
    let numberOfExercies: Int
    let description: String?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.theme.blue)
                .frame(width: bounds.width * 0.9, height: 80)
                
            HStack (alignment: .top) {
                if let encodedImageString = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let imageURL = URL(string: encodedImageString) {
                    AsyncImage(url: imageURL) {
                        ProgressView()
                    }
                    .scaledToFill()
                    .frame(width: 70, height: 60)
                    .cornerRadius(12)
                    .clipped()
                }
                
                
                VStack (alignment: .leading, spacing: 10) {
                    Text("\(title)")
                        .foregroundColor(.white)
                        .font(.theme.bold(18))
                    
                    if let description = description {
                        Text("\(description)")
                            .foregroundColor(.gray)
                            .font(.theme.semiBold(16))
                    } else {
                        Text("\(numberOfExercies) Exercises")
                            .foregroundColor(.gray)
                            .font(.theme.semiBold(16))
                    }
                    
                }
                
                Spacer()
            }
            .padding(.leading, 20)
            
        }
        .frame(width: bounds.width * 0.9, height: 80)
        
    }
}

#Preview {
    WorkoutCardView(image: "https://barbend.com/wp-content/uploads/2023/06/push-up-barbend.com_-1.jpg", title: "Exercise for strength", numberOfExercies: 28, description: "")
    
}
