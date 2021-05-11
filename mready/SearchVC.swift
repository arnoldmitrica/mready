//
//  ViewController.swift
//  mready
//
//  Created by Arnold Mitricã on 10.05.2021.
//

import UIKit

class SearchVC: UIViewController {

    let logoImageView = UIImageView()
    let queryTextField = GFTextField()
    let callToAction = GFButton(backgroundColor: .systemTeal, title: "Get Repos")
    var logoImageViewTopConstraint: NSLayoutConstraint!
    
    var isQueryEntered: Bool { return queryTextField.text!.isEmpty == false }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, queryTextField, callToAction)

        configureLogoImageView()
        configureTextField()
        configureCallToActionBtn()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true) // shows animation instead of just hiding it
    }
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.logo // stringly typed
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: (view?.safeAreaLayoutGuide.topAnchor)!, constant: topConstraintConstant)
        logoImageViewTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        queryTextField.delegate = self
        
        NSLayoutConstraint.activate([
            queryTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            queryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            queryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            queryTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionBtn() {
        callToAction.addTarget(self, action: #selector(pushRepoListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToAction.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToAction.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToAction.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToAction.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushRepoListVC() {
        guard isQueryEntered else {
            presentGFAlertOnMainThread(title: "Empty Repository", message: "Please enter a repo. It needs to know what to look for.", buttonTitle: "Ok")
            return
        }
        
        queryTextField.resignFirstResponder()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let repositoriesListVC = storyboard.instantiateViewController(identifier: "repositories") as RepoListVC
        repositoriesListVC.query = queryTextField.text
        repositoriesListVC.title = queryTextField.text

        let nvc = UINavigationController(rootViewController: repositoriesListVC)
        nvc.modalPresentationStyle = .fullScreen
        
        present(nvc, animated: true)
    }
    
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushRepoListVC()
        return true
    }
}

