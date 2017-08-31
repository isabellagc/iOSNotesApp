//
//  DisplayNoteViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController {
    @IBOutlet weak var noteContentTextView: UITextView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    //note that the display should take info from
    //IMPORTANT: declared as an optional because it does not have to contain a value! could enter this view from + or add new note or from the list of notes vc with existing info 
    var note:Note?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "save" {
            // if note exists, update title and content
            let note = self.note ?? CoreDataHelper.newNote()
            note.title = noteTitleTextField.text ?? ""
            note.content = noteContentTextView.text ?? ""
            note.modificationTime = Date() as NSDate
            CoreDataHelper.saveNote()
        }
    }    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1: use if let statement to make sure that the note isnt nil
        if let note = note{
            //2: if not nil set ui components to corresponding note information
            noteTitleTextField.text = note.title
            noteContentTextView.text = note.content
        }else{
            //3: if nil set to empty as we were before!
            noteTitleTextField.text = ""
            noteContentTextView.text = ""
        }
    }
    
}
