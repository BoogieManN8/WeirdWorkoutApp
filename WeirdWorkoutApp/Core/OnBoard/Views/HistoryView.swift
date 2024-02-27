import Foundation
import SwiftUI

struct HistoryView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: OnBoardViewModel
    let bounds = UIScreen.main.bounds
    var groupedWorkouts: [Date: [WorkoutModel]] {
        let grouped = Dictionary(grouping: viewModel.historyData) { workout in
            (workout.createdAt ?? Date()).startOfDay()
        }
        return grouped
    }
    
    var groupedHistoryData: [String: [WorkoutModel]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let grouped = Dictionary(grouping: viewModel.historyData) { workout -> String in
            guard let createdAt = workout.createdAt else { return "Unknown Date" }
            return dateFormatter.string(from: createdAt)
        }
        return grouped
    }
    
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue
                .ignoresSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(groupedHistoryData.keys.sorted().reversed(), id: \.self) { dateString in
                        Section(header: Text(dateString).foregroundColor(.gray).font(Font.theme.semiBold)) {
                            ForEach(groupedHistoryData[dateString] ?? [], id: \.id) { workout in
                                WorkoutCardView(
                                    image: "http://62.72.18.243:5000/\(workout.image)",
                                    title: workout.name,
                                    numberOfExercies: 25,
                                    description: workout.description
                                )
                            }
                        }
                    }
                }
            }
            
            .padding(.top, bounds.height * 0.1)
            
            
        }
        .overlay(.top) {
            topOverlay
        }
    }
}

extension HistoryView {
    var topOverlay: some View {
        ZStack {
            Color.theme.blue
                .ignoresSafeArea(.all)
            
            HStack {
                Button(action: {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.theme.semiBold)
                })
                
                Spacer()
                
                Text("Workouts History")
                    .foregroundColor(.white)
                    .font(.theme.bold)
                
                Spacer()
                
                
                HStack {
                    
                    Text("\(viewModel.currentUser?.points ?? 0)")
                        .foregroundColor(.theme.yellow)
                        .font(.theme.semiBold)
                    
                    Image("trophy")
                }
                
                
                
            }
            .padding(.horizontal)
            
        }
        .frame(height: bounds.height * 0.09)
    }
}


extension Optional where Wrapped == Date {
    func toFormattedString() -> String {
        guard let self = self else { return "Unknown Date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
}
