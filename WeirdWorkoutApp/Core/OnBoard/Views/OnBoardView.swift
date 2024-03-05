import SwiftUI
import AVFoundation


struct OnBoardView: View {
    
    @EnvironmentObject var viewModel: OnBoardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let bounds = UIScreen.main.bounds
    let baseURL = "https://busapp.co/"
    @State var showBottomSheet: Bool = false
    @State var activeWorkoutLevel: Int = 0
    
    @State private var showSettings: Bool = false
    @State private var showHistory: Bool = false
    @State private var showDetails: Bool = false
    @State private var selectedWorkoutType: workoutType = .body
    @State private var selectedWorkout: [WorkoutModel]?
    @State private var selectedWorkoutLevel: Int = 0
    private var nonOptionalWorkoutsBinding: Binding<[WorkoutModel]> {
        Binding<[WorkoutModel]>(
            get: { self.selectedWorkout ?? [] },
            set: { self.selectedWorkout = $0 }
        )
    }
    
    let workoutImages: [String: String] = [
        "body": "https://imgs.search.brave.com/_vDezj7VJRMxnMY0LdeWjgmSXTDURA3lxiwCvpcxlNY/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9oaXBz/LmhlYXJzdGFwcHMu/Y29tL2htZy1wcm9k/L2ltYWdlcy9zaG90/LW9mLWEtbXVzY3Vs/YXIteW91bmctbWFu/LWV4ZXJjaXNpbmct/d2l0aC1hLXJveWFs/dHktZnJlZS1pbWFn/ZS0xNzAyNjUyMTA3/LmpwZz9jcm9wPTAu/NjQxeHc6MS4wMHho/OzAuMzE1eHcsMCZy/ZXNpemU9MzYwOio",
        "leg": "https://imgs.search.brave.com/19aH5hjJZq9yAhaq5MxN_Ml7irBRafYA2jXxUFsJJJc/rs:fit:860:0:0/g:ce/aHR0cHM6Ly93d3cu/dGhldHJlbmRzcG90/dGVyLm5ldC93cC1j/b250ZW50L3VwbG9h/ZHMvMjAyMC8wNS9U/aGUtVWx0aW1hdGUt/TGVnLVdvcmtvdXQt/LmpwZw",
        "torso": "https://barbend.com/wp-content/uploads/2023/06/push-up-barbend.com_-1.jpg",
        "speed": "https://gridironelitetraining.com/wp-content/uploads/2022/07/how-to-improve-running-speed-for-football.jpg"
    ]
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue
                .ignoresSafeArea(.all)
                
            
            NavigationLink(
                destination: SettingsView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(viewModel)
                    .environmentObject(authViewModel),
                isActive: $showSettings,
                label: {
                    EmptyView()
                })
            
            NavigationLink(
                destination: HistoryView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(viewModel),
                isActive: $showHistory,
                label: {
                    EmptyView()
                })
            
            
            NavigationLink(
                destination: ExerciseDetailView(workoutLevel: selectedWorkoutLevel, selectedWorkout: selectedWorkoutType, workouts: nonOptionalWorkoutsBinding)
                    .environmentObject(viewModel)
                    .navigationTitle("")
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true),
                isActive: $showDetails,
                label: {
                    EmptyView()
                }
            )
            
            
            VStack(alignment: .leading) {
                
                Text("Available Workouts")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.theme.bold(18 ))
                
                content
            }
            .padding(.top, bounds.height * 0.1)
            .padding(.horizontal)
        }
        .overlay(.top) {
            ZStack {
                Color.theme.blue
                    .ignoresSafeArea(.all)
                
                HStack {
                    HStack(spacing: 30) {
                        Button(action: {
                            withAnimation {
                                showSettings = true
                            }
                        }, label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.white)
                                .font(.theme.semiBold)
                        })
                        
                        Button(action: {
                            withAnimation {
                                showHistory = true
                            }
                        }, label: {
                            Image(systemName: "calendar")
                                .foregroundColor(.white)
                                .font(.theme.semiBold)
                        })
                        
                    }
                    
                    Spacer()
                    HStack {
                        Text("\(viewModel.currentUser?.points ?? 0)")
                            .foregroundColor(.theme.yellow)
                            .font(.theme.semiBold(16))
                        
                        Image("trophy")
                        
                    }
                      
                }
                .padding(.horizontal)
            }
            .frame(height: bounds.height * 0.09)
        }
        .overlay(.center) {
            if showBottomSheet {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showBottomSheet = true
                        }
                    }
            }
        }
        .bottomSheet(isPresented: $showBottomSheet) {
            ZStack {
                Color.theme.blue
                VStack {
                    Text("Select Your workout level")
                        .font(.theme.semiBold(18))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    WorkoutLevelSelector(activeWorkoutLevel: $selectedWorkoutLevel)
                    
                    Button(action: {
                        withAnimation {
                            UserDefaults.standard.set(selectedWorkoutLevel, forKey: "level")
                            showBottomSheet = false
                            showDetails = true
                            //TODO: change users workout level in usermodel
                        }
                    }, label: {
                        Text("Continue")
                            .padding()
                            .foregroundColor(.theme.darkBlue)
                            .font(.theme.semiBold(16))
                            .frame(width: bounds.width * 0.8, height: 55)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.theme.yellow))
                    })
                    .padding(.vertical,50)
                }
            }
        }
    }
}
#Preview {
    NavigationView(content: {
        OnBoardView()
            .environmentObject(OnBoardViewModel(userManager: UserManager()))
    })
    
}

// MARK: - VIEWS
extension OnBoardView {
    var content: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(Array(viewModel.allWorkouts).sorted(by: { $0.id < $1.id }), id: \.id) { item in
                    
                    let imageForCategory = workoutImages[item.category.rawValue] ?? "https://barbend.com/wp-content/uploads/2023/06/push-up-barbend.com_-1.jpg"
                    
                    WorkoutCardView(image: imageForCategory, title: "\(item.category)", numberOfExercies: item.workout.count, description: nil)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                withAnimation {
                                    selectedWorkoutType = item.category
                                    selectedWorkout = item.workout
                                    showBottomSheet = true
                                    // showDetails = true
                                }
                            }, label: {
                                Image("play")
                                    .padding(.trailing)
                            })
                        }
                }
            }
            
        }
    }
    
}


