//
//  CheckBoxTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 23/05/22.
//

//
//  RadioButtonTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 16/05/22.
//

import UIKit
import SelectionList

class CheckBoxTableViewCell: UITableViewCell {

    @IBOutlet var selectionList: SelectionList!
    @IBOutlet weak var uriLbl: UILabel!
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""

    var parentEntityGroupId = ""
    var fieldValueArray = [String]()
    var fieldIdArray = [String]()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCheckBoxCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99") {
        self.entityGroupId = entityGroupId
        self.entity = entity
        self.data = data
        self.indexPath = indexPath
        self.parentEntityGroupId = parentEntityGroupId
        let dataa : Entity? = entity
//        if data.template?.entities![indexPath.section].type == .entityGroupRepeatable {
//            dataa = data.template?.entities![indexPath.section].entityGroups![0].entities![indexPath.row]
//        } else {
//            dataa = data.template?.entities![indexPath.section]
//        }
             
//        let dropDownSet = data.valueSet?.filter{ $0.refID!.localizedCaseInsensitiveContains((dataa!.valueSetRef)!)}
//
//        let dropDownValue = dropDownSet?.first?.valueSetData
//
        var fieldValueArray = [String]()
        var fieldIDArray = [String]()
//
        let valueArray : [String] = (dataa?.value?.value as? [String]) ?? []
        var selectedIndex: [Int]? = []


        let dropDownSet = data.valueSet?[(dataa?.valueSetRef!)!]
        for i in 0..<(dropDownSet?.count ?? 0) {
            let item = dropDownSet![i]
            fieldValueArray.append(item.values.first!)
            fieldIDArray.append(item.keys.first!)
            for value in valueArray {
            if item.keys.first! == value {
                selectedIndex?.append(i)
            }
        }
        }
        
        self.fieldValueArray = fieldValueArray
        self.fieldIdArray = fieldIDArray


        //Set title
        //uriLbl.text = data.template?.entities?[index].uri

        selectionList.items = fieldValueArray
        selectionList.allowsMultipleSelection = true
        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        selectionList.setupCell = { (cell: UITableViewCell, _: Int) in
            cell.textLabel?.textColor = .gray
        }
        //selectionList.frame.size.height = 1000
        if let indexes = selectedIndex {
            selectionList.selectedIndexes = indexes
        }

    }

    @objc func selectionChanged() {
        print(selectionList.selectedIndexes)
        var values = [String]()
        for index in selectionList.selectedIndexes {
            values.append(self.fieldIdArray[index])
        }
        print(values)
//        let valueString = values.joined(separator: ",")
//        RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: valueString)
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: values, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId)

    }

}
