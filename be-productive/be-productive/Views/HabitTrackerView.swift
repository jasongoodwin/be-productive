import SwiftUI

struct HabitTrackerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: HabitViewModel
    @State private var newHabitTitle = ""

    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HabitViewModel(viewContext: viewContext))
    }

    var body: some View {
        VStack {
            HStack {
                TextField("New habit", text: $newHabitTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addHabit) {
                    Text("Add")
                }
            }
            .padding()

            List {
                ForEach(viewModel.habits) { habit in
                    HStack {
                        Button(action: { viewModel.toggleHabitCompletion(habit) }) {
                            Image(systemName: viewModel.isHabitCompletedToday(habit) ? "checkmark.square" : "square")
                        }
                        VStack(alignment: .leading) {
                            Text(habit.title ?? "")
                            Text("Streak: \(habit.streak) days")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteHabits)
            }
        }
        .navigationTitle("Habit Tracker")
        .onAppear {
            viewModel.fetchHabits() // Refresh habits and their status when view appears
        }
    }

    private func addHabit() {
        withAnimation {
            viewModel.addHabit(title: newHabitTitle)
            newHabitTitle = ""
        }
    }

    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.habits[$0] }.forEach(viewModel.deleteHabit)
        }
    }
}

struct HabitTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTrackerView(viewContext: PersistenceController.preview.container.viewContext)
    }
}
