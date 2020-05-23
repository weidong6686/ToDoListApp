//
//  ToDoDetailsViewController.swift
//  ToDoList
//
//

import UIKit

class ToDoDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    
    @IBOutlet weak var taskDetailsTextView: UITextView!
    
    @IBOutlet weak var taskCompletionButton: UIButton!
    
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    weak var delegate: ToDoListDelegate?
    
    var toDoItem: ToDoItem!
    
    var toDoIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        taskTitleLabel.text = toDoItem.name
        
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            
            disableButton()
            
        }
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMM, yyyy hh:mm"
        
        let taskDate = formatter.string(from: toDoItem.completionDate)
        
        taskCompletionDate.text = taskDate
        
    }
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        
        taskCompletionButton.isEnabled = false
        
    }
    
    @IBAction func taskDidComplete(_ sender: Any) {
        
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you would like to complete this task?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.completeTask(alert: alert)
            
        }
        
        alert.addAction(cancelAction)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        

        
    }
    
    func completeTask(alert: UIAlertController) {
        
        toDoItem.isComplete = true

        delegate?.update(task: toDoItem, index: toDoIndex)
        
        disableButton()
        
    }
    
}
