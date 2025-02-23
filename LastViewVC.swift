//
//  LastViewVC.swift
//  HowToSwitchAmaniV3
//
//  Created by Bedri Doğan on 21.02.2025.
//


import UIKit
import AmaniSDK
class LastViewVC: BaseViewController {
 
  
  let confirmButton = UIButton()
  let tryAgainButton = UIButton()
  let previewImage = UIImageView()
  let buttonStackView = UIStackView()
  
  let amani = Amani.sharedInstance
  var lastImage:UIImage?
  var mrzdocumentID: String?
  var nviData:NviModel?
  private let activityIndicator = UIActivityIndicatorView(style: .large)
  private let loadingView = UIView()
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    DispatchQueue.main.async {
      self.setupLoadingView()
      self.confirmButton.isEnabled = false
    }
   
    view.backgroundColor = .white
    amani.setMRZDelegate(delegate: self)
    confirmButton.addTarget(self, action: #selector(tapConfirm(_:)), for: .touchUpInside)
    tryAgainButton.addTarget(self, action: #selector(tapTryAgain(_:)), for: .touchUpInside)
    setUI()
      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    do {
      startLoading()
       amani.IdCapture().getMrz(cb: { mrzDocId in
        debugPrint("lasviewVC mrz Doc değeri: \(mrzDocId)")
         self.mrzdocumentID = mrzDocId
         DispatchQueue.main.async {
           self.confirmButton.isEnabled = true
         }
       
      })
    }catch (let err) {
      
    }
  }
  

  
  @objc func tapConfirm(_ sender: UIButton) {
    debugPrint("tapConfirm button.............")
    DispatchQueue.main.async {
      if let nviData = self.nviData {
        let vc = NFCViewController()
        vc.nviData = nviData
        self.navigationController?.pushViewController(vc, animated: true)
        
      }
    }
  }
  
  @objc func tapTryAgain(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  private func setupLoadingView() {
    loadingView.frame = view.bounds
    loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    view.addSubview(loadingView)
    
    activityIndicator.center = loadingView.center
    activityIndicator.color = .white
    loadingView.addSubview(activityIndicator)
  }
  
  private func startLoading() {
    DispatchQueue.main.async {
      self.activityIndicator.startAnimating()
    }
   
  }
  
  private func stopLoading() {
    DispatchQueue.main.async {
      self.activityIndicator.stopAnimating()
      self.loadingView.removeFromSuperview()
    }
    
  }
  
  private func setUI() {
    debugPrint("preImage previewVC içerisine geldi: \(lastImage)")
    previewImage.image = lastImage
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
    
    
    NSLayoutConstraint.activate([
      previewImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      previewImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      previewImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      previewImage.heightAnchor.constraint(equalToConstant: 200),
      
      
      buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      buttonStackView.heightAnchor.constraint(equalToConstant: 50)
      
      
    ])
  }
  
  
}

extension LastViewVC: mrzInfoDelegate {
  func mrzInfo(_ mrz: AmaniSDK.MrzModel?, documentId: String?) {
    debugPrint("document ID ve mrz: \(documentId), \(mrz)")
    
    guard let mrz = mrz else  {return}
    
    switch apiVersion {
    case .v1:
      let nviData = NviModel(mrzModel: mrz)
      self.nviData = nviData
    case .v2:
     
      if documentId == mrzdocumentID  {
        let nviData = NviModel(mrzModel: mrz)
        self.nviData = nviData
      }
      stopLoading()
    default:
      break
    }
    
  }
  
}
