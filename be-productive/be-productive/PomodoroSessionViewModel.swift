import Foundation
import CoreData

class PomodoroSessionViewModel: ObservableObject {
    @Published var completedSessions: [PomodoroSession] = []
    
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchCompletedSessions()
    }
    
    func fetchCompletedSessions() {
        let request: NSFetchRequest<PomodoroSession> = PomodoroSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PomodoroSession.endTime, ascending: false)]
        
        do {
            completedSessions = try viewContext.fetch(request)
        } catch {
            print("Error fetching completed sessions: \(error)")
        }
    }
    
    func addCompletedSession(task: String, duration: Int, completedAt: Date) {
        let newSession = PomodoroSession(context: viewContext)
        newSession.id = UUID()
        newSession.task = task
        newSession.duration = Int32(duration)
        newSession.endTime = completedAt
        
        do {
            try viewContext.save()
            fetchCompletedSessions()
        } catch {
            print("Error saving completed session: \(error)")
        }
    }
}
