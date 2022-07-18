//
//  DDCInitiate.swift
//  DDCFramework
//
//  Created by Ambu Sangoli on 7/14/22.
//

import Foundation
import UIKit

public struct DDCInitiate {
    
    public static func add(a:Int,b:Int) -> Int {
        return a + b
    }
    
    public static func subtract(a:Int,b:Int) -> Int {
        return a - b
    }
    
    public static func multiply(a:Int,b:Int) -> Int {
        return a * b
    }
    
    
    public static func openViewController() {
        let frameworkBundle = Bundle(for: InitialViewController.self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:frameworkBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "InitialViewController") as! InitialViewController
        let navVc = UINavigationController(rootViewController: vc)
//        viewController.presentViewController(nextViewController, animated:true, completion:nil)
        UIApplication.shared.windows.first?.rootViewController = navVc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
}
