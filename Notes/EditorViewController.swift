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

    @IBOutlet var imageOfOlace: UIImageView!
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
//    private func textFieldDidChangeSelection(_ textField: UITextField) {
//        view.endEditing(true)
//    }
    
    func createToolbar() {//надстройка над клавиатурой
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()//подгоняем размер
        
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        
        let  photoButton = UIBarButtonItem(title: "Photo",
                                         style: .plain,
                                         target: self,
                                         action: #selector(choosePhoto))
        
        toolbar.setItems([doneButton, photoButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textEditor.inputAccessoryView = toolbar
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @objc func choosePhoto() {
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        
        let photo = UIAlertAction(title: "Photo", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
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
//MARK: Work with image
extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            //imagePicker.delegate = self
            imagePicker.allowsEditing = true//позволяет редактировать изображение
            imagePicker.sourceType = source
            present(imagePicker, animated: true)

//            let image = UIImageView(image: UIImage(named: "main.jpg"))
//            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: image.frame.width, height: image.frame.height))
//            textEditor.textContainer.exclusionPaths = [path]
//            textEditor.addSubview(image)
            
            
            /*let textView = UITextView()
            let attributedString = NSMutableAttributedString(string: "before after")
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(named: "main.jpg")!

            let oldWidth = textAttachment.image!.size.width;

            let scaleFactor = oldWidth / (textView.frame.size.width - 10); //for the padding inside the textView
            textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
            let attrStringWithImage = NSAttributedString(attachment: textAttachment)
            attributedString.replaceCharacters(in: NSMakeRange(6, 1), with: attrStringWithImage)
            textView.attributedText = attributedString;
            textEditor.addSubview(textView)*/
            
            //textEditor.addSubview(self)
            //textEditor.delegate = imagePicker
            //addLeftImageTo(txtField: textEditor, andImage: imageOfOlace)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image1 = UIImageView()
        image1.image = info[.editedImage] as? UIImage
        image1.contentMode = .scaleAspectFill
        image1.clipsToBounds = true
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: image1.frame.width, height: image1.frame.height))
        textEditor.textContainer.exclusionPaths = [path]
        textEditor.addSubview(image1)
        
        
//        let image = UIImageView(image: UIImage(named: "main.jpg"))
//        let path = UIBezierPath(rect: CGRect())
//        textEditor.textContainer.exclusionPaths = [path]
//        textEditor.addSubview(image)
        //textEditor.inputAccessoryView = imageOfOlace
        //textEditor.addSubview(<#T##view: UIView##UIView#>) = imageOfOlace
//        let attachment = NSTextAttachment()
//        imageOfOlace = UIImage()
//        attachment.image = images
//
//          let attString = NSAttributedString(attachment: attachment)
//
//          textView.textStorage.insertAttributedString(attString, atIndex: textView.selectedRange.location)
        dismiss(animated: true)
    }
}
// MARK: Text field delegate

//extension EditorViewController{
//   func textFieldChanged() {
//
//        if textEditor.text?.isEmpty == false {
//            saveButton.isEnabled = true
//        } else {
//            saveButton.isEnabled = false
//        }
//    }
//}
