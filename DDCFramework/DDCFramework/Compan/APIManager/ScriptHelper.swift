//
//  ScriptHelper.swift
//  Compan
//
//  Created by Ambu Sangoli on 7/4/22.
//

import Foundation
import JavaScriptCore

class ScriptHelper : NSObject {
    
    static let shared = ScriptHelper()
    
    var pathCreation = ""
    var url = ""

    let context = JSContext()!
    
    func checkIsVisibleEntity() {
        let mainEntities = ddcModel?.template?.sortedArray
        for entityIndex in 0..<(mainEntities?.count ?? 0) {
            if let entity = mainEntities?[entityIndex].value {
                if entity.isVisible != nil {
                    
                    self.executeScrip(parentObj: ddcModel?.template?.convertToString ?? "", scriptString: entity.isVisible!) { isHidden in
                        ddcModel?.template?.sortedArray?[entityIndex].value.isHidden = isHidden
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                        
                    }
                }
                if entity.type == .calculatedEntity && entity.calculation != nil {
                    self.executeCalculativeScrip(parentObj: ddcModel?.template?.convertToString ?? "", scriptString: entity.calculation!)
                }
                if entity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                    if let entityGroup = entity.sortedEntityGroupsArray {
                        for entityGroupIndex in 0..<(entityGroup.count ) {
                            let data = entityGroup[entityGroupIndex].value
                            for nestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                if let nestedEntity = data.sortedEntitiesArray?[nestedEntityIndex].value {
                                    if nestedEntity.isVisible != nil {
                                        self.executeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.isVisible!) { isHidden in
                                            
                                            ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.isHidden = isHidden
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                            
                                        }
                                    }
                                    if entity.type == .calculatedEntity && entity.calculation != nil {
                                        self.executeCalculativeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.calculation!)
                                    }
                                    if nestedEntity.type == .entityGroupRepeatable || entity.type == .entityGroup{
                                        if let nestedEntityGroup = nestedEntity.sortedEntityGroupsArray {
                                            for nentityGroupIndex in 0..<(nestedEntityGroup.count ) {
                                                let data = nestedEntityGroup[nentityGroupIndex].value
                                                for nnestedEntityIndex in 0..<(data.sortedEntitiesArray?.count ?? 0) {
                                                    if let nestedEntity = data.sortedEntitiesArray?[nnestedEntityIndex].value {
                                                        if nestedEntity.isVisible != nil {
                                                            self.executeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.isVisible!) { isHidden in
                                                                ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[entityGroupIndex].value.sortedEntitiesArray?[nestedEntityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.sortedEntitiesArray?[nnestedEntityIndex].value.isHidden = isHidden
                                                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
                                                            }
                                                        }
                                                        if entity.type == .calculatedEntity && entity.calculation != nil {
                                                            self.executeCalculativeScrip(parentObj: ddcModel?.template?.sortedArray?[entityIndex].value.sortedEntityGroupsArray?[nentityGroupIndex].value.convertToString ?? "", scriptString: nestedEntity.calculation!)
                                                        }

                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            }


        }
    }
    

    
    func executeScrip(parentObj:String,scriptString: String, completion: @escaping  (Bool) -> ()) {
        let template = ddcModel?.template?.convertToString ?? ""
        
//        let jsCode = "return this.entities.symptoms.value.includes(\"symptoms___1\") ; "
        let jsCode = scriptString

        let script = "\"use strict\"; function  ddcscript(templateString,parentString) { " +
        "var parent=parentString; " +
        "var template=templateString; " +
        "template.executeJSCode = function(parent) {" + jsCode + "}; " +
        "return template.executeJSCode(parent); " +
        "}";
        
        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"
        
        context.evaluateScript(stringtoint)
        context.evaluateScript(script)
        
        let result: JSValue = context.evaluateScript("ddcscript(\(template),\(parentObj));")
        print("isVisible jsScript Result - ",result)
        let boolValue = result.toBool()
        completion(!boolValue)
        
//        let parameters : [String: String] = [
//            "jsCode" : scriptString,
//            "parent" : parentObj,
//            "template" : ddcModel?.template?.convertToString ?? ""
//        ]
        
//        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//
//        ERProgressHud.shared.show()
//        APIManager.sharedInstance.makeRequestToExecuteDDCScript(jsonString: jsonString, data: jsonData){ (success, response,statusCode)  in
//            if (success) {
//                ERProgressHud.shared.hide()
//                print(response)
//                let isHidden = !response
//                completion(isHidden)
//            } else {
//                completion(true)
////                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                ERProgressHud.shared.hide()
//            }
//        }
    }
    
    
    func executeCalculativeScrip(parentObj:String,scriptString: String) {
        let template = ddcModel?.template?.convertToString ?? ""
        
//        let jsCode = "return this.entities.symptoms.value.includes(\"symptoms___1\") ; "
        let jsCode = scriptString

        let script = "\"use strict\"; function  ddcscript(templateString,parentString) { " +
        "var parent=parentString; " +
        "var template=templateString; " +
        "template.executeJSCode = function(parent) {" + jsCode + "}; " +
        "return template.executeJSCode(parent); " +
        "}";
        
        let stringtoint = "function stringToInt(value) { return (value && !Number.isNaN(value) ? parseInt(value, 10) : NaN) }"
        
        context.evaluateScript(stringtoint)
        context.evaluateScript(script)
        
        let result1s: JSValue = context.evaluateScript("ddcscript(\(template),\(parentObj));")
        print("Calculative jsScript Result - ",result1s)
//        let parameters : [String: String] = [
//            "jsCode" : scriptString,
//            "parent" : parentObj,
//            "template" : ddcModel?.template?.convertToString ?? ""
//        ]
//        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
//        print(jsonString)
//
//        ERProgressHud.shared.show()
//        APIManager.sharedInstance.makeRequestToExecuteCalculativeDDCScript(jsonString: jsonString, data: jsonData){ (success, response,statusCode)  in
//            if (success) {
//                ERProgressHud.shared.hide()
//                print(response)
//            } else {
//                APIManager.sharedInstance.showAlertWithMessage(message: ERROR_MESSAGE_DEFAULT)
//                ERProgressHud.shared.hide()
//            }
//        }
    }
    
    
}
