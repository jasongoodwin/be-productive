import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selection: String? = "todos"
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: TodoListView(viewContext: viewContext), tag: "todos", selection: $selection) {
                    Label("Todos", systemImage: "list.bullet")
                }
                NavigationLink(destination: HabitTrackerView(), tag: "habits", selection: $selection) {
                    Label("Habits", systemImage: "calendar")
                }
                NavigationLink(destination: PomodoroTimerView(), tag: "pomodoro", selection: $selection) {
                    Label("Pomodoro", systemImage: "timer")
                }
                NavigationLink(destination: SettingsView(), tag: "settings", selection: $selection) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
            
            Text("Select an item")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
