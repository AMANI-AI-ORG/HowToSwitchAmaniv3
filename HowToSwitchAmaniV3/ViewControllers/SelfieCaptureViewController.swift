//
//  SelfieCaptureViewController.swift
//  FaturamatikVerify
//
//  Created by Bedri Doğan on 23.01.2025.
//

import UIKit
import AmaniSDK

class SelfieCaptureViewController: BaseViewController {
  var stepView: UIView?
  let amani: Amani = Amani.sharedInstance
  let DocID: String = "SE"
  
  override func viewDidLoad() {
    super.viewDidLoad()
      
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
    self.navigationItem.title = "Selfie Verification"

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    print("Subviews after layoutSubviews: \(self.view.subviews)")
  }
  
  private func setupUI() {
    let selfie: Selfie = amani.selfie()
    do {
      
      guard let selfieVC:UIView = try selfie.start( completion: { [weak self](previewImage) in
        DispatchQueue.main.async {
          debugPrint(previewImage)
          self?.startConfirm(image: previewImage)
          self?.stepView?.removeFromSuperview()
        }
      }) else {return}
      self.stepView = selfieVC
      DispatchQueue.main.async {
        self.view.addSubview(selfieVC)
      }
      
    }
    catch  {
      print("Unexpected error: \(error).")
      
    }
    
  }
  

  
  private func startConfirm(image: UIImage) {
  let vc = PreviewVC()
  vc.preImage = image
  vc.DocID = self.DocID
    
  if let navigationController = self.navigationController {
    navigationController.pushViewController(vc, animated: true)
  } else {
    print("Navigation Controller mevcut değil")
  }
    
    
}
  
  
}
