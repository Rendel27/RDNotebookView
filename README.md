## RDNotebookView
[![Version](https://img.shields.io/cocoapods/v/RDNotebookView.svg?style=flat)](http://cocoapods.org/pods/RDNotebookView)
[![License](https://img.shields.io/cocoapods/l/RDNotebookView.svg?style=flat)](https://github.com/Rendel27/RDNotebookView/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/RDNotebookView.svg?style=flat)](http://cocoapods.org/pods/RDNotebookView)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](http://swift.org)



RDNotebookView is a scrollable notebook component for iOS applications.
NotebookView mechanism works mostly the same way as UITableView does.



![](https://raw.githubusercontent.com/Rendel27/RDNotebookView/master/RDNotebookView/RDNotebookViewExample/Resources/Gifs/vertical.gif) ![](https://raw.githubusercontent.com/Rendel27/RDNotebookView/master/RDNotebookView/RDNotebookViewExample/Resources/Gifs/horizontal.gif)



## Installation

- **Manually**  
- ***As Open Source:***
1. Download RDNotebookView project  
2. Drag n drop the Source folder into your project (Make sure that you tick on Copy if needed checkbox)  
- ***As Embedded Framework:***
1. Download RDNotebookView project  
2. Build it for desired target  
3. Copy it into your project directory  
4. In Xcode navigator select project >> General >> Embedded Binaries: click + button and select RDNotebookView framework.


- **[CocoaPods](https://cocoapods.org)**  

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
target 'ProjectName' do
# For latest version:
    pod 'RDNotebookView'
end
```
Run `pod install`, and you should now have the latest RDNotebookView release.



## Usage
All you need to do is to import the library and start coding:
```ruby
import RDNotebookView
```



## Requirements
- Swift 5.0 or later



## Author
Giorgi Iashvili, me@rendel.ge



## License
RDNotebookView is available under the MIT license. See the LICENSE file for more info.
