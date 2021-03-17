//
//  EditorViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 17.03.2021.
//

import UIKit

class EditorViewController: UIViewController {
    var newNote: Note?

    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var textEditor: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //saveButton.isEnabled = false
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        view.endEditing(true)
    }

    func saveNewNote(){
        newNote = Note(name: textEditor.text, uiimage: nil, image: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Text field delegate

extension EditorViewController: UITextFieldDelegate{
    // скрывать клавиатуру
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
