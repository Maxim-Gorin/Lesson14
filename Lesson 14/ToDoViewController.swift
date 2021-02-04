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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func addToDo(_ sender: Any) {
        let alert = UIAlertController(title: "Add ToDo via \(dbType.rawValue)", message: "Enter a text", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            if let text = textField?.text, !text.isEmpty {
                if self.dbType == .realm {
                    let toDo = ToDoRealm()
                    toDo.title = text
                    
                    RealmPersistance.shared.add(toDo)
                } else {
                    CoreDataPersistance.shared.add(text)
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
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        
        if dbType == .realm {
            cell.textLabel?.text = toDosRealm[indexPath.row].title
        } else {
            cell.textLabel?.text = toDosCoreData[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            if dbType == .realm {
                let toDo = toDosRealm[indexPath.row]
                RealmPersistance.shared.remove(toDo)
            } else {
                let toDo = toDosCoreData[indexPath.row]
                CoreDataPersistance.shared.remove(toDo)
            }
            
            reloadTableView()
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum DatabaseType: String {
    case realm = "Realm"
    case coredata = "CoreData"
}
