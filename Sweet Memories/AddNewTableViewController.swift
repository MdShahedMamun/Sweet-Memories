//
//  AddNewTableViewController.swift
//  Sweet Memories
//
//  Created by Mac air on 11/26/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit
import CoreData;

class AddNewTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var imageView:UIImageView!
    @IBOutlet var titleTextField:UITextField!;
    @IBOutlet var noteTextView:UITextView!;
    
    var sweetMemory:SweetMemory!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: imageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender:UIBarButtonItem) {
        let title = titleTextField.text
        let note = noteTextView.text
        
        // Validate input fields
        if title == "" || note == ""{
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            sweetMemory = NSEntityDescription.insertNewObject(forEntityName: "SweetMemory", into: managedObjectContext) as! SweetMemory
            sweetMemory.title = title!
            sweetMemory.note = note!
            
            let date = Date();
            let dateFormatter = DateFormatter()
            //To prevent displaying either date or time, set the desired style to NoStyle.
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
//            dateFormatter.timeZone = DateFormatter.timeZone
            let localDate = dateFormatter.string(from: date)
            
            print("UTC Time")
            print(date)
            print("Local Time")
            print(localDate)
            
            sweetMemory.date=localDate;
//            print("inside addNewTableViewController")
//            print(date);
//            print(localDate);
//            print(sweetMemory.date);
            
            if let restaurantImage = imageView.image {
                sweetMemory.image = UIImagePNGRepresentation(restaurantImage)
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
                return
            }
        }
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
