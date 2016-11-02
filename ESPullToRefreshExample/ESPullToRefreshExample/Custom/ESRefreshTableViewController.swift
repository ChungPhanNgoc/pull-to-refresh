//
//  ESRefreshTableViewController.swift
//  ESPullToRefreshExample
//
//  Created by lihao on 16/8/18.
//  Copyright © 2016年 egg swift. All rights reserved.
//

import UIKit

public class ESRefreshTableViewController: UITableViewController {

    public var array = [String]()
    public var page = 1
    public var type: ESRefreshExampleType = .Default
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        for _ in 1...8{
            self.array.append(" ")
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = UIColor.init(red: 240/255.0, green: 239/255.0, blue: 237/255.0, alpha: 1.0)
        self.tableView.registerNib(UINib.init(nibName: "DefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "DefaultTableViewCell")
        
        var header: protocol<ESRefreshProtocol, ESRefreshAnimatorProtocol>!
        var footer: protocol<ESRefreshProtocol, ESRefreshAnimatorProtocol>!
        switch type {
        case .Default:
            header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        case .Meituan:
            header = MTRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = MTRefreshFooterAnimator.init(frame: CGRect.zero)
        case .WeChat: 
            header = WCRefreshHeaderAnimator.init(frame: CGRect.zero)
            footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        }
        
        self.tableView.es_addPullToRefresh(animator: header) {
            [weak self] in
            self?.refresh()
        }
        self.tableView.es_addInfiniteScrolling(animator: footer) {
            [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = NSStringFromClass(DefaultTableViewController) // Set refresh identifier
        self.tableView.expriedTimeInterval = 20.0 // 20 second alive.
        
    }

    private func refresh() {
        let minseconds = 3.0 * Double(NSEC_PER_SEC)
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime, dispatch_get_main_queue() , {
            self.page = 1
            self.array.removeAll()
            for _ in 1...8{
                self.array.append(" ")
            }
            self.tableView.reloadData()
            self.tableView.es_stopPullToRefresh(completion: true)
        })
    }
    
    private func loadMore() {
        let minseconds = 3.0 * Double(NSEC_PER_SEC)
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime, dispatch_get_main_queue() , {
            self.page += 1
            if self.page <= 3 {
                for _ in 1...8{
                    self.array.append(" ")
                }
                self.tableView.reloadData()
                self.tableView.es_stopLoadingMore()
            } else {
                self.tableView.es_noticeNoMoreData()
            }
        })
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.es_autoPullToRefresh()
    }
    
    // MARK: - Table view data source
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    override public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultTableViewCell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.init(white: 250.0 / 255.0, alpha: 1.0)
        return cell
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let vc = WebViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}