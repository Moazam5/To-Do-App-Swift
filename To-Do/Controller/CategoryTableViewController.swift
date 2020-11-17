//
//  CategoryTableViewController.swift
//  To-Do
//
//  Created by Moazam Mir on 11/8/20.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    var categoryArray : [Category]?
    var itemsArray : [Item]?
    var rowAtIndexPath : Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCategoryButtonPressed))
        rightBarButton.tintColor = ContrastColorOf(.red, returnFlat: true)
      //  self.navigationItem.rightBarButtonItem = rightBarButton

        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.separatorStyle = .none
       // configureNavBar()
        loadData()
        
    }
    

    
    func configureNavBar()
    {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(.red, returnFlat: true)]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(.red, returnFlat: true)]
            navBarAppearance.backgroundColor = .red
           // navBarAppearance.backgroundImage = UIImage(named: "neat-1.jpg")

            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        navBar.backgroundColor = UIColor(named: "#1D9BF6")
        configureNavBar()
        
        loadData()
    }
    
    @IBAction func addCategoryButton(_ sender: UIBarButtonItem)
    {
        
    }
    @objc func addCategoryButtonPressed()
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: "Add New Category", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Groceries"
            textField = alertTextField
        }
        let alertAction = UIAlertAction(title: "Add", style: .default) { (addAction) in

            if textField.text != ""
            {
                let newCategory = Category(context : self.context)
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                newCategory.priority = false
                self.categoryArray?.append(newCategory)
                self.saveData()
                
                
            }
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for : indexPath) as! CategoryTableViewCell
        
        if let item = categoryArray?[indexPath.row]
        {
            cell.categoryLabel.text = item.name
            cell.containerView.backgroundColor = UIColor(hexString: item.color ?? "#1D9BF6")
            cell.categoryLabel.textColor = ContrastColorOf(UIColor(hexString: item.color!)!, returnFlat: true)
            cell.itemsCompletedLabel.text = "\( 0) / \(itemsArray?.count ?? 0) item"
            cell.itemsCompletedLabel.textColor = ContrastColorOf(UIColor(hexString: item.color!)!, returnFlat: true)
            cell.itemsCompletedLabel.isHidden = true
            cell.iconImageView.image = UIImage(named: item.image ?? "money.jpg")
            if item.priority {
                cell.preferredImageView.isHidden = false
                print("called")
            }else
            {
                cell.preferredImageView.isHidden = true

            }
        }
    
        
        return cell
    }
    
    //MARK:- Table View Delegate Methods
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
       rowAtIndexPath = indexPath.row
        
      performSegue(withIdentifier: "showItemVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let indexPath = rowAtIndexPath
        {
            let itemVC = segue.destination as! ItemViewController
            itemVC.selectedCategory = self.categoryArray?[indexPath]
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
          //  self.tableView.deleteRows(at: [indexPath], with: .fade)
            let alert = UIAlertController(title: "Are You Sure You Want to Delete The Entire List?",
                                          message: "This action cannot be undone!", preferredStyle: .alert)
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
        
        let favoriteAction = UITableViewRowAction(style: .normal, title: "Priority") { (action, indexPath) in
            
            self.categoryArray![indexPath.row].priority = !self.categoryArray![indexPath.row].priority
            tableView.reloadData()
        }

        favoriteAction.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

        return [deleteAction, favoriteAction]
    }
        
    
    //MARK:- Save and Load Data Methods
    func saveData()
    {
        do
        {
            try context.save()
            tableView.reloadData()
        }
        catch
        {
            print("Error saving category, \(error)")
        }
    }
    
    func loadData()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do
        {
            categoryArray = try context.fetch(request)
            tableView.reloadData()

        }catch
        {
            print("Error getting categories data, \(error)")
            
        }
    }

     func updateData(at indexPath : IndexPath)
    {
        if let categoryForDeletion = categoryArray?[indexPath.row]
        {
            context.delete(categoryForDeletion)
            categoryArray?.remove(at: indexPath.row)
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving category, \(error)")
            }
        }
        
    }
    
    
}
