//
//  StepViewController.swift
//  HowToSwitchAmaniV3
//
//  Created by Bedri Doğan on 21.02.2025.
//

import UIKit
import Foundation


class StepViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  private let tableView = UITableView()
  private let captureOptions = ["ID Capture", "Selfie Capture"]
  private var descriptionLabel  = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    view.backgroundColor = .white
    navigationItem.title = "Choose Verification"
    
  }
  
  private func setupTableView() {
    descriptionLabel.text = "Please start your verify session."
    descriptionLabel.textColor = .black
    descriptionLabel.font = .systemFont(ofSize: 17, weight: .medium)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(descriptionLabel)
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
 
    NSLayoutConstraint.activate([
      
      descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      descriptionLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -40),
      
      tableView.topAnchor.constraint(equalTo:  descriptionLabel.bottomAnchor, constant: 40),
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      tableView.bottomAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
    ])
  }
  
  private func startIDCaptureSession() {
  
    
    DispatchQueue.main.async {
      let vc = IDCaptureViewController()
      
        // Eğer bu VC bir Navigation Controller içindeyse push yap
      if let navigationController = self.navigationController {
        navigationController.pushViewController(vc, animated: true)
      } else {
          // Eğer navigation controller yoksa, yeni bir NavigationController ile göster
        let navController = UINavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
      }
    }
    
  }
  
  private func startSelfieCaptureSession() {

    DispatchQueue.main.async {
      let vc = SelfieCaptureViewController()
      
        // Eğer bu VC bir Navigation Controller içindeyse push yap
      if let navigationController = self.navigationController {
        navigationController.pushViewController(vc, animated: true)
      } else {
          // Eğer navigation controller yoksa, yeni bir NavigationController ile göster
        let navController = UINavigationController(rootViewController: vc)
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
      }
    }
    
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return captureOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = captureOptions[indexPath.row]
    cell.textLabel?.textAlignment = .center // Metni ortala
    cell.backgroundColor = .white
    cell.textLabel?.textColor = .black
    return cell
  }
  
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("\(captureOptions[indexPath.row]) seçildi")
    if indexPath.row == 0 {
      self.startIDCaptureSession()
    } else {
      self.startSelfieCaptureSession()
    }
    
  }
}
