//
//  NavMenuController.swift
//  STDebuggerMacOS
//
//  Created by 刘小二 on 2019/8/18.
//  Copyright © 2019 euming. All rights reserved.
//

class NavMenuController : NSViewController {
   
    public lazy var items: [NavMenuItem] = {
        return [.network, .userDefaults]
    }()
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    @IBOutlet weak var scrollView: NSScrollView!
    
    var selectedIndexPath: Set<IndexPath>?
}

extension NavMenuController {
    override func mouseDown(with event: NSEvent) {
        
    }
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NSNib(nibNamed: "NavMenuItemController" as NSNib.Name, bundle: Bundle.init(for: NavMenuController.self)), forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("NavMenuItemController"))
        collectionView.isSelectable = true
        scrollView.verticalScroller = nil;
        collectionView.allowsEmptySelection = false
        collectionView.backgroundColors = [NSColor.clear]
        
        // 默认选择第一个
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let item = self.collectionView.item(at: IndexPath(item: 0, section: 0))
            item?.highlightState = NSCollectionViewItem.HighlightState.forSelection
            item?.isSelected = true
        }
        
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
    }
}


extension NavMenuController: NSCollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {

        let navItem = items[indexPath.item]
        
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("NavMenuItemController"), for: indexPath) as! NavMenuItemController
        item.icon.image = NSImage(named: navItem.iconName)
        item.name.stringValue = navItem.title
        return item
    }
}


extension NavMenuController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        selectedIndexPath = indexPaths
        
        let index = indexPaths.first?.item ?? 0
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: menuNavToggleIndexNotification), object: index)
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: collectionView.bounds.width, height: 50)
    }
    
    
}




extension NavMenuController {

    public struct NavMenuItem {
        var iconName: String;
        var title: String;
        
        static let network = NavMenuItem(iconName: NSImage.bonjourName, title: "网络Proxy")
        static let userDefaults = NavMenuItem(iconName: NSImage.statusNoneName, title: "偏好设置")
    }
}
