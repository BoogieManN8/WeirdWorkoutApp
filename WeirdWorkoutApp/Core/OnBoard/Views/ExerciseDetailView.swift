import SwiftUI

struct ExerciseDetailView: View {
    
    let bounds = UIScreen.main.bounds
    let baseURL = "https://busapp.co/"
    let workoutLevel: Int
    let selectedWorkout: workoutType
    @Binding var workouts: [WorkoutModel]
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: OnBoardViewModel
    @State private var isVideoPlaying: Bool = false
    @State private var chosenVideo: String = "body/videos/Pull-Ups.mp4"
    @State private var selectedExercise: WorkoutModel?
    @State private var showCompleteSheet: Bool = false
    @State private var activeWorkoutIndex = 0
    
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue
                .ignoresSafeArea(.all)
                .onAppear{
//                    self.presentationMode.wrappedValue.navigationBarHidden = true
                    
                    workouts = workouts.filter({ $0.difficulty == workoutLevel })
                    if let workout = workouts.first {
                        print("DEBUG: \(workout)")
                        self.selectedExercise = workout
                    }
                    
                }
            VStack {
                activeExerciseLayer
                
                content
                    .animation(.easeInOut, value: workouts)
            }
            .padding(.top, bounds.height * 0.1)
        }
        .overlay(.top) {
            topOverlay
        }
        .bottomSheet(isPresented: $showCompleteSheet) {
            ZStack {
                Color.theme.blue
                    .ignoresSafeArea(.all)
                VStack (spacing: 30){
                    Text("Select Your workout level")
                        .foregroundColor(.white)
                        .font(.theme.bold(16))
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text("Exercises completed")
                                .foregroundColor(.gray)
                                .font(.theme.semiBold(14))
                            
                            Spacer()
                            
                            Text("4")
                                .foregroundColor(.white)
                                .font(.theme.semiBold(14))
                        }
                        
                        HStack {
                            Text("Time Spent")
                                .foregroundColor(.gray)
                                .font(.theme.semiBold(14))
                            
                            Spacer()
                            
                            Text("00:07")
                                .foregroundColor(.white)
                                .font(.theme.semiBold(14))
                        }
                        
                        HStack {
                            Text("Points received")
                                .foregroundColor(.gray)
                                .font(.theme.semiBold(14))
                            
                            Spacer()
                            
                            HStack {
                                Text("+1")
                                    .font(.theme.semiBold(14))
                                    .foregroundColor(.theme.yellow)
                                
                                Image("trophy")
                                
                            }
                        }
                    }
                    
                    Button(action: {
                        withAnimation {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Complete")
                            .padding()
                            .foregroundColor(.theme.darkBlue)
                            .font(.theme.semiBold(16))
                            .frame(width: bounds.width * 0.8, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.yellow))
                    })
                    .padding()
                    
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    private func hideNavigationBar() {
        if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
    }
}

#Preview {
    ExerciseDetailView(workoutLevel: 2, selectedWorkout: .body, workouts: .constant([]))
        .environmentObject(OnBoardViewModel(userManager: UserManager()))
}

// MARK: - VIEWs
extension ExerciseDetailView {
    
    
    var activeExerciseLayer: some View {
        VStack(spacing: -10) {
            HStack {
                if let exec = selectedExercise  {
                    let urlString = "https://busapp.co/\(exec.image)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if let encodedURLString = urlString, let imageURL = URL(string: encodedURLString) {
                        AsyncImage(url: imageURL) {
                            ProgressView()
                        }
                        .scaledToFill()
                        .frame(width: 70, height: 60)
                        .cornerRadius(12)
                        .clipped()
                        .padding()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("\(selectedExercise?.name ?? "")")
                        .foregroundColor(.white)
                        .font(.theme.bold(18))
                    
                    Text("\(selectedExercise?.description ?? "")")
                        .foregroundColor(.gray)
                        .font(.theme.bold(14))
                    
                }
                Button(action: {
                    withAnimation {
                        isVideoPlaying.toggle()
                    }
                }, label: {
                    Image("\(isVideoPlaying ? "pause" : "play.gray")")
                        .padding()
                        .frame(width: 80, height: 50)
                        .background(Capsule().fill(Color.white))
                        .padding()
                })
                
            }
            .frame(width: bounds.width * 0.86)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
            .padding()
            .onAppear{
                print("DEBUG: image - \(selectedExercise?.image ?? "image nil")")
            }
            
            if isVideoPlaying {
                if let urlString = "\(baseURL)\(selectedExercise?.video ?? chosenVideo)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
                    VideoPlayerView(category: "", videoURL: url, startTimeInSeconds: 0.0, isFull: false, isPlaying: $isVideoPlaying)
                        .frame(width: bounds.width * 0.86, height: 200)
                        .clipped()
                        .cornerRadius(12)
                        .id(UUID())
                        .onAppear{
                            print("DEBUG: video url - \(url)")
                        }
                } else {
                    Text("Something was not right")
                }
            } else {
                AsyncImage(url: URL(string: "https://busapp.co/body/images/Burpees.jpeg")!) {
                    ProgressView()
                }
                .scaledToFill()
                .frame(width: bounds.width * 0.86, height: 200)
                .clipped()
                .cornerRadius(12)
                .overlay(.center) {
                    Button(action: {
                        withAnimation {
                            isVideoPlaying = true
                        }
                    }, label: {
                        Image("play")
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    })
                    
                }
            }
            
        }
    }
    
    var content: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack (spacing: -20) {
                    ForEach(Array(workouts).sorted(by: { $0.id < $1.id }), id: \.id) { item in
                        HStack {
                            
                            if let urlString = "https://busapp.co/\(item.image)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                               let imageURL = URL(string: urlString) {
                                AsyncImage(url: imageURL) {
                                    ProgressView()
                                }
                                .scaledToFill()
                                .frame(width: 70, height: 60)
                                .cornerRadius(12)
                                .clipped()
                                .padding()
                            }
                            
                            
                            VStack(alignment: .leading) {
                                Text("\(item.name)")
                                    .foregroundColor(.white)
                                    .font(.theme.bold(18))
                                
                                Text("\(item.description)")
                                    .foregroundColor(.gray)
                                    .font(.theme.bold(14))
                                
                            }
                            Button(action: {
                                withAnimation {
                                    isVideoPlaying.toggle()
                                }
                            }, label: {
                                Text("Next")
                                    .padding()
                                    .frame(width: 80, height: 50)
                                    .background(Capsule().fill(Color.white))
                                    .padding()
                            })
                            .disabled(true)
                            
                        }
                        .frame(width: bounds.width * 0.86)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
                        .padding()
                    }
                }
                
            }
            HStack {
                if let imageName = selectedExercise?.image,
                   let urlString = "https://busapp.co/\(imageName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let imageURL = URL(string: urlString) {
                    AsyncImage(url: imageURL) {
                        ProgressView()
                    }
                    .scaledToFill()
                    .frame(width: 70, height: 60)
                    .cornerRadius(12)
                    .clipped()
                    .padding()
                }
                
                
                VStack(alignment: .leading) {
                    Text("\(selectedExercise?.name ?? "")")
                        .foregroundColor(.white)
                        .font(.theme.bold(14))
                    
                    Text("\(selectedExercise?.description ?? "")")
                        .foregroundColor(.gray)
                        .font(.theme.bold(14))
                    
                }
                Button(action: {
                    withAnimation(.easeInOut) {
                        handleComplete()
                        handleUser()
                    }
                }, label: {
                    Text("Complete")
                        .padding()
                        .frame(width: 120, height: 50)
                        .background(Capsule().fill(Color.white))
                        .padding()
                        .foregroundColor(.theme.darkBlue)
                })
                
            }
            .frame(width: bounds.width * 0.86)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.blue))
            .padding()
        }
        
    }
    
    
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



// MARK: - HELPERS
extension ExerciseDetailView {
    func handleComplete(){
        withAnimation(.easeInOut) {
            if workouts.count > 1 {
                workouts.removeLast()
                selectedExercise = workouts.last
            } else if workouts.count == 1 {
                selectedExercise = nil
                workouts.removeLast()
                showCompleteSheet = true
            }
            
            guard let workout = selectedExercise else {
                print("DEBUG: workout was not found")
                return
            }
            viewModel.addWorkoutToHistory(id: workout.id, name: workout.name, workoutDescription: workout.description, image: workout.image, video: workout.video, difficulty: workout.difficulty, category: selectedWorkout)
            
        }
    }
    
    func handleUser(){
        guard var currentUser = viewModel.currentUser else {
            print("DEBUG: user was not found")
            return
        }
        var pointsToAdd = 0
        if workoutLevel == 0 {
            pointsToAdd = 1
        } else if workoutLevel == 1 {
            pointsToAdd = 2
        } else {
            pointsToAdd = 3
        }
        
        currentUser.points += pointsToAdd
        viewModel.updateUser(user: currentUser)
    }
}
struct HideNavigationBar: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
