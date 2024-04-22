import UIKit

class TodoListController: UIViewController, AddTodoDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var filterSegmentationControl: UISegmentedControl!
    
    @IBOutlet weak var newTaskButton: UIButton!
    
    var todos: [Todos] = [
//        Todos(title: "Wash Clothes", isCompleted: false, priority: .high),
//        Todos(title: "Drink 2L of water", isCompleted: false, priority: .medium),
//        Todos(title: "Gymming 2hours", isCompleted: false, priority: .low)
    ]
    
    var originalTodos: [Todos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todo App"
        newTaskButton.layer.cornerRadius = newTaskButton.frame.height / 2
        
        // Registering the custom Table View cell.
        listTableView.register(UINib(nibName: "TodoListViewCell", bundle: nil), forCellReuseIdentifier: "TodoListViewCell")
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = .none
        listTableView.rowHeight = 60
        originalTodos = todos
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
        UINavigationBar.appearance().prefersLargeTitles = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UINavigationBar.appearance().prefersLargeTitles = false
    }
    

    
    @IBAction func filterSegmentAction(_ sender: Any) {
        
        switch filterSegmentationControl.selectedSegmentIndex{
        case 0:
            print("Filter by priority")
            todos.sort { $0.priorityIndex < $1.priorityIndex }
            listTableView.reloadData()
            print(todos)
        case 1:
            print("Filter by Date")
            todos.sort { $0.date.toDate() < $1.date.toDate() }
            listTableView.reloadData()
            print(todos)
        default:
            return
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EnterTodoControllerViewController") as! EnterTodoControllerViewController
        vc.delegate = self
        vc.isEnabledEditing = true
        present(vc, animated: true)
    }


    
    func addTodo(_ todo: Todos) {
        todos.append(todo)
        originalTodos.append(todo)
        listTableView.reloadData()
        print(originalTodos)
    }
    
    func updateTodoAtIndex(_ index: Int, with todo: Todos) {
        todos[index] = todo
        if let originalIndex = originalTodos.firstIndex(where: { $0.id == todo.id }) {
            originalTodos[originalIndex] = todo
        }
        listTableView.reloadData()
    }
    
    func deleteTodoAtIndex(_ index: Int) {
        todos.remove(at: index)
        listTableView.reloadData()
    }
}

extension TodoListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "EnterTodoControllerViewController") as! EnterTodoControllerViewController
        vc.delegate = self
        vc.selectedTodo = todos[indexPath.row]
        vc.todoIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListViewCell", for: indexPath) as! TodoListViewCell
        cell.configure(todos: todos[indexPath.row])
        return cell
    }
}
