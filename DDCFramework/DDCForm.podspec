Pod::Spec.new do |spec|

  spec.name         = "DDCForm"
  spec.version      = "1.0.0"
    spec.requires_arc = true
  spec.summary      = "This is form framework"
  spec.description  = "Framework for form module"
  spec.homepage     = "https://github.com/santoshn547/DDCForm"
  spec.license      = "MIT"
  spec.author       = { "Santosh Naidu" => "santoshn547@gmail.com" }
  spec.platform     = :ios, "15.0"
  spec.source       = { :git => "https://github.com/santoshn547/DDCForm.git", :tag => spec.version.to_s }

    #spec.source_files  = "DDCFramework/**/**"
        spec.source_files = "DDCFramework/**/*.{swift}"
        spec.resources = "DDCFramework/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    

    spec.framework  = "UIKit"
    spec.dependency "KXJsonUI"
    spec.dependency "Alamofire", "~> 4.7"
    spec.dependency "SCLAlertView"
    spec.dependency "NVActivityIndicatorView"
    spec.dependency "BiometricAuthentication"
    spec.dependency "KeychainSwift", "~> 11.0"
    spec.dependency "SwiftyJSON"
    spec.dependency "DropDown"
    spec.dependency "IQKeyboardManagerSwift"
    spec.dependency "SwiftyGif"
    spec.dependency "lottie-ios"
    spec.dependency "SwiftyMenu", "~> 1.0.1"
    spec.dependency "iOSDropDown", "0.3.4"
    spec.dependency "SelectionList"
    spec.dependency "DatePickerDialog"
    
    spec.swift_version = "5.5.1"

end
