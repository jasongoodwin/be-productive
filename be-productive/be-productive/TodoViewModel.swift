import Foundation
import CoreData

class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    private var viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchTodos()
    }

    func fetchTodos() {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Todo.creationDate, ascending: false)]

        do {
            todos = try viewContext.fetch(request)
        } catch {
            print("Error fetching todos: \(error)")
        }
    }

    func addTodo(title: String) {
        let newTodo = Todo(context: viewContext)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.isCompleted = false
        newTodo.creationDate = Date()

        do {
            try viewContext.save()
            fetchTodos()
        } catch {
            print("Error adding todo: \(error)")
        }
    }

    func toggleTodoCompletion(_ todo: Todo) {
        todo.isCompleted.toggle()
        do {
            try viewContext.save()
            fetchTodos()
        } catch {
            print("Error updating todo: \(error)")
        }
    }

    func deleteTodo(_ todo: Todo) {
        viewContext.delete(todo)
        do {
            try viewContext.save()
            fetchTodos()
        } catch {
            print("Error deleting todo: \(error)")
        }
    }
}
