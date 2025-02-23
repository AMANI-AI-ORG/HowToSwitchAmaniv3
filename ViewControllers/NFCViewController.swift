//
//  NFCViewController.swift
//  HowToSwitchAmaniV3
//
//  Created by Bedri Doğan on 23.02.2025.
//

import UIKit
import Foundation
import AmaniSDK
import CoreNFC


class NFCViewController: BaseViewController {
  let amani:Amani = Amani.sharedInstance
  let descriptionLabel = UILabel()
  let scanNFCButton = UIButton()
  var nviData:NviModel?
  
  
  @objc func tapScanNFCButton(_ sender: UIButton) {
    Task {
      if let nviData = self.nviData {
        amani.IdCapture().setNfcIcons(newReadIcon: "👀",newBlankIcon: "🚀")
        let param = await amani.IdCapture().startNFC(nvi: nviData)
        
        if !param == false {
          amani.IdCapture().upload { isUploaded in
            debugPrint("id capture uploaded succes: \(isUploaded)")
            if let isUploaded = isUploaded {
              self.showAlert(isUploaded: isUploaded)
            }
            
          }
        }
    
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.scanNFCButton.addTarget(self, action: #selector(tapScanNFCButton(_:)), for: .touchUpInside)
    self.navigationItem.title = "NFC Scan"
    setUI()
  }
  private func deneme() {
    
  }
  private func showAlert(isUploaded: Bool) {
    DispatchQueue.main.async {
      var actions: [(String, UIAlertAction.Style)] = []
      
      actions.append(("\("Ok")", UIAlertAction.Style.default))
      
      AlertDialogueUtility.shared.showAlertWithActions(vc: self, title: "ID request response", message: "\(isUploaded)", actions: actions) { index in
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
    descriptionLabel.text = "Please scan your ID card with NFC"
    descriptionLabel.textColor = .black
    descriptionLabel.textAlignment = .center
    descriptionLabel.font = .systemFont(ofSize: 17, weight: .medium)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    scanNFCButton.setTitle("Scan NFC", for: .normal)
    scanNFCButton.setTitleColor(.white, for: .normal)
    scanNFCButton.backgroundColor = .red
    scanNFCButton.translatesAutoresizingMaskIntoConstraints = false
    scanNFCButton.layer.borderColor = UIColor.black.cgColor
    scanNFCButton.layer.cornerRadius = 24.0
    
    scanNFCButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    scanNFCButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    view.addSubview(descriptionLabel)
    view.addSubview(scanNFCButton)
    
    NSLayoutConstraint.activate([
      
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      
     
      scanNFCButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      scanNFCButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      scanNFCButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      scanNFCButton.heightAnchor.constraint(equalToConstant: 50.0),
      
      
    ])
  }
  
  
  
}
