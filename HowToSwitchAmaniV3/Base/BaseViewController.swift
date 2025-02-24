//
//  BaseViewController.swift
//  HowToSwitchAmaniV3
//
//  Created by Bedri Doğan on 18.01.2025.
//
import UIKit

class BaseViewController: UIViewController {
  
    //  let orientation: UIInterfaceOrientationMask = .portrait
  var navBarFontColor: String = "#000000"
//  var navbarRightButtonAction:VoidCallback? = nil
//  var navbarLeftButtonAction: VoidCallback? = nil
  
    // MARK: - Life cycle methods
  override func viewDidLoad() {
    
      //    rotateScreen(orientation: orientation)
    self.navigationController?.delegate = self
    
    super.viewDidLoad()
      //    self.locationManager.delegate = self
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.baseSetup()
    self.navigationController?.navigationBar.isHidden = false
  }
  
  private func baseSetup() {
    self.setThemeColor()
//    self.setupFirstPop()
    self.navigationController?.navigationBar.isHidden = false
    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }
  
  func setThemeColor() {

    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(hexString: "001AFF")
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    appearance.shadowColor = .clear
    self.navigationController?.navigationBar.standardAppearance = appearance
    self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    self.navigationController?.navigationBar.isTranslucent = true
    self.view.backgroundColor = UIColor(hexString: "ffffff")
    self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: "001AFF")
    
      // Setup bottom line
    
    if let navigationBar = self.navigationController?.navigationBar {
      
      let existingLineView = navigationBar.viewWithTag(1001)
      
      if existingLineView == nil {
        
        navigationBar.setValue(true, forKey: "hidesShadow")
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        lineView.backgroundColor = UIColor(hexString: "#CACFD6")
        lineView.tag = 1001
        
        navigationBar.addSubview(lineView)
        
          // Set up constraints
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.widthAnchor.constraint(equalTo: navigationBar.widthAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.centerXAnchor.constraint(equalTo: navigationBar.centerXAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
      }
    }
    
  }
  
  @objc
  func popToCustomerVC() {
    if(self.navigationController?.viewControllers.count == 1) {
      self.navigationController?.dismiss(animated: true)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  func setupFirstPop() {
    if (self.navigationController?.viewControllers.count == 1) {
      self.setPopButton()
    }
  }
  
  func setPopButton(TintColor:String? = nil) {
    let leftButton: UIButton = UIButton(type: .custom)
    leftButton.setImage(UIImage(named: "backArrow"), for: .normal)
    leftButton.tintColor = UIColor(hexString: TintColor ?? navBarFontColor)
    leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    leftButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    leftButton.backgroundColor = .clear
    leftButton.addTarget(self, action: #selector(popToCustomerVC), for: .touchUpInside)
    let backBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
    self.navigationItem.leftBarButtonItem = backBarButtonItem
  }
  
  func setNavigationBarWith(title: String,textColor:UIColor? = nil) {
    self.navigationItem.title = title
    let titleColor = textColor ?? UIColor.red
    if #available(iOS 13.0, *) {
      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.backgroundColor = self.navigationController?.navigationBar.standardAppearance.backgroundColor
      appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
      self.navigationController?.navigationBar.standardAppearance = appearance;
      self.navigationController?.navigationBar.scrollEdgeAppearance =  self.navigationController?.navigationBar.standardAppearance
      
    } else {
      self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor ?? UIColor(hexString: navBarFontColor)]
    }
  }
  
  @objc func popViewController() {
      // FIXME: ATTENTION: This is an hotfix. Since some screens are actually calling
      // setNavigationLeftButton directly, and it stupidly calls this method,
      // we need to double check it here.
      // Either find the ancient curse that is laid upon here, or remove the
      // setFirstPop method correctly.
    if(self.navigationController?.viewControllers.count == 1) {
      self.navigationController?.dismiss(animated: true)
    } else {
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  func setNavigationLeftButton(TintColor:String? = nil) {
    let leftButton: UIButton = UIButton(type: .custom)
    
    leftButton.setImage(UIImage(named: "backArrow"), for: .normal)
    leftButton.tintColor = UIColor(hexString: TintColor ?? navBarFontColor)
    leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    leftButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    leftButton.backgroundColor = .clear
    leftButton.titleLabel?.text = ""
    leftButton.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    let backBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
    self.navigationItem.leftBarButtonItem = backBarButtonItem
  }
}


extension  BaseViewController: UINavigationControllerDelegate {
  public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
    return navigationController.topViewController!.supportedInterfaceOrientations
  }
  
}
