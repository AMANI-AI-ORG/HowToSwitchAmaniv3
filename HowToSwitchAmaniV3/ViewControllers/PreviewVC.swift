//
//  PreviewVC.swift
//  Demo
//
//  Created by Münir Ketizmen on 8.07.2021.
//

import UIKit
import AmaniSDK
class PreviewVC: BaseViewController {
  private var confirmCallback: ConfirmCallback?
  let confirmButton = UIButton()
  let tryAgainButton = UIButton()
  let previewImage = UIImageView()
  let buttonStackView = UIStackView()
  var DocID: String?
  var step: Int = 0
  
    let amani = Amani.sharedInstance
    var preImage:UIImage?
  
  @objc func tapConfirm(_ sender: UIButton) {
    
    do {
      if DocID == "ID" {
        self.step += 1
        let idCapture = self.amani.IdCapture()
          //MARK: We should set id card stepID for back side. that value must be 1.
        guard let IdCapture2:UIView = try idCapture.start( stepId: steps.back.rawValue , completion: { (previewImage) in
          DispatchQueue.main.async {
            if self.step == 1 {
              self.startLastConfirmation(image: previewImage)
            } else {
              
            }
            guard let previewVC:UIViewController  = self.storyboard?.instantiateViewController(withIdentifier: "preview") else {return}
            ( previewVC as! PreviewVC) .preImage = previewImage
            self.navigationController?.pushViewController(previewVC, animated: true)
          }
        }) else {return}
        
        self.view.addSubview(IdCapture2)
      } else {
        //MARK: In this step if document is Selfie, there is just one image so I can upload which captured selfie image here as like the bottom. the method will return request response as boolean value.
          let selfieCapture = self.amani.selfie()
          
        selfieCapture.upload { isUploadSelfie in
          
          debugPrint("selfie uploaded success : \(isUploadSelfie)")
          if let isUploaded = isUploadSelfie {
            self.showAlert(isUploaded: isUploaded)
          }
          
        }
        
      }
   
      
    } catch {
      
    }
  }
  
  @objc func tapTryAgain(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
   
      view.backgroundColor = .white
      self.navigationItem.title = "Front Side"
      confirmButton.addTarget(self, action: #selector(tapConfirm(_:)), for: .touchUpInside)
      tryAgainButton.addTarget(self, action: #selector(tapTryAgain(_:)), for: .touchUpInside)
      setUI()
        // Do any additional setup after loading the view.
    }
  
  private func startLastConfirmation(image: UIImage) {
    
    let vc = LastViewVC()
    vc.lastImage = image

    
    if let navigationController = self.navigationController {
      navigationController.pushViewController(vc, animated: true)
    } else {
      print("Navigation Controller mevcut değil")
    }
    
    
  }
  
  private func showAlert(isUploaded: Bool) {
    DispatchQueue.main.async {
      var actions: [(String, UIAlertAction.Style)] = []
      
      actions.append(("\("Ok")", UIAlertAction.Style.default))
      
      AlertDialogueUtility.shared.showAlertWithActions(vc: self, title: "Upload Selfie request response", message: "\(isUploaded)", actions: actions) { index in
        if index == 0 {
          DispatchQueue.main.async {
            let vc = StepViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        
          }
        }
      }
    }
  }
    
  private func setUI() {
   
    previewImage.image = preImage
    buttonStackView.axis = .horizontal
    buttonStackView.spacing = 16
    buttonStackView.distribution = .fillEqually
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    
    confirmButton.setTitle("Confirm", for: .normal)
    confirmButton.backgroundColor = .green
    confirmButton.translatesAutoresizingMaskIntoConstraints = false
    tryAgainButton.setTitle("Try again", for: .normal)
    tryAgainButton.backgroundColor = .red
    tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
    
    previewImage.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(previewImage)
    view.addSubview(buttonStackView)
    buttonStackView.addArrangedSubview(tryAgainButton)
    buttonStackView.addArrangedSubview(confirmButton)
    if self.DocID == "ID" {
      previewImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    } else {
      previewImage.heightAnchor.constraint(equalToConstant: view.frame.height / 2).isActive = true
    }
   
    
    NSLayoutConstraint.activate([
      previewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      previewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      previewImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      buttonStackView.heightAnchor.constraint(equalToConstant: 50)
      
      
    ])
  }


}
