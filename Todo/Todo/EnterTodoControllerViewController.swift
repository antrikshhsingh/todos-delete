//  AddTodoController.swift
//  TabViewExample
//  Created by Antriksh Singh on 16/04/24.


import UIKit

protocol AddTodoDelegate{
    func addTodo(_ todo: Todos)
    func updateTodoAtIndex(_ index: Int, with todo: Todos)
    func deleteTodoAtIndex(_ index: Int)
}

class EnterTodoControllerViewController: UIViewController {
    
    // Text field
    @IBOutlet weak var titleTextField: UITextField!
    
    // Segmentation control
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    //Todo description
    @IBOutlet weak var todoDescription: UITextView!
    
    // Date picker
    @IBOutlet weak var datePicker: UIDatePicker!
    
     // Current progress like new, In-progress, Completed
    @IBOutlet weak var currentProgress: UILabel!

    @IBOutlet weak var progressContainerView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var editTodoButton: UIBarButtonItem!
    
    var delegate : AddTodoDelegate!
    var selectedTodo: Todos?
    var todoIndex: Int?
    
    var isEnabledEditing : Bool = false
    
    var originalTitle: String?
    var originalDescription: String?
    var originalDate: Date?
    var originalPriorityIndex: Int?
    var originalProgress: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressLabel()
    
        print(selectedTodo)

        
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
    
        todoDescription.layer.cornerRadius = 10
        todoDescription.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        saveButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpUI()
        populateData()
        setSegmentedControlColor()
        
        if isEnabledEditing {
            view.isUserInteractionEnabled = true
            progressContainerView.isHidden = true
        }else {
            view.isUserInteractionEnabled = false
            saveButton.isHidden = true
            progressContainerView.isHidden = false
        }
    }
    
    
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        guard let todoIndex = todoIndex else {
             return // If todoIndex is nil, there's nothing to delete
         }
         
         let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this todo?", preferredStyle: .alert)
         let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
             self?.delegate?.deleteTodoAtIndex(todoIndex)
             self?.dismiss(animated: true)
         }
         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         
         alert.addAction(deleteAction)
         alert.addAction(cancelAction)
         
         present(alert, animated: true)
    }
    
    func setUpUI(){
        datePicker.minimumDate = Date.now
        progressContainerView.isHidden = true
        deleteButton.isHidden = true
        currentProgress.textColor = UIColor.blue
    }
    
    func setUpProgressLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        currentProgress.addGestureRecognizer(tap)
        currentProgress.isUserInteractionEnabled = true
    }
    
    @objc func handleTapGesture(){
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)

        let newAction = UIAlertAction(title: "New", style: .default, handler: { action in
            let actionTitle = action.title
            self.currentProgress.textColor = UIColor.blue
            self.currentProgress.text = actionTitle
        })
        
        let inProgressAction = UIAlertAction(title: "In-Progress", style: .default, handler: { action in
            let actionTitle = action.title
            self.currentProgress.textColor = UIColor.orange
            self.currentProgress.text = actionTitle
        })
        
        let completedAction = UIAlertAction(title: "Completed", style: .default, handler: { action in
            let actionTitle = action.title
            self.currentProgress.textColor = UIColor.red
            self.currentProgress.text = actionTitle
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
             (alert: UIAlertAction!) -> Void in
             print("Cancelled")
         })
        
        optionMenu.addAction(newAction)
        optionMenu.addAction(inProgressAction)
        optionMenu.addAction(completedAction)
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true)
    }
    
    func setSegmentedControlColor(){
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0:
            prioritySegmentedControl.selectedSegmentTintColor = .red.withAlphaComponent(0.7)
        case 1:
            prioritySegmentedControl.selectedSegmentTintColor = .green.withAlphaComponent(0.7)
        case 2:
            prioritySegmentedControl.selectedSegmentTintColor = .yellow.withAlphaComponent(0.7)
        default:
            return
        }
    }
    
    func populateData(){
        if let selectedTodo = selectedTodo {
                   titleTextField.text = selectedTodo.title
                   todoDescription.text = selectedTodo.description
                   datePicker.date = selectedTodo.date.toDate()
                   currentProgress.text = selectedTodo.progress.rawValue
            
                   switch selectedTodo.priority {
                   case .high:
                       prioritySegmentedControl.selectedSegmentIndex = 0
                   case .medium:
                       prioritySegmentedControl.selectedSegmentIndex = 1
                   case .low:
                       prioritySegmentedControl.selectedSegmentIndex = 2
                   }
        }
    }
    
    @IBAction func segementControlAction(_ sender: UISegmentedControl) {
        setSegmentedControlColor()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        view.isUserInteractionEnabled = !view.isUserInteractionEnabled
        saveButton.isHidden = !saveButton.isHidden
        deleteButton.isHidden = !deleteButton.isHidden
        currentProgress.textColor = UIColor.blue
        
        if view.isUserInteractionEnabled {
            editTodoButton.title = "Cancel Editing"
            if !isEnabledEditing {
                // Store original values
                originalTitle = selectedTodo?.title
                originalDescription = selectedTodo?.description
                originalDate = selectedTodo?.date.toDate() ?? Date()
                originalPriorityIndex = prioritySegmentedControl.selectedSegmentIndex
            }
        } else {
            editTodoButton.title = "Edit"
            populateData()
        }
        
        isEnabledEditing = !isEnabledEditing
    }
    
    
    @objc func dismissKeyboard() {
        // Dismiss the keyboard
        view.endEditing(true)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
            displayAlert(message: "Title is required")
            return
           }
        
        let priority: Priority
        
        let progress = Progress.New
        
        switch prioritySegmentedControl.selectedSegmentIndex {
        case 0:
            priority = .high
        case 1:
            priority = .medium
        case 2:
            priority = .low
        default:
            priority = .medium
        }
        
        if let todoIndex = todoIndex {
            // Update the existing todo item
            let updatedTodo = Todos(title: title, description: todoDescription.text, isCompleted: selectedTodo?.isCompleted ?? false, priority: priority,date: datePicker.date.getCurrentDateAsString(),progress: progress)
            delegate?.updateTodoAtIndex(todoIndex, with: updatedTodo)
        } else {
            // Create a new todo item
            let newTodo = Todos(title: title, description:todoDescription.text, isCompleted: false, priority: priority, date: datePicker.date.getCurrentDateAsString(),progress: .New)
            delegate?.addTodo(newTodo)
        }
        
        editTodoButton.title = "Edit"
        view.isUserInteractionEnabled = false
        saveButton.isHidden = true
        
        dismiss(animated: true)
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
