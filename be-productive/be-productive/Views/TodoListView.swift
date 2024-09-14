import SwiftUI

struct TodoListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TodoViewModel
    @State private var newTodoTitle = ""

    init(viewContext: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TodoViewModel(viewContext: viewContext))
    }

    var body: some View {
        VStack {
            HStack {
                TextField("New todo", text: $newTodoTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: addTodo) {
                    Text("Add")
                }
            }
            .padding()

            List {
                ForEach(viewModel.todos) { todo in
                    HStack {
                        Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                            Image(systemName: todo.isCompleted ? "checkmark.square" : "square")
                        }
                        VStack(alignment: .leading) {
                            Text(todo.title ?? "")
                                .strikethrough(todo.isCompleted)
                            if let completionDate = todo.completionDate {
                                Text("Completed: \(completionDate, formatter: itemFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteTodos)
            }
        }
        .navigationTitle("Todo List")
    }

    private func addTodo() {
        withAnimation {
            viewModel.addTodo(title: newTodoTitle)
            newTodoTitle = ""
        }
    }

    private func deleteTodos(offsets: IndexSet) {
        withAnimation {
            offsets.map { viewModel.todos[$0] }.forEach(viewModel.deleteTodo)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewContext: PersistenceController.preview.container.viewContext)
    }
}
