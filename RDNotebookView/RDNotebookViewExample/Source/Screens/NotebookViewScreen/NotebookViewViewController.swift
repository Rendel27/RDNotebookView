//
//  NotebookViewViewController.swift
//  RDNotebookViewExample
//
//  Created by Giorgi Iashvili on 1/14/20.
//  Copyright © 2020 Giorgi Iashvili
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RDNotebookView

class NotebookViewViewController: UIViewController {
    
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var notebookView: NotebookView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.notebookView.register(UINib(nibName: "ViewNotebookViewCell", bundle: nil), forCellReuseIdentifier: "ViewNotebookViewCell")
        self.notebookView.reloadData()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognized(sender:))))
    }
    
}

// MARK: - Actions
extension NotebookViewViewController {
    
    @objc private func tapGestureRecognized(sender: UITapGestureRecognizer) {
        self.textField.resignFirstResponder()
    }
    
    @IBAction private func scrollDirectionClicked(sender: UIButton)
    {
        self.notebookView.scrollsHorizontally = !self.notebookView.scrollsHorizontally
        self.notebookView.reloadData()
        sender.setTitle(self.notebookView.scrollsHorizontally ? "Horizontal" : "Vertical", for: .normal)
    }
    
    @IBAction private func reloadDataClicked(sender: UIButton)
    {
        self.notebookView.reloadData()
    }
    
    @IBAction private func scrollToTheBeginingClicked(sender: UIButton)
    {
        self.notebookView.scrollTo(section: 0, animated: true)
    }
    
    @IBAction private func scrollToTheEndClicked(sender: UIButton)
    {
        self.notebookView.scrollTo(section: self.notebookView.numberOfSections - 1, animated: true)
    }
    
}

// MARK: - NotebookViewDataSource
extension NotebookViewViewController: NotebookViewDataSource {
    
    func numberOfSectionsInNotebookView(_ notebookView: NotebookView) -> Int
    {
        let count = (self.textField.text as NSString?)?.integerValue ?? .zero
        return count
    }
    
    func notebookView(_ notebookView: NotebookView, cellForRowAtIndexPath indexPath: IndexPath) -> NotebookViewCell
    {
        let cell = notebookView.dequeueReusableCell(withIdentifier: "ViewNotebookViewCell") as? ViewNotebookViewCell ?? ViewNotebookViewCell()
        let index = indexPath.section * 2 + indexPath.row
        let colors = [UIColor.red, UIColor.green, UIColor.blue]
        let color = colors[index % colors.count]
        cell.fill(withIndex: index, color: color)
        return cell
    }
    
}

// MARK: - NotebookViewDelegate
extension NotebookViewViewController: NotebookViewDelegate {
    
    func notebookView(_ notebookView: NotebookView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        print("didSelectRowAtIndexPath: \(indexPath)")
    }
    
    func notebookView(_ notebookView: NotebookView, willLoadRowAtIndexPath indexPath: IndexPath)
    {
        print("willLoadRowAtIndexPath: \(indexPath)")
    }

    func notebookView(_ notebookView: NotebookView, didLoadRowAtIndexPath indexPath: IndexPath)
    {
        print("didLoadRowAtIndexPath: \(indexPath)")
    }

    func notebookView(_ notebookView: NotebookView, willUnloadRowAtIndexPath indexPath: IndexPath)
    {
        print("willUnloadRowAtIndexPath: \(indexPath)")
    }

    func notebookView(_ notebookView: NotebookView, didUnloadRowAtIndexPath indexPath: IndexPath)
    {
        print("didUnloadRowAtIndexPath: \(indexPath)")
    }
    
}
