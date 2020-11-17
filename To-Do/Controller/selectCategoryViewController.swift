//
//  selectCategoryViewController.swift
//  To-Do
//
//  Created by Moazam Mir on 11/17/20.
//

import UIKit
import CoreData

class selectCategoryViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    var imageNumber  =  -1
    var imageArray = ["book-1.jpg", "neat-1.jpg", "money.jpg"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        let navBarColor = UIColor.red
           
            navBar.backgroundColor = navBarColor
        navBar.tintColor = .white//ContrastColorOf(navBarColor, returnFlat: true)
        
//            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
//            searchBar.barTintColor = navBarColor
        
        }
    
    
    @IBAction func doneChoosingCategory(_ sender: UIBarButtonItem)
    {
        if textField.text != "" && imageNumber >= 0
        {
            print(imageNumber)
            
            
            let newCategory = Category(context : self.context)
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            newCategory.priority = false
            newCategory.image = imageArray[imageNumber]
            

            self.saveData()
            
            
            navigationController?.popViewController(animated: true)

            dismiss(animated: true, completion: nil)
        }
        else if (imageNumber == -1)
        {
            
                let alert = UIAlertController(title: "Please Select a Picture", message: "", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Empty Title", message: "Please Enter the title for the category you want to create", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func saveData()
    {
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
    extension selectCategoryViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return imageArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.reuseID, for: indexPath) as? CustomCollectionViewCell
           // cell?.iconView.image = UIImage(named: "money.jpg")
        
            return cell!
        }
        
    }

    extension selectCategoryViewController: UICollectionViewDelegate {
        
        /// - Tag: highlight
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            
            imageNumber = indexPath.row
        }
        
        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = nil
            }
        }
        
        /// - Tag: selection
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
                cell.showIcon()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
                cell.hideIcon()
            }
        }
    }



