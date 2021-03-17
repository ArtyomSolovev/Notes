//
//  MainViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 16.03.2021.
//

import UIKit

class MainViewController: UITableViewController {
    var notes = Note.getInf()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let note = notes[indexPath.row]
        cell.textLabel?.text = note.name
        //cell.imageView?.image = UIImage(named: note.image!)//вставляет картинку
        
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//возвращает высоту строки
    }
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func  unwindSegue(_ segue: UIStoryboardSegue){
        guard let newNoteVC = segue.source as? EditorViewController else {return}
        newNoteVC.saveNewNote()
        notes.append(newNoteVC.newNote!)
        tableView.reloadData()// обновление интерфейса
    }
}
