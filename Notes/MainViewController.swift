//
//  MainViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 16.03.2021.
//

import UIKit
import RealmSwift
//38
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredNotes: Results<Note>!
    private var notes: Results<Note>!
    private var ascendingSorting = true
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes = realm.objects(Note.self)
        
        //Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNotes.count
        }
        return notes.isEmpty ? 0 : notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var note = Note()
        
        if isFiltering {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        cell.textLabel?.text = note.name
//        cell.imageView?.image = UIImage(data: note.imageData!)//вставляет картинку
        
        return cell
    }
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//возвращает высоту строки
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
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
            let note: Note
            if isFiltering {
                note = filteredNotes[indexPath.row]
            } else {
                note = notes[indexPath.row]
            }
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

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredNotes = notes.filter("name CONTAINS[c] %@ ", searchText)
        
        tableView.reloadData()
    } 
}
