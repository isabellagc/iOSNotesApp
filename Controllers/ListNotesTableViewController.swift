//
//  ListNotesTableViewController.swift
//  MakeSchoolNotes
//
//  Created by Chris Orcutt on 1/10/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//

import UIKit
import CoreData

class ListNotesTableViewController: UITableViewController {
    //extends UITableViewController kind of like when we extended RecycleViewAdapter class in android--> interface builder can find this and set it as the custom class for our view controller
    
    //our tableviewcontroller must have an aray of notes to keep track for the display!
    var notes = [Note](){
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = CoreDataHelper.retrieveNotes()
    }
    
    // 1 : get number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 3: changed so it casts the cell given back as a specific view that we created in our Views folder! 
        //SYNTAX: using 'as!' is called downcasting- tell the compiler we expect the dequeue method to return a very specific type of cell. works because the ListNotesTableViewCell is a subclass of UITableViewCell so we can return it as our output val.
        let cell = tableView.dequeueReusableCell(withIdentifier: "listNotesTableViewCell", for: indexPath) as! ListNotesTableViewCell
        
        // 4: since we cast it we know that the cell has to have these properties which we defined in our class!
        //FIRST: GET APPROPRIATE NOTE OBJECT FROM OUR ARRAY then put vals in !
        let row = indexPath.row
        let note = notes[row]
        
        cell.noteTitleLabel.text = note.title
        cell.noteModificationTimeLabel.text = note.modificationTime!.convertToString()

        // 5
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //1: store the identifier of segue that has been triggered in var identifier
        if let identifier = segue.identifier{
            //2: check if the segue is the one we identified with the id displayNote in the storyboard
            if identifier ==  "displayNote"{
                // 1: check what the selected row is and get index path which has info on the cell u clicked on
                //WE KNOW TABLEVIEW.INDEXPATH... IS NOT NIL BC ONLY WAY WE ENTER THIS BLOCK IS IF IDENTIFIER == CONDITION SO USER MUST HAVE CLICKED ON A NOTE IE A CELL. 
                let indexPath = tableView.indexPathForSelectedRow!
                // 2: retrieve note corresponding to that row in the table view controller
                let note = notes[indexPath.row]
                // 3: get the destination of this segue (a view controller) which we happen to know is of type displaynoteiview controller which HAPPENS to have a note as a property!!
                let displayNoteViewController = segue.destination as! DisplayNoteViewController
                // 4: set the note of our destination as the note we just picked out of our data model :)
                displayNoteViewController.note = note
                
            }else if identifier == "addNote"{
                print("+ button clicked")
            }
            
        }
    }
    
    // 1: override the tableView function that has to do with editing style to set specifics to what we do on an editing even t
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 2: make sure the editing style was 'delete'
        if editingStyle == .delete {
            //1
            CoreDataHelper.delete(note: notes[indexPath.row])
            //2
            notes = CoreDataHelper.retrieveNotes()
        }
    }
    
    
    //CREATING UNWIND SEGUE: put it here bc we want to end up in this view controller again. will be called from all actions that should bring us back to this view
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue) {
        self.notes = CoreDataHelper.retrieveNotes()
    }
}
