//
//  MainViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 16.03.2021.
//

import UIKit
import RealmSwift
class MainViewController: UITableViewController {
    var notes: Results<Note>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.tableFooterView = UIView()
        notes = realm.objects(Note.self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.isEmpty ? 0 : notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.name
//        cell.imageView?.image = UIImage(data: note.imageData!)//вставляет картинку
        
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//возвращает высоту строки
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let note = notes[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(note)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let note = notes[indexPath.row]
            let newNoteVC = segue.destination as! EditorViewController
            newNoteVC.currentNotes = note 
        }
    }
    @IBAction func  unwindSegue(_ segue: UIStoryboardSegue){
        guard let newNoteVC = segue.source as? EditorViewController else {return}
        newNoteVC.saveNote()
    //    notes.append(newNoteVC.newNote!)
        tableView.reloadData()// обновление интерфейса
    }
}
