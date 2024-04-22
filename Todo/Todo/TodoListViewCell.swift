import UIKit

class TodoListViewCell: UITableViewCell {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    
    
    private var todos: Todos!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize cell appearance
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        // Random Color generator object
        let bicolor = RandomColorGenerator(color1: .red, color2: .blue, opacity: 0.5)
        contentView.backgroundColor = bicolor.randomColor()
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    func configure(todos: Todos) {
        self.todos = todos
        taskName.text = todos.title
        progressLabel.text = todos.progress.rawValue.capitalized
        taskPriorityLabel.text = todos.priority.rawValue.capitalized
        taskDateLabel.text = todos.date
        
        
        switch todos.progress {
        case .New:
            progressLabel.textColor = .blue
        case .in_progess:
            progressLabel.textColor = .yellow
        case .completed:
            progressLabel.textColor = .green
        }
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
