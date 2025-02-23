//
//  IDCaptureViewController.swift
//  FaturamatikVerify
//
//  Created by Bedri Doğan on 21.01.2025.
//

import UIKit
import Foundation
import AmaniSDK

class IDCaptureViewController: BaseViewController {
  let amani: Amani = Amani.sharedInstance
  var stepView: UIView?
  let DocID: String = "ID"
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
    self.navigationItem.title = "ID Verification"

  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

  }
  
  private func setupUI() {
    let idCapture: IDCapture = amani.IdCapture()
    do {
      idCapture.setType(type: "TUR_ID_1")
      idCapture.setManualCropTimeout(Timeout: 30)
      idCapture.setVideoRecording(enabled: false)
      idCapture.setIdHologramDetection(enabled: false)
      idCapture.setClientSideMRZ(enabled: false)
      guard let idCaptureView: UIView = try idCapture.start(stepId: steps.front.rawValue, completion: { [weak self](previewImage) in
        DispatchQueue.main.async {
        debugPrint(previewImage)
          self?.startConfirm(image: previewImage)
        }
      }) else {return}
        self.stepView = idCaptureView
        DispatchQueue.main.async {
          self.view.addSubview(idCaptureView)
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
