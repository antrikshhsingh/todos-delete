import Foundation

struct Todos {
    var id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var priority: Priority
    var date: String
    var progress:Progress
    
    var priorityIndex: Int {
        switch priority {
        case .high:
            0
        case .medium:
            1
        case .low:
            2
        }
    }
}


enum Priority: String {
    case high
    case medium
    case low
}

enum Progress: String {
    case New
    case in_progess
    case completed
}
