//
//  ViewController.swift
//  To-Do
//
//  Created by Moazam Mir on 11/7/20.
//

import UIKit
import CoreData
import ChameleonFramework

class ItemViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray : [Item]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add bar button
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addButtonTapped))
        searchBar.delegate = self
        tableView.rowHeight = 80.0
        
        if let colorHex = selectedCategory?.color
        {
            navigationController?.navigationBar.backgroundColor = UIColor(hexString: colorHex)
        }
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "itemCell")
        
          
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            title = selectedCategory!.name
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
            }
       
            
            if let navBarColor = UIColor(hexString: colorHex) {
               
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                searchBar.barTintColor = navBarColor
            }
        }
    }
  
    
    
   
    @objc func addButtonTapped()
    {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item To Your List", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Buy Eggs"
            textField = alertTextField
        }
        let alertAction = UIAlertAction(title: "Add", style: .default) { (addAction) in

            if textField.text != ""
            {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory

                self.itemArray?.append(newItem)
                self.saveItems()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Data Manipulation Methods
    func saveItems()
    {
        do
        {
            try context.save()
            tableView.reloadData()

        }
        catch{
            print("Error encoding data \(error)")
        }
    }

    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil)
    {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        
        if let newPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, newPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
            do
            {
                itemArray = try context.fetch(request)
             
            }
            catch
            {
                print("Error decoding data, \(error)")
            }
       
        tableView.reloadData()

        
    }
    
    
     func updateData(at indexPath : IndexPath)
    {
        context.delete((itemArray?[indexPath.row])!)
        itemArray!.remove(at: indexPath.row)
        print("Successfully deleted data")
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving category, \(error)")
        }
    }

    //MARK:- Table View Data Source Methods

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemCell

//        cell.itemNumberLabel.text = "\(indexPath.row + 1)"
        if let item = itemArray?[indexPath.row]
        {
            cell.itemTitleLabel.text = item.title
            cell.accessoryType = (item.done)  ? .checkmark : .none
           
             
            if let color = UIColor(hexString : selectedCategory!.color!)?.darken(byPercentage : (CGFloat (indexPath.row))/(CGFloat(itemArray!.count)))
            {
                cell.containerView.backgroundColor = color
                cell.itemTitleLabel.textColor = ContrastColorOf(color, returnFlat : true)
//                cell.itemNumberLabel.textColor = ContrastColorOf(color, returnFlat : true)
                 
            }
        }
       
       
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]
        {
            item.done = !item.done
        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

  
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let alert = UIAlertController(title: " Delete Item?",
                                          message: "", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
                self.updateData(at: indexPath)
                tableView.reloadData()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
                self.dismiss(animated: true, completion: nil)
            }
          
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            print("delete action")
        }
        
        deleteAction.backgroundEffect = UIVisualEffect()
        
      


        return [deleteAction]
    }
        

}



//MARK:- Search Bar Methods

extension ItemViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request , predicate:  predicate)
        
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("This is the new text \(searchText)")
        if searchText.count == 0
        {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadData()
        }
    }
    

}
