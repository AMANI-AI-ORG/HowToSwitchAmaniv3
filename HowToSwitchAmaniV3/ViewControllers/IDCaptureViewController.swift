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
    //MARK: We gonna set some necessary informations before IDcapture start session.
    let idCapture: IDCapture = amani.IdCapture()
    do {
      idCapture.setType(type: "TUR_ID_1") //MARK: You can find out whats your id doc type
      idCapture.setManualCropTimeout(Timeout: 30)
      idCapture.setVideoRecording(enabled: false)
      idCapture.setIdHologramDetection(enabled: false)
      
      //MARK: We should set id card stepID(As Integer). if the capture will success that method will return captured image
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
