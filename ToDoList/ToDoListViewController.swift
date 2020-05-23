//
//  ToDoListViewController.swift
//  ToDoList
//
//

import UIKit

protocol ToDoListDelegate: class {
    
    func update(task: ToDoItem, index: Int)
    
}

class ToDoListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems: [ToDoItem] = [ToDoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        
        title = "To Do List"
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNew(_ :)), name: NSNotification.Name(rawValue: "AddTask"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.setEditing(false, animated: false)
        
    }
    
    @objc func addTapped() {
        
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
        
    }
    
    @objc func editTapped() {
        
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing == true {
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editTapped))
            
        } else{
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
            
        }
        
    }
    
    @objc func addNew(_ notification: NSNotification) {
        
        var toDoItem: ToDoItem!
        
        if let dict = notification.userInfo as NSDictionary? {
        
            guard let task = dict["NewTask"] as? ToDoItem else { return }
            
            toDoItem = task
            
        }
        else if let task = notification.object as? ToDoItem {
            
                toDoItem = task
        
        }
        else {
            
            return
            
        }
        
        toDoItems.append(toDoItem)
        
        toDoItems.sort(by: { $0.completionDate > $1.completionDate })
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.toDoItems.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
        }
        
        return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems[indexPath.row]
        
        let toDoTuple = (selectedItem, indexPath.row)
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItem")!
        
        let toDoItem = toDoItems[indexPath.row]
        
        cell.textLabel?.text = toDoItem.name
        
        cell.detailTextLabel?.text = toDoItem.isComplete ? "Complete" : "Incomplete"
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            
            guard let toDoItem = sender as? (ToDoItem, Int) else { return }
            
            destinationVC.delegate = self
            
            destinationVC.toDoItem = toDoItem.0
            
            destinationVC.toDoIndex = toDoItem.1
            
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("AddTask"), object: nil)
        
    }

}

extension ToDoListViewController: ToDoListDelegate {
    
    func update(task: ToDoItem, index: Int) {
        
        toDoItems[index] = task
        
        tableView.reloadData()
        
    }
    
}
