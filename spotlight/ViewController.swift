//
//  ViewController.swift
//  spotlight
//
//  Created by Nikolai Prokofev on 2020-01-03.
//  Copyright © 2020 Nikolai Prokofev. All rights reserved.
//

import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

class ViewController: UITableViewController {
    
    var projects: [[String]] = []
    var favorites: [Int] = [] {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(favorites, forKey: "favorites")
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
        
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favorites")
            as? [Int] {favorites = savedFavorites
        }
        
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
    }
    
    func populate() {
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = projects[indexPath.row]
        cell.textLabel?.attributedText = makeAttributedString(title: project[0], subtitle: project[1])
        if favorites.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let index = favorites.firstIndex(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item: indexPath.row)
            }
        } else if editingStyle == .insert {
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return favorites.contains(indexPath.row) ? .delete : .insert
    }
    
    func index(item: Int) {
        let project = projects[item]
        let attributedSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributedSet.title = project[0]
        attributedSet.contentDescription = project[1]
        
        let item = CSSearchableItem(uniqueIdentifier: String(describing: item), domainIdentifier: "com.nprokofev", attributeSet: attributedSet)
        
        CSSearchableIndex.default().indexSearchableItems([item], completionHandler: { error in
            print(error?.localizedDescription ?? "Success")
        })
    }
    
    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [String(describing: item)], completionHandler: { error in
            print(error?.localizedDescription ?? "Success")
        })
    }
    
    func makeAttributedString(title: String, subtitle: String)->NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.purple]
        let subttileAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subttileAttributes)
        titleString.append(subtitleString)
        return titleString
    }
    
    func showTutorial(_ which: Int) {
        
        if let url = URL(string: "https://www.hackingwithswift.com/read/\(which + 1)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration:
                config)
            present(vc, animated: true)
        }
    }
    
}
