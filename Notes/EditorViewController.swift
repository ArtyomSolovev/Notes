//
//  EditorViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 17.03.2021.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate{
    //var newNote = Note()
    var  currentNotes: Note?

    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var textEditor: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textEditor.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIApplication.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        // Отслеживаем скрытие клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)

//        DispatchQueue.main.async {//позволяет обращаться к БД, даже когда интерфейс обновляется
//            self.newNote.saveInf()
//        }
        //saveButton.isEnabled = false
        setupEditScreen()
    }
    @objc func updateTextView(notification: Notification) {
        
        guard let userInfo = notification.userInfo as? [String: AnyObject],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        if notification.name == UIApplication.keyboardWillHideNotification {
            textEditor.contentInset = UIEdgeInsets.zero
        } else {
            textEditor.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height + 10,
                                                 right: 0)
            
            textEditor.scrollIndicatorInsets = textEditor.contentInset
        }
        
        textEditor.scrollRangeToVisible(textEditor.selectedRange)
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        view.endEditing(true)
    }

    func saveNote(){
        
//        var image: UIImage?
//
//        if imageIsChanged {
//            image = placeImage.image
//        } else {
//            image = #imageLiteral(resourceName: "imagePlaceholder")
//        }
//
//        let imageData = image?.pngData()
        let newNotes = Note(name: textEditor.text, imageData: nil)
        //let newNote = Note()
        //let imageData = image?.pngData()
        
        //newNote.name = textEditor.text!
        //newNote.imageData = imageData
        
        if currentNotes != nil{
            try! realm.write{
                currentNotes?.name = newNotes.name
                currentNotes?.imageData = newNotes.imageData
            }
        } else{
            StorageManager.saveObject(newNotes)
        }
        
    }
    
    private func setupEditScreen(){
        if currentNotes != nil{
            setupNavagationBar() 
            
            textEditor.text = currentNotes?.name
            
        }
    }
    
    private func setupNavagationBar(){
        if let topItem = navigationController?.navigationBar.topItem{
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentNotes?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Text field delegate

extension EditorViewController: UITextFieldDelegate{
   func textFieldChanged() {

        if textEditor.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
