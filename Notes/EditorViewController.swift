//
//  EditorViewController.swift
//  Notes
//
//  Created by Артем Соловьев on 17.03.2021.
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate{
    
    var  currentNotes: Note?
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var textEditor: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIApplication.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        setupEditScreen()
        createToolbar()
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
    
    func createToolbar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textEditor.inputAccessoryView = toolbar
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveNote(){
        let newNotes = Note(name: textEditor.text, imageData: nil)
        
        if currentNotes != nil{
            try! realm.write{
                currentNotes?.name = newNotes.name
                currentNotes?.imageData = newNotes.imageData
            }
        } else{
            StorageManager.saveObject(newNotes)
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
