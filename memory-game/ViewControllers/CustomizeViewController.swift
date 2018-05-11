//
//  HelpViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class CustomizeViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var cells: [UIImage] = GameLogic.defaultCellImages
    var selIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        picker.dismiss(animated: true, completion: nil)
        guard let selectedIndexPath = selIndexPath else { return }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            changeCell(selectedIndexPath.row, image: image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let label: UILabel = cell.textLabel as! UILabel
        label.textAlignment = .right
        label.text = String(format: "Cell %d", indexPath.row+1)
        
        let imageView: UIImageView = cell.imageView as! UIImageView
        imageView.image = cells[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selIndexPath = indexPath
        changeCellPressed(indexPath.row)
    }

    private func changeCellPressed(_ index: Int) {
        let alert = UIAlertController( title: NSLocalizedString("Image source:", comment: ""), message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let PhotoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { [weak self] (action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                self?.present(picker, animated: true, completion: nil)
            }
            alert.addAction(PhotoLibraryAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: NSLocalizedString("Photo", comment: ""), style: .default) {
                [weak self] (action) in
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                self?.present(picker, animated: true, completion: nil)
            }
            alert.addAction(camera)
        }

        let URLAction = UIAlertAction(title: NSLocalizedString("Insert URL", comment: "url"), style: .default) {
            [weak self] (action) in
            self?.promptImageURL()
        }
        
        alert.addAction(URLAction)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(cancel)
        self.present(alert, animated: true) { }
    }

    private func promptImageURL() {
        let alert = UIAlertController(title: NSLocalizedString("Enter Image URL:", comment: ""), message: nil, preferredStyle: .alert)

        let enterUrl = UIAlertAction(title: NSLocalizedString("Load", comment: ""), style: .default) { [weak self] (_) in
            let textField = alert.textFields![0] as UITextField
            guard let url = URL(string: textField.text!) else { return }
            self?.loadImage(url)
        }
        
        enterUrl.isEnabled = false
        alert.addAction(enterUrl)

        alert.addTextField {
            (textField) in
            textField.placeholder = NSLocalizedString("Image URL:", comment: "")
            textField.keyboardType = .URL

            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField,
                                                   queue: OperationQueue.main) { (notification) in
                                                    enterUrl.isEnabled = textField.text != ""
            }
        }

        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel) { (action) in }
        alert.addAction(cancel)
        self.present(alert, animated: true) { }
    }

    private func loadImage(_ url: URL) {
        UIImage.downloadImage(url) { [weak self] (image: UIImage?) -> Void in
            guard let image = image else { return }
            self?.changeCell((self?.selIndexPath!.row)!, image: image)
        }
    }

    private func changeCell(_ index: Int, image: UIImage) {
        cells[index] = image
        GameLogic.defaultCellImages[index] = image
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
