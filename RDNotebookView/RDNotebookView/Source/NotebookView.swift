//
//  NotebookView.swift
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

/// RDNotebookView: The visual representation of a single row in a notebook view.
open class NotebookViewCell: UIView {
    
    fileprivate var zOrder = Int.zero
    
}

fileprivate class NotebookViewCellWrapper: UIView {
    
}

/// RDNotebookView: The methods adopted by the object you use to manage data and provide cells for a notebook view.
///
/// Notebook views manage only the presentation of their data; they do not manage the data itself. To manage the data, you provide the notebook with a data source object—that is, an object that implements the NotebookViewDataSource protocol. A data source object responds to data-related requests from the notebook. It also manages the notebooks's data directly, or coordinates with other parts of your app to manage that data. Other responsibilities of the data source object include:
/// * Reporting the number of sections in the notebook.
/// * Providing cells for each row of the notebook.
/// * Configuring the notebook's index, if any.
/// * Responding to user- or notebook-initiated updates that require changes to the underlying data.
///
/// Only two methods of this protocol are required, and they are shown in the following example code.
///
/// ````
/// // Return the number of sections for the notebook.
/// override func numberOfSectionsInNotebookView(_ notebookView: NotebookView) -> Int {
///    // NOTE: Number of sections should always be more than 0.
///    return 1
/// }
///
/// // Provide a cell object for each row.
/// override func notebookView(_ notebookView: NotebookView, cellForRowAtIndexPath indexPath: IndexPath) -> NotebookViewCell {
///    // Fetch a cell of the appropriate type.
///    let cell = notebookView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier")
///
///    // Configure the cell’s contents. For example:
///    cell.textLabel.text = "Cell text"
///
///    return cell
/// }
/// ````
///
/// There is no numberOfRows method in this protocol as there are always 2 rows per section.
@objc public protocol NotebookViewDataSource: class {
    
    /// RDNotebookView: Asks the data source to return the number of sections in the notebook view.
    ///
    /// - important: NOTE: This method should always return a greater number than 0.
    ///
    /// - parameter notebookView: An object representing the notebook view requesting this information.
    ///
    /// - returns: The number of sections in notebookView.
    @objc func numberOfSectionsInNotebookView(_ notebookView: NotebookView) -> Int
    
    /// RDNotebookView: Asks the data source for a cell to insert in a particular location of the notebook view.
    ///
    /// In your implementation, create and configure an appropriate cell for the given index path. Create your cell using the notebook view's dequeueReusableCell(withIdentifier:) method, which recycles or creates the cell for you. After creating the cell, update the properties of the cell with appropriate data values.
    /// - important: Never call this method yourself. If you want to retrieve cells from your notebook, call the notebook view's cellForRow(at:) method instead.
    ///
    /// - parameter notebookView: A notebook-view object requesting the cell.
    /// - parameter indexPath: An index path locating a row in notebookView.
    ///
    /// - returns: An object inheriting from NotebookViewCell that the notebook view can use for the specified row.
    @objc func notebookView(_ notebookView: NotebookView, cellForRowAtIndexPath indexPath: IndexPath) -> NotebookViewCell
    
}

/// RDNotebookView: Methods for managing selections and informing about cell lifecycle.
///
/// Use the methods of this protocol to manage the following features:
/// * Respond to row selections.
/// * Get informed about row lifecycle and additional stuff as needed.
///
/// The notebook view specifies rows and sections using IndexPath objects.
@objc public protocol NotebookViewDelegate: UIScrollViewDelegate {
    
    /// RDNotebookView: Tells the delegate that the specified row is now selected.
    ///
    /// - parameter notebookView: A notebook-view object informing the delegate about the new row selection.
    /// - parameter indexPath: An index path locating the new selected row in notebookView.
    @objc optional func notebookView(_ notebookView: NotebookView, didSelectRowAtIndexPath indexPath: IndexPath)
    
    /// RDNotebookView: Tells the delegate the notebook view is about to load a cell for a particular row.
    ///
    /// A notebook view sends this message to its delegate just before it uses cell to draw a row, thereby permitting the delegate to customize the cell object before it is displayed. This method gives the delegate a chance to override state-based properties set earlier by the notebook view, such as background color. After the delegate returns, the notebook view sets only the frame property, and then only when animating rows as they slide in or out.
    ///
    /// - parameter notebookView: The notebook-view object informing the delegate of this impending event.
    /// - parameter indexPath: An index path locating the row in notebookView.
    @objc optional func notebookView(_ notebookView: NotebookView, willLoadRowAtIndexPath indexPath: IndexPath)
    
    /// RDNotebookView: Tells the delegate the notebook view has loaded a cell for a particular row.
    ///
    /// A notebook view sends this message to its delegate just after it uses cell to draw a row, thereby permitting the delegate to customize the cell object after it is displayed.
    ///
    /// - parameter notebookView: The notebook-view object informing the delegate of this impending event.
    /// - parameter indexPath: An index path locating the row in notebookView.
    @objc optional func notebookView(_ notebookView: NotebookView, didLoadRowAtIndexPath indexPath: IndexPath)
    
    /// RDNotebookView: Tells the delegate that the specified cell will be unloaded from the notebook.
    ///
    /// Use this method to detect when a cell will be unloaded from a notebook view, as opposed to monitoring the view itself to see when it appears or disappears.
    ///
    /// - parameter notebookView: The notebook-view object that will unload the view.
    /// - parameter indexPath: The index path of the cell.
    @objc optional func notebookView(_ notebookView: NotebookView, willUnloadRowAtIndexPath indexPath: IndexPath)
    
    /// RDNotebookView: Tells the delegate that the specified cell was unloaded from the notebook.
    ///
    /// Use this method to detect when a cell is unloaded from a notebook view, as opposed to monitoring the view itself to see when it appears or disappears.
    ///
    /// - parameter notebookView: The notebook-view object that unloaded the view.
    /// - parameter indexPath: The index path of the cell.
    @objc optional func notebookView(_ notebookView: NotebookView, didUnloadRowAtIndexPath indexPath: IndexPath)
    
}

/// RDNotebookView: A view that presents data using rows arranged in a single column.
///
/// Notebook views on iOS display a single column of vertically or horizonally scrolling content, divided into rows. Each row in the notebook contains one piece of your app’s content. For example, the Contacts app displays the name of each contact in a separate row, and the main page of the Settings app displays the available groups of settings. You can configure a notebook to display group rows into sections to make navigating the content easier. Each group always contains 2 rows.
///
/// Notebooks are commonly used by apps whose data is highly structured or organized hierarchically. Apps that contain hierarchical data often use notebooks in conjunction with a navigation view controller, which facilitates navigation between different levels of the hierarchy. For example, the Settings app uses notebooks and a navigation controller to organize the system settings.
///
/// NotebookView manages the basic appearance of the notebook, but your app provides the cells (NotebookViewCell objects) that display the actual content. The standard cell configurations display a simple combination of text and images, but you can define custom cells that display any content you want.
open class NotebookView: UIView {
    
    fileprivate final class ScrollView: UIScrollView {
        
        var scrollsHorizontally: Bool = false
        var separatorSize: CGFloat = .zero
        
        override var contentOffset: CGPoint
        {
            didSet
            {
                self.contentView.frame = self.scrollsHorizontally ?
                    CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.frame.width + self.separatorSize, height: self.frame.height) :
                    CGRect(x: self.contentOffset.x, y: self.contentOffset.y, width: self.frame.width, height: self.frame.height + self.separatorSize)
            }
        }
        
        let contentView = UIView()
        
        required init?(coder aDecoder: NSCoder)
        {
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect)
        {
            super.init(frame: frame)
            
            self.initialize()
        }
        
        override func awakeFromNib()
        {
            super.awakeFromNib()
            
            self.initialize()
        }
        
        private func initialize()
        {
            self.setupContentView()
            
            self.clipsToBounds = false
            self.layer.masksToBounds = false
        }
        
        private func setupContentView()
        {
            self.contentView.backgroundColor = .clear
            self.contentView.clipsToBounds = false
            self.contentView.layer.masksToBounds = false
            super.addSubview(self.contentView)
        }
        
        override func addSubview(_ view: UIView)
        {
            self.contentView.addSubview(view)
        }
        
        override func insertSubview(_ view: UIView, at index: Int)
        {
            self.contentView.insertSubview(view, at: index)
        }
        
        /// RDExtensionsSwift: Remove all subviews of the receiver
        fileprivate override func removeAllSubviews()
        {
            for sv in self.contentView.subviews
            {
                sv.removeFromSuperview()
            }
        }
        
    }
    
    /// RDNotebookView: This property specifies the scroll direction
    ///
    /// The notebook layout scrolls along one axis only, either horizontally or vertically.
    ///
    /// Set `true` as a value of this property to make notebook horizontally scrollable.
    ///
    /// Set `false` as a value of this property to make notebook vertically scrollable.
    @IBInspectable open var scrollsHorizontally: Bool { get { return self.scrollView.scrollsHorizontally } set { self.scrollView.scrollsHorizontally = newValue } }
    @IBInspectable fileprivate var separatorSize: CGFloat { get { return self.scrollView.separatorSize } set { self.scrollView.separatorSize = newValue } }
    
    private let scrollView = ScrollView()
    private var notebookViewCellWrappers: [NotebookViewCellWrapper?] = []
    private var notebookViewCellUniqueWrappers: [NotebookViewCellWrapper] = []
    private let maxNotebookViewCellUniqueWrappers = 3
    private var scrollingAngleRatio: CGFloat = 1
    private var previousContentOffset = CGPoint.zero
    private var lastIndex = Int.zero
    
    private var notebookViewCellNibs: [String: UINib] = [:]
    private var notebookViewCells: [String: [NotebookViewCell]] = [:]
    private let reservedViewCellsCount = 2
    
    private var notebookViewCellSize: CGSize
    {
        get
        {
            return self.scrollsHorizontally ?
                CGSize(width: self.frame.width / 2 - self.separatorSize / 2, height: self.frame.height) :
                CGSize(width: self.frame.width, height: self.frame.height / 2 - self.separatorSize / 2)
        }
    }
    
    /// RDNotebookView: The object that acts as the data source of the notebook view.
    @IBOutlet open weak var dataSource: NotebookViewDataSource?
    
    /// RDNotebookView: The object that acts as the delegate of the notebook view.
    @IBOutlet open weak var delegate: NotebookViewDelegate?
    
    /// RDNotebookView: The number of sections in the notebook view.
    open private(set) var numberOfSections = Int.zero
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.initialize()
    }
    
    private func initialize()
    {
        self.setupScrollView()
    }
    
    private func setupScrollView()
    {
        self.scrollView.isUserInteractionEnabled = true
        self.scrollView.backgroundColor = .clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
    }
    
    private func setupNotebookViewCellWrappers()
    {
        self.setupNotebookViewCellUniqueWrappersArray()
        
        self.setupNotebookViewCellWrappersArray(forIndex: .zero)
    }
    
    private func setupNotebookViewCellUniqueWrappersArray()
    {
        self.notebookViewCellUniqueWrappers.iterableForEach { $0.removeAllSubviews(); $0.removeFromSuperview() }
        self.notebookViewCellUniqueWrappers = []
        
        let wrappersCount = self.numberOfSections - 1
        let uniqueWrappersCount = min(wrappersCount, self.maxNotebookViewCellUniqueWrappers)
        for i in .zero ..< uniqueWrappersCount
        {
            let notebookViewCellWrapper = NotebookViewCellWrapper()
            notebookViewCellWrapper.layer.anchorPoint = self.scrollsHorizontally ? CGPoint(x: .zero, y: 0.5) : CGPoint(x: 0.5, y: .zero)
            self.scrollView.insertSubview(notebookViewCellWrapper, at: uniqueWrappersCount - i + 1)
            self.notebookViewCellUniqueWrappers.append(notebookViewCellWrapper)
        }
    }
    
    private func setupNotebookViewCellWrappersArray(forIndex index: Int)
    {
        self.notebookViewCellWrappers = []
        
        let wrappersCount = self.numberOfSections - 1
        
        if(index == .zero)
        {
            self.notebookViewCellWrappers += self.notebookViewCellUniqueWrappers
            self.notebookViewCellWrappers += Array(repeating: nil, count: max(.zero, wrappersCount - self.notebookViewCellWrappers.count))
        }
        else if(index == wrappersCount - 1)
        {
            self.notebookViewCellWrappers += Array(repeating: nil, count: wrappersCount - self.notebookViewCellUniqueWrappers.count)
            self.notebookViewCellWrappers += self.notebookViewCellUniqueWrappers
        }
        else
        {
            self.notebookViewCellWrappers += Array(repeating: nil, count: (.zero ..< index - 1).count)
            self.notebookViewCellWrappers += self.notebookViewCellUniqueWrappers
            self.notebookViewCellWrappers += Array(repeating: nil, count: max(.zero, wrappersCount - self.notebookViewCellWrappers.count))
        }
    }
    
    private func clearNotebookViewCellWrappers()
    {
        self.scrollView.removeAllSubviews()
        self.notebookViewCellWrappers = []
    }
    
    private func moveNotebookViewCellWrappers()
    {
        let contentOffsetPoint = self.scrollsHorizontally ? self.scrollView.contentOffset.x : self.scrollView.contentOffset.y
        let previousContentOffsetPoint = self.scrollsHorizontally ? self.previousContentOffset.x : self.previousContentOffset.y
        let scrollViewFrameSize = self.scrollsHorizontally ? self.scrollView.frame.width : self.scrollView.frame.height
        let scrollViewContentSize = self.scrollsHorizontally ? self.scrollView.contentSize.width : self.scrollView.contentSize.height
        
        var directionIsForward = true
        if(contentOffsetPoint > previousContentOffsetPoint)
        {
            directionIsForward = true
        }
        else if(contentOffsetPoint < previousContentOffsetPoint)
        {
            directionIsForward = false
        }
        var index: Int
        if directionIsForward {
            index = self.notebookViewCellWrappers.count - Int((scrollViewContentSize - contentOffsetPoint) / scrollViewFrameSize)
        } else {
            index = max(.zero, min(Int(contentOffsetPoint / scrollViewFrameSize), self.notebookViewCellWrappers.count - 1))
        }
        
        var isNotebookViewCellWrappersDisplayed = false
        if(self.notebookViewCellWrappers[index] == nil)
        {
            isNotebookViewCellWrappersDisplayed = true
            self.notebookViewCellWrappers.iterableForEach { $0?.removeAllSubviews() }
            self.setupNotebookViewCellWrappersArray(forIndex: index)
            
            let indices: [Int]
            let rotationAngles: [CGFloat]
            if(index == .zero)
            {
                indices = Array(.zero ..< self.notebookViewCellUniqueWrappers.count)
                rotationAngles = [PI, .zero, .zero]
            }
            else if(index == self.notebookViewCellWrappers.count - 1)
            {
                indices = Array(self.notebookViewCellWrappers.count - self.notebookViewCellUniqueWrappers.count ..< self.notebookViewCellWrappers.count)
                rotationAngles = [PI, PI, PI]
            }
            else
            {
                indices = Array(index - 1 ... index + 1)
                rotationAngles = [PI, .zero, .zero]
            }
            for i in .zero ..< indices.count
            {
                let ind = indices[i]
                let rotationAngle = rotationAngles[i]
                self.removeCells(atIndex: ind, directionIsForward: directionIsForward)
                self.apply(transform: Transform3DMakeRotation(rotationAngle), toWrapper: self.notebookViewCellWrappers[ind])
                self.displayCells(atIndex: ind)
                self.reorderCells(atIndex: ind, rotationAngle: rotationAngle)
            }
        }
        
        if(self.lastIndex != index)
        {
            self.apply(transform: Transform3DMakeRotation(self.lastIndex < index ? PI : .zero), toWrapper: self.notebookViewCellWrappers[self.lastIndex])
            
            self.lastIndex = index
            
            if(self.notebookViewCellWrappers.count > self.maxNotebookViewCellUniqueWrappers && !isNotebookViewCellWrappersDisplayed)
            {
                if(index > .zero && index < self.notebookViewCellWrappers.count - 1)
                {
                    if(directionIsForward && self.notebookViewCellWrappers[index + 1] == nil)
                    {
                        let lowIndex = self.notebookViewCellWrappers.firstIndex { $0 != nil }!
                        let highIndex = index + 1
                        self.removeCells(atIndex: lowIndex, directionIsForward: directionIsForward)
                        self.notebookViewCellWrappers.swapAt(lowIndex, highIndex)
                        self.apply(transform: Transform3DMakeRotation(.zero), toWrapper: self.notebookViewCellWrappers[highIndex])
                    }
                    else if(!directionIsForward && self.notebookViewCellWrappers[index - 1] == nil)
                    {
                        let highIndex = self.notebookViewCellWrappers.lastIndex { $0 != nil }!
                        let lowIndex = index - 1
                        self.removeCells(atIndex: highIndex, directionIsForward: directionIsForward)
                        self.notebookViewCellWrappers.swapAt(highIndex, lowIndex)
                        self.apply(transform: Transform3DMakeRotation(PI), toWrapper: self.notebookViewCellWrappers[lowIndex])
                    }
                }
            }
            
            if(!isNotebookViewCellWrappersDisplayed)
            {
                self.displayCells(forIndex: index, directionIsForward: directionIsForward, redisplayCurrent: false)
            }
            
            if(index == 1 && directionIsForward)
            {
                self.removeEdgeCell(atIndexPath: [.zero, .zero])
            }
            else if(index == self.notebookViewCellWrappers.count - 1 - 1 && !directionIsForward)
            {
                self.removeEdgeCell(atIndexPath: [self.notebookViewCellWrappers.count, 1])
            }
            
            if(index == .zero)
            {
                self.displayEdgeCell(atIndexPath: [.zero, .zero])
            }
            else if(index == self.notebookViewCellWrappers.count - 1)
            {
                self.displayEdgeCell(atIndexPath: [self.notebookViewCellWrappers.count, 1])
            }
        }
        
        var modOffset = CGFloat(fmod(Double(contentOffsetPoint), Double(scrollViewFrameSize)))
        if(modOffset == .zero)
        {
            if(directionIsForward)
            {
                modOffset = self.scrollsHorizontally ? self.scrollView.frame.width : self.scrollView.frame.height
            }
            else
            {
                modOffset = .zero
            }
        }
        
        let rotationAngle = modOffset / self.scrollingAngleRatio
//        let m34Angle = modOffset / self.scrollingAngleRatio
//        let m34Rate = m34Angle * 500 / (PI/2)
//        let m34Sign = -1 // rotationAngle >= .zero && rotationAngle < PI/2 ? -1 : 1
//        let m34 = m34Rate == .zero ? .zero : 1 / m34Rate * CGFloat(m34Sign)
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500 // m34
        self.apply(transform: Transform3DRotate(transform, rotationAngle), toWrapper: self.notebookViewCellWrappers[index])
        if(self.notebookViewCellWrappers[index] == nil)
        {
            print("Couldn't display cells at section: \(index)")
        }
        
        self.reorderWrappers(forIndex: index)
        self.reorderCells(forIndex: index, rotationAngle: rotationAngle)
        
        self.previousContentOffset = self.scrollView.contentOffset
    }
    
    private func removeCells(atIndex index: Int, directionIsForward: Bool)
    {
        self.delegate?.notebookView?(self, willUnloadRowAtIndexPath: [index, 1])
        self.delegate?.notebookView?(self, willUnloadRowAtIndexPath: [index + (directionIsForward ? 1 : -1), .zero])
        self.notebookViewCellWrappers[index]?.removeAllSubviews()
        self.delegate?.notebookView?(self, didUnloadRowAtIndexPath: [index, 1])
        self.delegate?.notebookView?(self, didUnloadRowAtIndexPath: [index + (directionIsForward ? 1 : -1), .zero])
    }
    
    private func displayCells(forIndex index: Int, directionIsForward: Bool, redisplayCurrent: Bool = true)
    {
        if redisplayCurrent {
            self.displayCells(atIndex: index)
        }
        let i = index + (directionIsForward ? 1 : -1)
        if(i >= .zero && i < self.notebookViewCellWrappers.count)
        {
            self.displayCells(atIndex: i)
        }
    }
    
    private func displayCells(atIndex index: Int)
    {
        self.notebookViewCellWrappers[index]?.removeAllSubviews()
        
        self.delegate?.notebookView?(self, willLoadRowAtIndexPath: [index, 1])
        if let cell = self.dataSource?.notebookView(self, cellForRowAtIndexPath: [index, 1])
        {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell.frame = (self.notebookViewCellWrappers[index]?.bounds ?? .zero).integral
            cell.zOrder = 2
            self.notebookViewCellWrappers[index]?.addSubview(cell)
            self.delegate?.notebookView?(self, didLoadRowAtIndexPath: [index, 1])
        }
        
        self.delegate?.notebookView?(self, willLoadRowAtIndexPath: [index + 1, .zero])
        if let cell = self.dataSource?.notebookView(self, cellForRowAtIndexPath: [index + 1, .zero])
        {
            cell.transform = self.scrollsHorizontally ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: -1)
            cell.frame = (self.notebookViewCellWrappers[index]?.bounds ?? .zero).integral
            cell.zOrder = 1
            self.notebookViewCellWrappers[index]?.addSubview(cell)
            self.delegate?.notebookView?(self, didLoadRowAtIndexPath: [index + 1, .zero])
        }
    }
    
    private func reorderCells(forIndex index: Int, rotationAngle: CGFloat)
    {
        if(index > .zero)
        {
            self.reorderCells(atIndex: index - 1, rotationAngle: PI)
        }
        self.reorderCells(atIndex: index, rotationAngle: rotationAngle)
        if(index < self.notebookViewCellWrappers.count - 1)
        {
            self.reorderCells(atIndex: index + 1, rotationAngle: .zero)
        }
    }
    
    private func reorderCells(atIndex index: Int, rotationAngle: CGFloat)
    {
        if let wrapper = self.notebookViewCellWrappers[index]
        {
            self.reorderCells(forNotebookViewCellWrapper: wrapper, rotationAngle: rotationAngle)
        }
    }
    
    private func reorderCells(forNotebookViewCellWrapper wrapper: NotebookViewCellWrapper, rotationAngle: CGFloat)
    {
        let condition = self.scrollsHorizontally ? rotationAngle > PI / 2 : rotationAngle < PI / 2
        
        if let bottomCell = (wrapper.subviews as? [NotebookViewCell])?.first(where: { $0.zOrder == 1 })
        {
            wrapper.insertSubview(bottomCell, at: condition ? 0 : 1)
        }
        if let topCell = (wrapper.subviews as? [NotebookViewCell])?.first(where: { $0.zOrder == 2 })
        {
            wrapper.insertSubview(topCell, at: condition ? 1 : 0)
        }
    }
    
    private func reorderWrappers(forIndex index: Int)
    {
        var index = index
        if(index == self.notebookViewCellWrappers.count - 1)
        {
            index = self.notebookViewCellWrappers.count
        }
        for i in .zero ..< index
        {
            if let wrapper = self.notebookViewCellWrappers[i]
            {
                self.scrollView.insertSubview(wrapper, at: i + 1 + 1)
            }
        }
        for i in stride(from: self.notebookViewCellWrappers.count - 1, to: index - 1, by: -1)
        {
            if let wrapper = self.notebookViewCellWrappers[i]
            {
                self.scrollView.addSubview(wrapper)
            }
        }
    }
    
    private func removeEdgeCell(atIndexPath indexPath: IndexPath)
    {
        if let view = self.scrollView.contentView.subviews.first(where: {
            ($0 as? NotebookViewCell)?.zOrder == .zero &&
                (indexPath.row == .zero ?
                    (self.scrollsHorizontally ?
                        $0.frame.origin.x == .zero :
                        $0.frame.origin.y == .zero) :
                    (self.scrollsHorizontally ?
                        $0.frame.origin.x == self.frame.width / 2 + self.separatorSize / 2 :
                        $0.frame.origin.y == self.frame.height / 2 + self.separatorSize / 2))
        })
        {
            self.delegate?.notebookView?(self, willUnloadRowAtIndexPath: indexPath)
            view.removeFromSuperview()
            self.delegate?.notebookView?(self, didUnloadRowAtIndexPath: indexPath)
        }
    }
    
    private func displayEdgeCell(atIndexPath indexPath: IndexPath)
    {
        self.removeEdgeCell(atIndexPath: indexPath)
        
        self.delegate?.notebookView?(self, willLoadRowAtIndexPath: indexPath)
        if let cell = self.dataSource?.notebookView(self, cellForRowAtIndexPath: indexPath)
        {
            cell.frame = self.scrollsHorizontally ?
                CGRect(x: indexPath.row == .zero ? .zero : self.frame.width / 2 + self.separatorSize / 2,
                       y: .zero,
                       width: self.notebookViewCellSize.width,
                       height: self.notebookViewCellSize.height) :
                CGRect(x: .zero,
                       y: indexPath.row == .zero ? .zero : self.frame.height / 2 + self.separatorSize / 2,
                       width: self.notebookViewCellSize.width,
                       height: self.notebookViewCellSize.height)
            cell.layer.transform = CATransform3DIdentity
            cell.zOrder = .zero
            self.scrollView.insertSubview(cell, at: 0)
            self.delegate?.notebookView?(self, didLoadRowAtIndexPath: indexPath)
        }
    }
    
    /// NotebookView: Registers a nib object containing a cell with the notebook view under a specified identifier.
    ///
    /// Before dequeueing any cells, call this method to tell the notebook view how to create new cells. If a cell of the specified type is not currently in a reuse queue, the notebook view uses the provided information to create a new cell object automatically.
    ///
    /// If you previously registered a nib file with the same reuse identifier, the nib you specify in the nib parameter replaces the old entry. You may specify nil for nib if you want to unregister the nib from the specified reuse identifier.
    /// - parameter nib: A nib object that specifies the nib file to use to create the cell.
    /// - parameter identifier: The reuse identifier for the cell. This parameter must not be nil and must not be an empty string.
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    {
        self.notebookViewCellNibs[identifier] = nib
    }
    
    /// NotebookView: Returns a reusable notebook-view cell object located by its identifier.
    ///
    /// For performance reasons, a notebook view’s data source should generally reuse NotebookViewCell objects when it assigns cells to rows in its notebookView(_:cellForRowAt:) method. A notebook view maintains a queue or list of NotebookViewCell objects that the data source has marked for reuse. Call this method from your data source object when asked to provide a new cell for the notebook view. This method dequeues an existing cell if one is available or creates a new one using the nib file you previously registered. If no cell is available for reuse and you did not register a nib file, this method returns nil.
    ///
    /// - parameter identifier: A string identifying the cell object to be reused. This parameter must not be nil.
    ///
    /// - returns: A NotebookViewCell object with the associated identifier or nil if no such object exists in the reusable-cell queue.
    open func dequeueReusableCell(withIdentifier identifier: String) -> NotebookViewCell
    {
        let notebookViewCell = self.loadNotebookViewCell(forIdentifier: identifier) ?? self.instantiateNotebookViewCell(forIdentifier: identifier)
        self.addNotebookViewCellIfNeeded(notebookViewCell, forIdentifier: identifier)
        return notebookViewCell
    }
    
    private func instantiateNotebookViewCell(forIdentifier identifier: String) -> NotebookViewCell
    {
        guard let nib = self.notebookViewCellNibs[identifier] else
        {
            fatalError("There is no nib registered for identifier: \(identifier)")
        }
        guard let notebookViewCell = (nib.instantiate(withOwner: nil, options: nil) as? [NotebookViewCell])?.first else
        {
            fatalError("Coul'd not load notebook view cell from nib with identifier: \(identifier)")
        }
        return notebookViewCell
    }
    
    private func loadNotebookViewCell(forIdentifier identifier: String) -> NotebookViewCell?
    {
        return self.notebookViewCells[identifier]?.first { $0.superview == nil }
    }
    
    private func addNotebookViewCellIfNeeded(_ notebookViewCell: NotebookViewCell, forIdentifier identifier: String)
    {
        if(self.loadNotebookViewCell(forIdentifier: identifier) == nil)
        {
            if(self.notebookViewCells[identifier]?.isEmpty != false)
            {
                self.notebookViewCells[identifier] = [notebookViewCell]
            }
            else
            {
                self.notebookViewCells[identifier]?.append(notebookViewCell)
            }
        }
    }
    
    private func removeNotebookViewCellsIfNeeded(forIdentifier identifier: String)
    {
        if let count = self.notebookViewCells[identifier]?.filter({ $0.superview == nil }).count,
            count > self.reservedViewCellsCount
        {
            self.notebookViewCells[identifier]?.remove(first: count - self.reservedViewCellsCount) { $0.superview == nil }
        }
    }
    
    /// NotebookView: Reloads the rows and sections of the notebook view.
    ///
    /// Call this method to reload all the data that is used to construct the notebook, including cells, index arrays, and so on. For efficiency, the notebook view redisplays only those rows that are visible. The notebook view’s delegate or data source calls this method when it wants the notebook view to completely reload its data.
    open func reloadData()
    {
        self.scrollView.setContentOffset(.zero, animated: false)
        self.scrollView.contentSize = .zero
        
        self.clearNotebookViewCellWrappers()
        
        self.numberOfSections = self.dataSource?.numberOfSectionsInNotebookView(self) ?? .zero
        
        if(self.numberOfSections < .zero)
        {
            fatalError("Number of sections in notebook view must be more or equal to 0")
        }
        if(self.numberOfSections > .zero)
        {
            self.setupNotebookViewCellWrappers()
            
            self.updateSubviewsLayout()
            
            self.displayEdgeCell(atIndexPath: [.zero, .zero])
            if(self.numberOfSections > 1)
            {
                self.displayCells(forIndex: .zero, directionIsForward: true)
                self.reorderWrappers(forIndex: .zero)
                self.reorderCells(atIndex: .zero, rotationAngle: .zero)
            }
            if(self.numberOfSections >= 1 && self.numberOfSections <= 2)
            {
                self.displayEdgeCell(atIndexPath: [self.notebookViewCellWrappers.count, 1])
            }
        }
    }
    
    /// NotebookView: Scrolls through the notebook view until a section identified by the first given parameter is at a particular location on the screen.
    ///
    /// Invoking this method does not cause the delegate to receive a scrollViewDidScroll(_:) message, as is normal for programmatically invoked user interface operations.
    ///
    /// - parameter section: Aa integer that identifies a section in the notebook view.
    /// - parameter animated: `true` if you want to animate the change in position; `false` if it should be immediate.
    open func scrollTo(section: Int, animated: Bool)
    {
        self.scrollView.setContentOffset(
            self.scrollsHorizontally ?
                CGPoint(x: CGFloat(section) * self.scrollView.frame.width, y: self.scrollView.contentOffset.y) :
                CGPoint(x: self.scrollView.contentOffset.x, y: CGFloat(section) * self.scrollView.frame.height)
            , animated: animated)
    }
    
    fileprivate func Transform3DRotate(_ t: CATransform3D, _ angle: CGFloat) -> CATransform3D
    {
        return self.scrollsHorizontally ? CATransform3DRotate(t, angle, .zero, 1, .zero) : CATransform3DRotate(t, angle, 1, .zero, .zero)
    }
    
    fileprivate func Transform3DMakeRotation(_ angle: CGFloat) -> CATransform3D
    {
        return self.scrollsHorizontally ? CATransform3DMakeRotation(angle, .zero, 1, .zero) : CATransform3DMakeRotation(angle, 1, .zero, .zero)
    }
    
    fileprivate var PI: CGFloat { get { return self.scrollsHorizontally ? -.pi : .pi } }
    
    private func apply(transform: CATransform3D, toWrapper wrapper: NotebookViewCellWrapper?)
    {
        let offset = self.scrollsHorizontally ?
            self.separatorSize / 2 / .pi * transform.yAxisAngle :
            self.separatorSize / 2 / .pi * transform.xAxisAngle
        wrapper?.layer.transform = CATransform3DTranslate(transform, .zero, offset, .zero)
    }
    
}

// MARK: - Override Methods
extension NotebookView {
    
    private func updateSubviewsLayout()
    {
        self.scrollView.frame = self.bounds
        self.scrollView.contentSize = self.scrollsHorizontally ?
            CGSize(width: self.scrollView.frame.width * CGFloat(self.notebookViewCellWrappers.count + 1), height: self.scrollView.frame.height) :
            CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height * CGFloat(self.notebookViewCellWrappers.count + 1))
        
        self.scrollingAngleRatio = self.scrollsHorizontally ?
            self.scrollView.frame.width / PI :
            self.scrollView.frame.height / PI
        
        for notebookViewCellWrapper in self.notebookViewCellWrappers
        {
            notebookViewCellWrapper?.frame = self.scrollsHorizontally ?
                CGRect(x: self.bounds.width / 2 + self.separatorSize / 2, y: .zero, width: self.bounds.width / 2, height: self.bounds.height) :
                CGRect(x: .zero, y: self.bounds.height / 2 + self.separatorSize / 2, width: self.bounds.width, height: self.bounds.height / 2)
        }
    }
    
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.updateSubviewsLayout()
    }
    
}

// MARK: - UIScrollViewDelegate
extension NotebookView: UIScrollViewDelegate {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.moveNotebookViewCellWrappers()
        
        self.delegate?.scrollViewDidScroll?(scrollView)
    }
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidZoom?(scrollView)
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDragging?(scrollView)
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(decelerate == false)
        {
            self.setContentOffset()
        }
        
        self.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setContentOffset()
        
        self.delegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.delegate?.viewForZooming?(in: scrollView)
    }
    
    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.delegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.delegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.delegate?.scrollViewShouldScrollToTop?(scrollView) == true
    }
    
    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    @available(iOS 11.0, *)
    open func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
    
    private func setContentOffset()
    {
        self.scrollView.setContentOffset(
            self.scrollsHorizontally ?
                CGPoint(x: self.scrollView.contentOffset.x < (CGFloat(self.lastIndex) * self.scrollView.frame.width) + self.scrollView.frame.width / 2 ? (CGFloat(self.lastIndex) * self.scrollView.frame.width) : (CGFloat(self.lastIndex + 1) * self.scrollView.frame.width), y: self.scrollView.contentOffset.y) :
                CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y < (CGFloat(self.lastIndex) * self.scrollView.frame.height) + self.scrollView.frame.height / 2 ? (CGFloat(self.lastIndex) * self.scrollView.frame.height) : (CGFloat(self.lastIndex + 1) * self.scrollView.frame.height))
            , animated: true)
    }
    
}

fileprivate extension CATransform3D {
    
    var xAxisAngle: CGFloat { get { return atan2(self.m23, self.m33) } }
    var yAxisAngle: CGFloat { get { return atan2(self.m31, self.m11) } }
    var zAxisAngle: CGFloat { get { return atan2(self.m12, self.m11) } }
    
}

fileprivate extension UIView {
    
    /// RDExtensionsSwift: Remove all subviews of the receiver
    @objc func removeAllSubviews()
    {
        for sv in self.subviews
        {
            sv.removeFromSuperview()
        }
    }
    
}

fileprivate extension Collection {
    
    /// RDExtensionsSwift: Iterable For Each with element and index
    func iterableForEach(_ body: @escaping (Element) -> Void)
    {
        self.iterableForEach { item, _ in
            body(item)
        }
    }
    
    /// RDExtensionsSwift: Iterable For Each with element and index
    func iterableForEach(_ body: @escaping (Element, Int) -> Void)
    {
        var index = Int.zero
        for item in self
        {
            body(item, index)
            index += 1
        }
    }
    
    /// RDExtensionsSwift: Removes all first n elements that conform the closure
    mutating func remove(first: Int, where block: @escaping (Element) -> Bool)
    {
        self.remove(first: first) { element, _ -> Bool in
            return block(element)
        }
    }
    
    /// RDExtensionsSwift: Removes all first n elements that conform the closure
    mutating func remove(first: Int, where block: @escaping (Element, Int) -> Bool)
    {
        self = self.removing(first: first, where: block)
    }
    
    /// RDExtensionsSwift: Returns a collection containing all but the first n elements that conform the closure
    func removing(first: Int, where block: @escaping (Element) -> Bool) -> Self
    {
        return self.removing(first: first, where: { element, _ -> Bool in
            return block(element)
        })
    }
    
    /// RDExtensionsSwift: Returns a collection containing all but the first n elements that conform the closure
    func removing(first: Int, where block: @escaping (Element, Int) -> Bool) -> Self
    {
        var collection: [Element] = []
        var counter = Int.zero
        var index = Int.zero
        for item in self
        {
            if(counter == first || !block(item, index))
            {
                collection.append(item)
            }
            else
            {
                counter += 1
            }
            index += 1
        }
        return collection as! Self
    }
    
}
