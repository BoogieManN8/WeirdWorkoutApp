import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "WorkoutDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }

    func createWorkout(id: String, name: String, workoutDescription: String, image: String, video: String, difficulty: Int, category: workoutType) {
        let context = persistentContainer.viewContext
        let workout = Workout(context: context)
        workout.id = id
        workout.name = name
        workout.workoutDescription = workoutDescription
        workout.image = image
        workout.video = video
        workout.difficulty = Int16(difficulty)

        let categoryFetch: NSFetchRequest<WorkoutCategory> = WorkoutCategory.fetchRequest()
        categoryFetch.predicate = NSPredicate(format: "category == %@", category.rawValue)

        do {
            let fetchedCategories = try context.fetch(categoryFetch)
            let workoutCategory = fetchedCategories.first ?? WorkoutCategory(context: context)
            workoutCategory.category = category.rawValue

            workoutCategory.addToWorkout(workout)
            try context.save()
        } catch {
            print("Failed to save workout: \(error)")
        }
    }

    func fetchAllWorkouts() -> [WorkoutModel] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()

        do {
            let workouts = try context.fetch(fetchRequest)
            var workoutModels: [WorkoutModel] = []
            for workout in workouts {
                guard let id = workout.id,
                      let name = workout.name,
                      let workoutDescription = workout.workoutDescription,
                      let image = workout.image,
                      let video = workout.video else {
                    print("Error: Workout data is incomplete for item with id \(workout.id ?? "unknown")")
                    continue
                }
                
                let workoutModel = WorkoutModel(id: id, name: name, description: workoutDescription, image: image, video: video, difficulty: Int(workout.difficulty), createdAt: Date())
                workoutModels.append(workoutModel)
            }
            return workoutModels
        } catch {
            print("Failed to fetch workouts: \(error)")
            return []
        }
    }

    
    func deleteAllData() {
        let context = persistentContainer.viewContext
        let fetchRequestWorkout: NSFetchRequest<NSFetchRequestResult> = Workout.fetchRequest()
        let fetchRequestCategory: NSFetchRequest<NSFetchRequestResult> = WorkoutCategory.fetchRequest()

        let deleteRequestWorkout = NSBatchDeleteRequest(fetchRequest: fetchRequestWorkout)
        let deleteRequestCategory = NSBatchDeleteRequest(fetchRequest: fetchRequestCategory)

        do {
            try context.execute(deleteRequestWorkout)
            try context.execute(deleteRequestCategory)
            try context.save()
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }
}
