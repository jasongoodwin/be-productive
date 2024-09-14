import Foundation
import CoreData

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    private var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchHabits()
    }

    func fetchHabits() {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.creationDate, ascending: false)]

        do {
            habits = try viewContext.fetch(request)
            updateHabitsStatus() // Check and update status for each habit
        } catch {
            print("Error fetching habits: \(error)")
        }
    }

    func addHabit(title: String) {
        let newHabit = Habit(context: viewContext)
        newHabit.id = UUID()
        newHabit.title = title
        newHabit.creationDate = Date()
        newHabit.isCompleted = false
        newHabit.streak = 0

        do {
            try viewContext.save()
            fetchHabits()
        } catch {
            print("Error adding habit: \(error)")
        }
    }

    func toggleHabitCompletion(_ habit: Habit) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if !habit.isCompleted {
            habit.isCompleted = true
            habit.completionDate = today
            habit.streak += 1
        } else {
            habit.isCompleted = false
            habit.completionDate = nil
            habit.streak = max(0, habit.streak - 1)
        }

        do {
            try viewContext.save()
            fetchHabits()
        } catch {
            print("Error updating habit: \(error)")
        }
    }

    func deleteHabit(_ habit: Habit) {
        viewContext.delete(habit)
        do {
            try viewContext.save()
            fetchHabits()
        } catch {
            print("Error deleting habit: \(error)")
        }
    }

    private func updateHabitsStatus() {
        let today = Calendar.current.startOfDay(for: Date())
        
        for habit in habits {
            if let completionDate = habit.completionDate,
               !Calendar.current.isDate(completionDate, inSameDayAs: today) {
                habit.isCompleted = false
                if Calendar.current.isDateInYesterday(completionDate) {
                    // Streak continues
                } else {
                    // Streak breaks
                    habit.streak = 0
                }
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error updating habits status: \(error)")
        }
    }

    func isHabitCompletedToday(_ habit: Habit) -> Bool {
        return habit.isCompleted
    }
}
