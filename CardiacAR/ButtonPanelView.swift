import UIKit

fileprivate let buttonSize: CGFloat = 56
fileprivate let shadowOpacity: Float = 0.6
fileprivate let imagePointSize: CGFloat = 22
class ButtonPanelView: UIView {
	
	
	let setting=UIImage(systemName:"switch.2", withConfiguration: UIImage.SymbolConfiguration(pointSize: imagePointSize,weight: .semibold, scale: .large))
	let panningMode=UIImage(systemName:"rotate.3d", withConfiguration: UIImage.SymbolConfiguration(pointSize: imagePointSize,weight: .semibold, scale: .large))
	let slicingMode=UIImage(systemName:"square.3.layers.3d.down.left",                                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: imagePointSize,weight: .semibold, scale: .large))
	let xmark=UIImage(systemName:"xmark.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: imagePointSize,weight: .semibold, scale: .large))
	var currentMode = ""
	
	
	lazy var menuButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(setting, for: .normal)
		button.tintColor = .white
		button.layer.cornerRadius = buttonSize / 2
		button.addTarget(
			self, action: #selector(handleSettingButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	
	lazy var slicingButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(slicingMode, for: .normal)
		button.tintColor = .white
		button.layer.cornerRadius = buttonSize / 2
		button.isHidden = true
		button.addTarget(
			self, action: #selector(handleSettingButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	
	lazy var panningButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(panningMode, for: .normal)
		button.tintColor = .white
		button.layer.cornerRadius = buttonSize / 2
		button.isHidden = true
		button.addTarget(
			self, action: #selector(handleSettingButtonTapped(_:)), for: .touchUpInside)
		return button
	}()
	
	lazy var expandedStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.isHidden = true
		stackView.addArrangedSubview(slicingButton)
		stackView.addArrangedSubview(panningButton)
		return stackView
	}()
	
	lazy var containerStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.addArrangedSubview(expandedStackView)
		stackView.addArrangedSubview(menuButton)
		return stackView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor(red: 81/255, green: 166/255, blue: 219/255, alpha: 1)
		
		layer.cornerRadius = buttonSize / 2
		layer.shadowColor = UIColor.lightGray.cgColor
		layer.shadowOpacity = shadowOpacity
		
		layer.shadowOffset = .zero
		
		addSubview(containerStackView)
		setConstraints()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setConstraints() {
	
		menuButton.translatesAutoresizingMaskIntoConstraints = false
		menuButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
		menuButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
		

		slicingButton.translatesAutoresizingMaskIntoConstraints = false
		slicingButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
		slicingButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
		
		
		panningButton.translatesAutoresizingMaskIntoConstraints = false
		panningButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
		panningButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
		
		// Container stack view
		containerStackView.translatesAutoresizingMaskIntoConstraints = false
		containerStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		containerStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		
		translatesAutoresizingMaskIntoConstraints = false
		self.widthAnchor.constraint(equalTo: containerStackView.widthAnchor).isActive = true
		self.heightAnchor.constraint(equalTo: containerStackView.heightAnchor).isActive = true
	}
}

// MARK: - Gestures
extension ButtonPanelView {
	@objc private func handleSettingButtonTapped(_ sender: UIButton) {
		let willExpand = expandedStackView.isHidden
		let menuButtonNewImage:UIImage?
		if (willExpand){
			menuButtonNewImage = xmark
		}else{
			if (currentMode == "slicing") {
				menuButtonNewImage = slicingMode
			}else if (currentMode == "panning"){
				menuButtonNewImage = panningMode
			}else{
				menuButtonNewImage = setting
			}
		}
		 
		
		UIView.animate(
			withDuration: 0.3, delay: 0, options: .curveEaseIn,
			animations: {
				self.expandedStackView.subviews.forEach { $0.isHidden = !$0.isHidden }
				self.expandedStackView.isHidden = !self.expandedStackView.isHidden
				if willExpand {
					self.menuButton.setImage(menuButtonNewImage, for: .normal)
				
				}
			}, completion: { _ in
				// When collapsing, wait for animation to finish before changing from "x" to "+"
				if !willExpand {
					self.menuButton.setImage(menuButtonNewImage, for: .normal)
				
				}
			})
	}
}
