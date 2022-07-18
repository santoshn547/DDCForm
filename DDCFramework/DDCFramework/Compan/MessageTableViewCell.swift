//
//  MessageTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/24/22.
//

import UIKit
import WebKit

class MessageTableViewCell: UITableViewCell, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var uriLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tableView: UITableView?
    var index: Int?
    
    func setUpMessageCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath, tableView: UITableView ) {
        let dataa : Entity? = entity
//        if data.template?.sortedArray![indexPath.section].value.type == .entityGroupRepeatable {
//            dataa = data.template?.sortedArray![indexPath.section].value.entityGroups![0].sortedArray![indexPath.row].value
//            } else {
//                dataa = data.template?.sortedArray![indexPath.section].value
//            }
        self.tableView = tableView
        self.index = indexPath.row
        if let entity = dataa {
        uriLbl.text = entity.uri
            self.webView.scrollView.isScrollEnabled = false
            webView.loadHTMLString("<meta name='viewport' content='width=device-width, shrink-to-fit=YES'>" + entity.title!, baseURL: nil)
        webView.frame.size = webView.scrollView.contentSize
            webView.navigationDelegate = self
        }

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.webViewHeight.constant = height as! CGFloat
//            if let i = self.index {
//                let cell = self.tableView?.cellForRow(at: IndexPath(item: i, section: 0))
//                cell?.layoutSubviews()
//                cell?.layoutIfNeeded()
//                self.tableView?.layoutSubviews()
//                self.tableView?.layoutIfNeeded()
//            }
        })
        
        
    }


}
