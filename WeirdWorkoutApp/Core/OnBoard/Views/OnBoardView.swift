import SwiftUI
import AVFoundation


struct OnBoardView: View {
    
    @EnvironmentObject var viewModel: OnBoardViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let bounds = UIScreen.main.bounds
    let baseURL = "http://62.72.18.243:5000/"
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
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue
                .ignoresSafeArea(.all)
                
            
            NavigationLink(
                destination: SettingsView()
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(viewModel),
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
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .navigationTitle("")
                    .environmentObject(viewModel),
                isActive: $showDetails,
                label: {
                    EmptyView()
                })
            
            
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
                    WorkoutCardView(image: "https://barbend.com/wp-content/uploads/2023/06/push-up-barbend.com_-1.jpg", title: "\(item.category)", numberOfExercies: item.workout.count, description: nil)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                        .overlay(alignment: .trailing) {
                            Button(action: {
                                withAnimation {
                                    selectedWorkoutType = item.category
                                    selectedWorkout = item.workout
                                    showBottomSheet = true
//                                    showDetails = true
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


