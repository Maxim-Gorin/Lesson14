//
//  ToDoViewController.swift
//  
//
//  Created by Maxim Gorin on 04.02.2021.
//

import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var toDosRealm: [ToDoRealm] = []
    private var toDosCoreData: [ToDoCoreData] = []
    private var dbType = DatabaseType.realm
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        if let items = tabBarController?.tabBar.items, items.count >= 3 {
            for item in 0..<items.count {
                if item == 1 {
                    items[item].image = UIImage(systemName: "r.circle")
                    items[item].title = "Realm"
                } else if item == 2 {
                    items[item].image = UIImage(systemName: "c.circle")
                    items[item].title = "CoreData"
                }
            }
        }

        if tabBarController?.selectedIndex == 1 {
            navigationController?.navigationBar.topItem?.title = "Realm ToDo"
            
            dbType = .realm
            toDosRealm = RealmPersistance.shared.getAllToDos()
        } else if tabBarController?.selectedIndex == 2 {
            navigationController?.navigationBar.topItem?.title = "CoreData ToDo"

            dbType = .coredata
            toDosCoreData = CoreDataPersistance.shared.getAllToDos()
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func addToDo(_ sender: Any) {
        let alert = UIAlertController(title: "Add ToDo via \(dbType.rawValue)", message: "Enter a text\n\n\n", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.timeZone = .current
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 20, y: 70, width: 230, height: 40)
        alert.view.addSubview(datePicker)

        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]

            if let text = textField?.text, !text.isEmpty {
                if self.dbType == .realm {
                    let toDo = ToDoRealm()
                    toDo.title = text
                    toDo.date = datePicker.date
                    toDo.completed = false

                    RealmPersistance.shared.add(toDo)
                } else {
                    CoreDataPersistance.shared.add(title: text, date: datePicker.date)
                }

                self.reloadTableView()
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        if dbType == .realm {
            toDosRealm = RealmPersistance.shared.getAllToDos()
        } else {
            toDosCoreData = CoreDataPersistance.shared.getAllToDos()
        }
        
        tableView.reloadData()
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dbType == .realm {
            return toDosRealm.count
        } else {
            return toDosCoreData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "reuseIdentifier")
        }
        
        if dbType == .realm {
            let toDo = toDosRealm[indexPath.row]
            
            cell?.textLabel?.text = toDo.title
            cell?.detailTextLabel?.text = toDo.date.toString()
            cell?.accessoryType = toDo.completed ? .checkmark : .none
        } else {
            let toDo = toDosCoreData[indexPath.row]

            cell?.textLabel?.text = toDo.title
            cell?.detailTextLabel?.text = toDo.date?.toString()
            cell?.accessoryType = toDo.completed ? .checkmark : .none
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if dbType == .realm {
                let toDo = toDosRealm[indexPath.row]
                RealmPersistance.shared.remove(toDo)
                toDosRealm.remove(at: indexPath.row)
            } else {
                let toDo = toDosCoreData[indexPath.row]
                CoreDataPersistance.shared.remove(toDo)
                toDosCoreData.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dbType == .realm {
            let toDo = toDosRealm[indexPath.row]
            let newToDo = ToDoRealm()
            newToDo.id = toDo.id
            newToDo.title = toDo.title
            newToDo.date = toDo.date
            newToDo.completed = !toDo.completed

            RealmPersistance.shared.update(newToDo)
            
            toDosRealm[indexPath.row] = newToDo
        } else {
            let toDo = toDosCoreData[indexPath.row]

            if let newToDo = CoreDataPersistance.shared.update(toDo) {
                toDosCoreData[indexPath.row] = newToDo
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

enum DatabaseType: String {
    case realm = "Realm"
    case coredata = "CoreData"
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        return dateFormatter.string(from: self)
    }
}
