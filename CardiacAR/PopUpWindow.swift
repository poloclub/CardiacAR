//
//  PopUpWindow.swift
//  CardiacAR
//
//  Created by Pratham Mehta on 08/04/22.
//
import Foundation
import UIKit

extension UIViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotifications(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // This method will notify when keyboard appears/ dissapears
    @objc func keyboardNotifications(notification: NSNotification) {

        var txtFieldY : CGFloat = 0.0  //Using this we will calculate the selected textFields Y Position
        let spaceBetweenTxtFieldAndKeyboard : CGFloat = 100.0 //Specify the space between textfield and keyboard


        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
            // Here we will get accurate frame of textField which is selected if there are multiple textfields
            frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
            txtFieldY = frame.origin.y + frame.size.height
        }

        if let userInfo = notification.userInfo {
            // here we will get frame of keyBoard (i.e. x, y, width, height)
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y
            let keyBoardFrameHeight = keyBoardFrame!.size.height + 20

            var viewOriginY: CGFloat = 0.0
            //Check keyboards Y position and according to that move view up and down
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                viewOriginY = 0.0
            } else {
                // if textfields y is greater than keyboards y then only move View to up
                if txtFieldY >= keyBoardFrameY {

                    viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard

                    //This condition is just to check viewOriginY should not be greator than keyboard height
                    // if its more than keyboard height then there will be black space on the top of keyboard.
                    if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
                }
            }

            //set the Y position of view
            self.view.frame.origin.y = -viewOriginY
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UIResponder {

    static weak var responder: UIResponder?

    static func currentFirst() -> UIResponder? {
        responder = nil
        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
        return responder
    }

    @objc private func trap() {
        UIResponder.responder = self
    }
}

class PopUpWindow: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }

    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private let popUpWindowView = PopUpWindowView()
    
    init(title: String, text: String, buttontext: String) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = title
        popUpWindowView.popupText.text = text
        popUpWindowView.popupButton.setTitle(" ", for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
        view.layer.cornerRadius = 10

    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.popupTitle.text = "This is a pop up title"
        popUpWindowView.popupText.text = "Blah blah blah heart cool"
        popUpWindowView.popupButton.setTitle(" ", for: .normal)
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
        view.layer.cornerRadius = 10
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

}

private class PopUpWindowView: UIView {
    
    
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    let info1 = UITextField(frame: CGRect.zero)
//    let info2 = UITextView(frame: CGRect.zero)
//    let info3 = UITextView(frame: CGRect.zero)

    let BorderWidth: CGFloat = 0.1
    
    @objc func getInfo(_sender: UIButton) {
        let text = info1.text!
        print(text)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        popupView.backgroundColor = UIColor.gray
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.cornerRadius = 10

        
        // Popup Title
        popupTitle.textColor = UIColor.white
        popupTitle.backgroundColor = UIColor.gray
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        // Popup Text
        popupText.textColor = UIColor.white
        popupText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        popupText.numberOfLines = 0
        popupText.textAlignment = .center
        
        
        // Popup Button
        popupButton.setTitleColor(UIColor.white, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.backgroundColor = UIColor.gray
        popupButton.addTarget(self, action: #selector(getInfo(_sender:)), for: [.touchDown])
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        popupButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        
        // textfields
        info1.placeholder = "Enter a description"
        info1.borderStyle = UITextField.BorderStyle.roundedRect
        info1.backgroundColor = UIColor.lightGray
        info1.font = UIFont.systemFont(ofSize: 14.0)
        info1.keyboardType = UIKeyboardType.default
       
        
        popupView.addSubview(popupTitle)
        popupView.addSubview(popupText)
        popupView.addSubview(info1)
        popupView.addSubview(popupButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
    
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
//        popupView.bounds.size.width = screenSize.width * 0.8

        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.widthAnchor.constraint(equalToConstant: 50),
            popupButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            popupButton.heightAnchor.constraint(equalToConstant: 50),
            popupButton.centerXAnchor.constraint(equalTo: self.trailingAnchor, constant: -screenSize.width * 0.12)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 8),
            popupTitle.heightAnchor.constraint(equalToConstant: 60),
//            popupText.bottomAnchor.constraint(equalTo: popupText.topAnchor, constant: -8)
            ])
        
        
        // PopupText constraints
        popupText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
            popupText.widthAnchor.constraint(equalToConstant: screenSize.width * 0.9),
            popupText.bottomAnchor.constraint(equalTo: info1.topAnchor, constant: -8)
            ])
        
        // info constraints:
        info1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            info1.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            info1.topAnchor.constraint(equalTo: popupText.bottomAnchor, constant: 8),
            info1.widthAnchor.constraint(equalToConstant: screenSize.width * 0.82),
            info1.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            info1.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -16)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
