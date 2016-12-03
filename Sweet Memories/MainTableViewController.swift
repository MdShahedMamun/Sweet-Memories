//
//  MainTableViewController.swift
//  Sweet Memories
//
//  Created by Mac air on 11/26/16.
//  Copyright © 2016 Mac air. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController,NSFetchedResultsControllerDelegate,UISearchResultsUpdating{
    // an array of objects
    var sweetMemories:[SweetMemory] = []
    
    var fetchResultController:NSFetchedResultsController<NSFetchRequestResult>!
    
    var searchController:UISearchController!
    var searchResults:[SweetMemory] = []
    
    var postShown = [Bool](repeating: false, count: 100000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove the title of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Enable self sizing cells
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Load the restaurants from database
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SweetMemory")
        // fetching data sorted by title
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
            
            // only one
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                // an array of objects
                sweetMemories = fetchResultController.fetchedObjects as! [SweetMemory]
            } catch {
                print(error)
            }
        }
        
        // Adding a search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // Customize the appearance of the search bar
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.6)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return sweetMemories.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainTableViewCell
        
        let sweetMemory = (searchController.isActive) ? searchResults[indexPath.row] : sweetMemories[indexPath.row]
        
        // Configure the cell...
        cell.title.text = sweetMemory.title;
        cell.thumbnailImageView.image = UIImage(data: sweetMemory.image! as Data)
        cell.note.text = sweetMemory.note;
        
        cell.date.text=sweetMemory.date;
//        print("inside MainTableViewController")
//        print(sweetMemory.date);
        
        return cell
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! DetailTableViewController
                destinationController.sweetMemory = (searchController.isActive) ? searchResults[indexPath.row] : sweetMemories[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHomeScreen(_ segue:UIStoryboardSegue){
        
    }
    
    // Creating a Rotation/Translation Effect Using CATransform3D
    override func tableView(_ tableView: UITableView, willDisplay cell:
        UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Determine if the post is displayed. If yes, we just return and no animation will be created
        if postShown[indexPath.row] {
            return
        }
        
        // Indicate the post has been displayed, so the animation won't be displayed again
        postShown[indexPath.row] = true
        
        // Define the initial state (Before the animation)
        // Rotation
        let rotationAngleInRadians = 90.0 * CGFloat(M_PI/180.0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians,
                                                          0, 0, 1)
        
        // Translation
        //        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500,
        //                                                       100, 0)
        
        cell.layer.transform = rotationTransform
        // Define the final state (After the animation)
        UIView.animate(withDuration: 1.0, animations: { cell.layer.transform =
            CATransform3DIdentity })
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            sweetMemories.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action, indexPath) -> Void in
            
            let defaultText = "Write something... " + self.sweetMemories[indexPath.row].title+self.sweetMemories[indexPath.row].note
            if let imageToShare = UIImage(data: self.sweetMemories[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        
        // Delete button
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
            
            // Delete the row from the database
            if let managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext {
                
                let restaurantToDelete = self.fetchResultController.object(at: indexPath) as! SweetMemory
                managedObjectContext.delete(restaurantToDelete)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        })
        
        // Set the buttons color
        shareAction.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        deleteAction.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        return [deleteAction, shareAction]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let _newIndexPath = newIndexPath {
                tableView.insertRows(at: [_newIndexPath], with: .fade)
            }
        case .delete:
            if let _indexPath = indexPath {
                tableView.deleteRows(at: [_indexPath], with: .fade)
            }
        case .update:
            if let _indexPath = indexPath {
                tableView.reloadRows(at: [_indexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        sweetMemories = controller.fetchedObjects as! [SweetMemory]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContentForSearchText(searchText)
            tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchResults = sweetMemories.filter({ (sweetMemory:SweetMemory) -> Bool in
            let nameMatch = sweetMemory.title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return nameMatch != nil
        })
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
