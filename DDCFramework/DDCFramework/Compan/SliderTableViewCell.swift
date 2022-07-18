//
//  SliderTableViewCell.swift
//  Compan
//
//  Created by Ambu Sangoli on 5/24/22.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var uriLbl: UILabel!
    
    var data : DDCFormModel?
    var indexPath : IndexPath?
    var entity : Entity?
    var entityGroupId: String = ""
    var parentEntityGroupId = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupSliderCell(data: DDCFormModel,entity: Entity, indexPath: IndexPath ,entityGroupId: String,parentEntityGroupId:String = "99") {
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
        if let entity = dataa {
            let minValue = Int(entity.settings?.min ?? 0)
            let maxValue = Int(entity.settings?.max ?? 0)
            self.valueSlider.minimumValue = Float(minValue)
            self.valueSlider.maximumValue = Float(maxValue)
            let valueString = entity.value?.value as? String
            if valueString == "" || valueString == nil {
                self.valueSlider.value = Float(minValue)
                self.valueLabel.text = minValue.description
            } else {
                self.valueSlider.value = Float(valueString!) ?? 0
                self.valueLabel.text = valueString
            }
//            let array = (minValue...maxValue).map { $0 }
//            for i in array {
//                self.values.append(String(i))
//            }
        }
    }
    
    @IBAction func valueChanged(_ sender: UISlider) {
        self.valueSlider.value = Float(Int(round(sender.value)))
        self.valueLabel.text = Int(round(sender.value)).description
//        RequestHelper.shared.createRequestForEntity(data: self.data!, index: self.indexPath!, newValue: Int(round(sender.value)).description)
        RequestHelper.shared.createRequestForEntity(entity: self.entity!, newValue: Int(round(sender.value)).description, entityGroupId: entityGroupId,parentEntityGroupId: parentEntityGroupId)
    }
    
    
    

}

