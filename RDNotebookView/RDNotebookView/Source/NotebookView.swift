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

open class NotebookViewCell: UIView {
    
    fileprivate var zOrder = Int.zero
    
}

fileprivate class NotebookViewCellWrapper: UIView {
    
}

@objc public protocol NotebookViewDataSource: class {
    
    @objc func numberOfSectionsInNotebookView(_ notebookView: NotebookView) -> Int
    
    @objc func notebookView(_ notebookView: NotebookView, cellForRowAtIndexPath indexPath: IndexPath) -> NotebookViewCell
    
}

@objc public protocol NotebookViewDelegate: UIScrollViewDelegate {
    
    @objc optional func notebookView(_ notebookView: NotebookView, didSelectRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func notebookView(_ notebookView: NotebookView, willLoadRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func notebookView(_ notebookView: NotebookView, didLoadRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func notebookView(_ notebookView: NotebookView, willUnloadRowAtIndexPath indexPath: IndexPath)
    
    @objc optional func notebookView(_ notebookView: NotebookView, didUnloadRowAtIndexPath indexPath: IndexPath)
    
}

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
    
    @IBOutlet open weak var dataSource: NotebookViewDataSource?
    @IBOutlet open weak var delegate: NotebookViewDelegate?
    
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
    
    open func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    {
        self.notebookViewCellNibs[identifier] = nib
    }
    
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
