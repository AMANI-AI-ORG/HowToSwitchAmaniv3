//
//  ViewController.swift
//  HowToSwitchAmaniV3
//
//  Created by Bedri Doğan on 17.10.2024.
//

import UIKit
import AmaniSDK

typealias ConfirmCallback = () -> Void

class AmaniInitializaion: UIViewController  {
  
  private var descriptionLabel = UILabel()
  private var serverURLText = UILabel()
  private var serverURLInput = RoundedTextInput()
  private var tokenLabel = UILabel()
  private var tokenLabelInput = RoundedTextInput()
  private var apiVersionLabel = UILabel()
  private var apiVersionInput = RoundedTextInput()
  private var submitButton = UIButton()
  private var formView = UIStackView()
  private var mainStackView = UIStackView()
  //MARK: We're setting AmaniSDK instance as propery here
  let amani:Amani = Amani.sharedInstance
  
  @objc func tapSubmit(_ sender: UIButton) {
    guard let serverText = serverURLInput.field.text, !serverText.isEmpty,
          let tokenText = tokenLabelInput.field.text, !tokenText.isEmpty,
          let apiVersionText = apiVersionInput.field.text, !apiVersionText.isEmpty else {
      showAlert(message: "Please fill the blank areas. (serverURL, token, apiVersion)")
      return
    }
    
    initAmani(serverURL: serverText, token: tokenText)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    submitButton.addTarget(self, action: #selector(tapSubmit(_:)), for: .touchUpInside)
    view.backgroundColor = .white
    setNFCFormUI()
    
  }
  
  private func showAlert(message: String) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  private func setNFCFormUI() {
  
    self.descriptionLabel.text = "Please enter the serverURL, token and apiVersion"
    self.descriptionLabel.textColor = .black
    self.descriptionLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    self.descriptionLabel.numberOfLines = 1
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    self.descriptionLabel.textAlignment = .center
    
    
    self.serverURLText.text =  "Server URL"
    self.serverURLText.textColor = UIColor(hexString: "#2020F")
    self.serverURLText.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    self.serverURLText.numberOfLines = 1
    self.serverURLText.setContentCompressionResistancePriority(.required, for: .vertical)
    
    self.serverURLInput = RoundedTextInput(
      placeholderText: "",
      borderColor: UIColor(hexString: "#515166"),
      placeholderColor: UIColor(hexString: "#C0C0C0"),
      isPasswordToggleEnabled: false,
      keyboardType: .default
    )
    
    self.tokenLabel.text = "User Access Token"
    self.tokenLabel.textColor = UIColor(hexString: "#2020F")
    self.tokenLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    self.tokenLabel.numberOfLines = 1
    self.tokenLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    
    self.tokenLabelInput = RoundedTextInput(
      placeholderText: "",
      borderColor: UIColor(hexString: "#515166"),
      placeholderColor: UIColor(hexString: "#C0C0C0"),
      isPasswordToggleEnabled: false,
      keyboardType: .numberPad
    )
    
    self.apiVersionLabel.text =  "Api Version"
    self.apiVersionLabel.textColor = UIColor(hexString: "#2020F")
    self.apiVersionLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    self.apiVersionLabel.numberOfLines = 1
    self.apiVersionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    
    self.apiVersionInput = RoundedTextInput(
      placeholderText: "",
      borderColor: UIColor(hexString: "#515166"),
      placeholderColor: UIColor(hexString: "#C0C0C0"),
      isPasswordToggleEnabled: false,
      keyboardType: .numberPad
    )
    self.submitButton.translatesAutoresizingMaskIntoConstraints = false

          self.submitButton.setTitle("Continue", for: .normal)
    self.submitButton.setTitleColor(.white, for: .normal)
    self.submitButton.backgroundColor = .red
      
    self.submitButton.layer.borderColor = UIColor.black.cgColor
    self.submitButton.layer.cornerRadius = 24.0

    self.submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    self.submitButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
   
    
    self.formView = UIStackView(arrangedSubviews: [
      descriptionLabel, serverURLText, serverURLInput,
      tokenLabel, tokenLabelInput,
      apiVersionLabel, apiVersionInput,
    ])
    
    self.formView.axis = .vertical
    self.formView.distribution = .fillProportionally
    self.formView.spacing = 6.0
    
    self.formView.setCustomSpacing(100, after: descriptionLabel)
    
    
    self.mainStackView = UIStackView(arrangedSubviews: [
      
      formView,
    ])
    
    self.mainStackView.axis = .vertical
    self.mainStackView.distribution = .fill
      //    self.mainStackView.isLayoutMarginsRelativeArrangement = true
    self.mainStackView.spacing = 0.0
    
    
    
    self.mainStackView.translatesAutoresizingMaskIntoConstraints = false

    setNFCFormUIConstraints()
  }
  private func setNFCFormUIConstraints() {
    view.addSubview(descriptionLabel)
    view.addSubview(mainStackView)
    view.addSubview(submitButton)
   
    NSLayoutConstraint.activate([
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
      descriptionLabel.heightAnchor.constraint(equalToConstant: 20),
      mainStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 100),
      mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    
      submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      submitButton.heightAnchor.constraint(equalToConstant: 50.0),

    ])
    
    serverURLInput.setDelegate(delegate: self)
    tokenLabelInput.setDelegate(delegate: self)
    apiVersionInput.setDelegate(delegate: self)
  }
  
 
  
  //MARK: We should set AmaniSDK's Delegate before initAmani method.
  //MARK: We're gonna monitoring "customer profile status changes or when the customer completes a step, either successfuly or a failure" this kind of results from delegates.
  private func initAmani(serverURL: String, token: String) {

    amani.setDelegate(delegate: self)
    let customer = CustomerRequestModel.init(idCardNumber: "22180378472") //MARK: you should here customer's id card number
    do {
      
    //MARK: You must add the version of the backend service you are using as a parameter here. In addition, AmaniSDK v3 is compatible v1 back service.
      
   try? amani.initAmani(server: serverURL, token: token, apiVersion: apiVersion) { cmModel, error in
        debugPrint(cmModel)
        debugPrint(error)
     
     self.presentStepViews()
      }
      
    } catch let error {
      print(error)
    }
  }
  
  
  private func presentStepViews() {
    DispatchQueue.main.async {
      let vc = StepViewController()
      
        
      if let navigationController = self.navigationController {
        navigationController.pushViewController(vc, animated: true)
      } else {
         
        let navController = UINavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
      }
    }
  }
}




extension AmaniInitializaion: UITextFieldDelegate {
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if textField == serverURLInput.field {
      serverURLInput.field.text = textField.text
      if let text = serverURLInput.field.text {
        
      }
      
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == serverURLInput {
      tokenLabelInput.becomeFirstResponder()
    } else if textField == tokenLabelInput {
      apiVersionInput.becomeFirstResponder()
    } else if textField == apiVersionInput {
      return true
    }
    return true
  }
}

//MARK: The customer's session results gonna print here.
extension AmaniInitializaion: AmaniDelegate {
  func onProfileStatus(customerId: String, profile: AmaniSDK.wsProfileStatusModel) {
    print(customerId, profile)
  }
  
  func onStepModel(customerId: String, rules: [AmaniSDK.KYCRuleModel]?) {
    print(customerId, rules)
  }
  
  func onError(type: String, error: [AmaniSDK.AmaniError]) {
    print(type, error)
  }
  
  
}

//
