//
//  SceneView.swift
//  CardiacAR
//
//  Created by Alex Yang on 11/5/21.
//

import Foundation
import ARKit
import SwiftUI
import UIKit
import SceneKit
import ModelIO
import SceneKit.ModelIO
import Euclid
import MobileCoreServices
import UniformTypeIdentifiers

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        SIMD3(x, y, z)
    }
}

class SceneViewController: UIViewController, ARSCNViewDelegate, UIDocumentPickerDelegate {

    public static var modelPath : URL? = nil
    public  var show: Bool? = false
    
    let supportedTypes = [UTType.text]
    

    func openDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.shouldShowFileExtensions = true
        present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        SceneViewController.modelPath = urls[0]
        let pseudo:UIButton = {
            let button = UIButton(type:.system)
            return button
            
        }()
        addDown(_sender: pseudo)
        addUp(_sender: pseudo)
        addUp(_sender: addButton)
//        reAdd()
    }
    
	// MARK: - Initialization
	// UI elements
	
	let toolbar = ButtonPanelView()
	let addButton:UIButton={
		let button = UIButton(type:.system)
		button.setTitle(" Add", for: .normal)
//		button.layer.cornerRadius=5
		button.setTitleColor(UIColor(red: 81/255, green: 166/255, blue: 219/255, alpha: 1), for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
		button.translatesAutoresizingMaskIntoConstraints=false
		let btnImage = UIImage(systemName: "plus.viewfinder",                                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 16 ,weight: .semibold))
		button.setImage(btnImage , for: .normal)
//		button.titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
//		button.backgroundColor=UIColor.white
		return button
	}()
    
//    let toggleSlicingButton:UIButton={
//        let button = UIButton(type:.system)
//        button.setTitle("Slicing", for: .normal)
//        button.setTitleColor(UIColor.systemBlue, for: .normal)
//        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
//        button.translatesAutoresizingMaskIntoConstraints=false
//        return button
//    }()
//
    let confirmSliceButton:UIButton={
        let button = UIButton(type:.system)
        button.setTitle("Confirm Slice", for: .normal)
        button.setTitleColor(UIColor(red: 81/255, green: 166/255, blue: 219/255, alpha: 1), for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
    
    let revertSliceButton:UIButton={
        let button = UIButton(type:.system)
        button.setTitle("Revert Heart", for: .normal)
        button.setTitleColor(UIColor(red: 81/255, green: 166/255, blue: 219/255, alpha: 1), for: .normal)
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.translatesAutoresizingMaskIntoConstraints=false
        return button
    }()
	
	func configureConstraints(){
        addButton.centerXAnchor.constraint(equalTo: view.leftAnchor,constant: 50).isActive=true
        addButton.centerYAnchor.constraint(equalTo: view.bottomAnchor,constant: -50).isActive=true
        addButton.widthAnchor.constraint(equalToConstant: 80).isActive=true

 
//        toggleSlicingButton.centerXAnchor.constraint(equalTo: view.rightAnchor,constant: -50).isActive=true
//        toggleSlicingButton.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 80).isActive=true
//        toggleSlicingButton.widthAnchor.constraint(equalToConstant: 80).isActive=true
  

        confirmSliceButton.centerXAnchor.constraint(equalTo: view.rightAnchor,constant: -75).isActive=true
        confirmSliceButton.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 90).isActive=true
        confirmSliceButton.widthAnchor.constraint(equalToConstant: 150).isActive=true
    
    
        revertSliceButton.centerXAnchor.constraint(equalTo: view.rightAnchor,constant: -75).isActive=true
        revertSliceButton.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 125).isActive=true
        revertSliceButton.widthAnchor.constraint(equalToConstant: 150).isActive=true
		
		toolbar.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive=true
		toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20).isActive=true
    }
	
	// ARKit Config
	let arkitConfig = ARWorldTrackingConfiguration();
    
    // heart node
    var originalHeartNode: SCNNode? = nil
    var heartNode:SCNNode? = nil
    
    // gestures
    var currentAngleY: Float = 0.0
    var currentAngleX: Float = 0.0
    var camera_rotation_pan_start: simd_quatf = simd_quatf.init()
    var object_rotation_pan_start: simd_quatf = simd_quatf.init()
    
    // slicing plane node and equation
    var planeNode: SCNNode? = nil
    var planeEquation: simd_float4!
    
    // Initial normal and plane normal for the plane equation
    var planeNormal: simd_float3 = simd_float3.init()
    let initNormal: simd_float3 = simd_float3(x: 0, y: -0.00447212477, z: -0.99999)
    
    // Keep track of model viewing gestures and slicing gestures
    var modelViewPanGestureRecognizer: UIGestureRecognizer = UIGestureRecognizer()
    var modelViewPinchGestureRecognizer: UIGestureRecognizer = UIGestureRecognizer()
    var slicingPanGestureRecognizer: UIGestureRecognizer = UIGestureRecognizer()
    var slicingPinchGestureRecognizer: UIGestureRecognizer = UIGestureRecognizer()
    
    // Selection State
    enum ToolState {
        case modelView
        case slicing
    }
    
    var currentToolState = ToolState.modelView
	
	//sceneView
	var sceneView: ARSCNView {
		return self.view as! ARSCNView
	}
	
	
	// MARK: - Life cycle functions
	override func loadView() {
		self.view = ARSCNView(frame: .zero)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		sceneView.delegate = self
		sceneView.scene = SCNScene()
        
        // Add and setup buttons
		view.addSubview(addButton)
		
//        view.addSubview(toggleSlicingButton)
       
        view.addSubview(confirmSliceButton)
   
        view.addSubview(revertSliceButton)
        
		view.addSubview(toolbar)
		
		configureConstraints()
		
        
		self.hidesBottomBarWhenPushed = true
		
	
		
		
		//set defaultlighting to true
		sceneView.autoenablesDefaultLighting = true
		
		//create a light node
		sceneView.scene.rootNode.addChildNode(self.createLightNode()!)
        
        // set model view gestures
        self.modelViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(modelViewPanGesture(sender:)))
        self.modelViewPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(modelViewPinchGesture(sender:)))
        
        // set slicing gestures
        self.slicingPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slicingPanGesture(sender:)))
        self.slicingPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(slicingPinchGesture(sender:)))
        
        // add model view gestures initially
        sceneView.addGestureRecognizer(self.modelViewPanGestureRecognizer)
        sceneView.addGestureRecognizer(self.modelViewPinchGestureRecognizer)
		
		//add tapping gesture to place spheres
		let tapRotateRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
		sceneView.addGestureRecognizer(tapRotateRecognizer)
		
		// add actions for buttons
		addButton.addTarget(self, action: #selector(addDown(_sender:)), for: .touchDown)
		addButton.addTarget(self, action: #selector(addUp(_sender:)), for: [.touchUpInside, .touchUpOutside])
		
		toolbar.slicingButton.addTarget(self, action: #selector(enterSlicing), for: .touchDown)
		toolbar.panningButton.addTarget(self, action: #selector(enterPanning), for: .touchDown)
        
        revertSliceButton.addTarget(self, action: #selector(resetSliceDown(_sender:)), for: .touchDown)
        
        // hide confirm slicing button initally, activate while slicing
        confirmSliceButton.addTarget(self, action: #selector(confirmSliceDown(_sender:)), for: .touchDown)
        confirmSliceButton.isHidden = true
		revertSliceButton.isHidden = true
	}
	
	//Rerun session with clearing anchors and resetting tracking when view will appear (solving the freezing problem)
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		sceneView.session.run(arkitConfig, options: [.resetTracking, .removeExistingAnchors])
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let configuration = ARWorldTrackingConfiguration()
		sceneView.session.run(configuration)
		sceneView.delegate = self
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
	
	// MARK: - ARSCNViewDelegate
	func sessionWasInterrupted(_ session: ARSession) {}
	
	func sessionInterruptionEnded(_ session: ARSession) {}
	
	func session(_ session: ARSession, didFailWithError error: Error)
	{}
	
	func session(_ session: ARSession, cameraDidChangeTrackingState
				 camera: ARCamera) {}
	
	
	
	// MARK: - Auxilary functions
	
    func obj2SCNNode(name: String) -> SCNNode? {
        if let url = Bundle.main.url(forResource: name, withExtension: "obj", subdirectory: "art.scnassets") {
            guard let scene = try? SCNScene(url: url, options: nil) else { return nil }
                        
            //assumes node we want is first child node
            //TO-DO: See how to change this for segmented objs
            let temp_node = scene.rootNode.childNodes[0]
            
            orientAndScaleNode(node: temp_node)
                                    
            return temp_node
            
        }
        return nil
    }
    
    func obj2SCNNodeURL(name: URL) -> SCNNode? {
        
        guard let scene = try? SCNScene(url: name, options: nil) else { return nil }
                    
        //assumes node we want is first child node
        //TO-DO: See how to change this for segmented objs
        let temp_node = scene.rootNode.childNodes[0]
        
        orientAndScaleNode(node: temp_node)
                                
        return temp_node
        
    }
    
    func updatePlaneEquation() {
        // update plane normal in world space
        
        if self.planeNode == nil {
            placePlane()
        }
        
        let normal = (self.planeNode!.simdOrientation * simd_quatf(real: 0, imag: self.initNormal)) * self.planeNode!.simdOrientation.inverse
        
        // plane normal is in world space so translation is done easily
        self.planeNormal = normal.imag
        
        // Find plane equation in model space
        // From: https://stackoverflow.com/questions/7685495/transforming-a-3d-plane-using-a-4x4-matrix/7706849
        let new_point = (self.heartNode!.simdTransform.inverse * simd_float4(self.planeNode!.simdWorldPosition, 1)).xyz
        let new_normal = (self.heartNode!.simdTransform.transpose * simd_float4(normal.imag, 1)).xyz
                
        self.planeEquation = simd_float4(new_normal, -1 * simd_dot(new_normal, new_point))
        
        let planeEquationValue = NSValue(scnVector4: SCNVector4Make(self.planeEquation.x, self.planeEquation.y, self.planeEquation.z, self.planeEquation.w))
        self.heartNode!.geometry?.setValue(planeEquationValue, forKey: "plane_equation")
    }
    
    func setFragmentShader(node: SCNNode) {
        
        // check if node's material is double sided
//        if ((node.geometry?.firstMaterial?.isDoubleSided) == true) {
        node.geometry?.firstMaterial?.isDoubleSided = true
            let fragmentShader = """
            #include <metal_stdlib>

            #pragma body
            if (!isFrontFacing) {
                _output.color = float4(0,0,0,1);
            }
            """
            
            node.geometry?.shaderModifiers = [SCNShaderModifierEntryPoint.fragment: fragmentShader]
//        }
    }
    
    func addSlicingShaders(node: SCNNode) {
        let planeEquationValue = NSValue(scnVector4: SCNVector4Make(planeEquation.x, planeEquation.y, planeEquation.z, planeEquation.w))
        node.geometry?.setValue(planeEquationValue, forKey: "plane_equation")
        
        let surfaceShader = """
        #include <metal_stdlib>

        #pragma arguments
        float4 plane_equation;

        #pragma body
        // float4 model_space_position = scn_frame.inverseViewTransform * float4(_surface.position.xyz, 1); // Transforms to model, but plane isn't correctly positioned
        // float4 model_space_position = float4(_surface.position.xyz, 1) * scn_frame.inverseViewTransform; // Doesn't work
        float4 model_space_position = scn_node.inverseModelViewTransform * float4(_surface.position.xyz, 1); // Works
        model_space_position = model_space_position / model_space_position.w;
        float distance = dot(model_space_position.xyz, plane_equation.xyz) + plane_equation.w;

        if (distance > 0.0) {
            discard_fragment();
            //_surface.diffuse.w = 0.5;
            //_surface.transparent = float4(0,0,0,0);
        }
        """
        
        if node.geometry?.shaderModifiers != nil {
            node.geometry?.shaderModifiers![SCNShaderModifierEntryPoint.surface] = surfaceShader
        } else {
            node.geometry?.shaderModifiers = [SCNShaderModifierEntryPoint.surface : surfaceShader]
        }
    }
    
    func placePlane() {
        if self.planeNode != nil {
            self.planeNode?.removeFromParentNode()
        }
        
        let diameter = 0.5
                    
        let planeGeo = SCNPlane(width: diameter, height: diameter)
        self.planeNode = SCNNode(geometry: planeGeo)
        
        self.planeNode!.geometry?.firstMaterial?.isDoubleSided = true
        
        self.planeNode!.worldPosition = self.heartNode!.worldPosition
        
        self.planeNode!.opacity = 0
        
        sceneView.scene.rootNode.addChildNode(self.planeNode!)
    }
    
    func mesh2SCNNode(mesh: Mesh) -> SCNNode {
        let heart_geometry = SCNGeometry(mesh)
        let temp_node = SCNNode(geometry: heart_geometry)
                
        return temp_node
    }
    
    func orientAndScaleNode(node: SCNNode) {
        let (_, radius) = node.boundingSphere
        
        // scale SCNNode so that it is a reasonable size to the viewer
        // 0.25 was choosen as object is set 0.5 units away from user
        let scale_change = 0.25 / radius

        node.scale = SCNVector3(node.scale.x * scale_change,
                                node.scale.y * scale_change,
                                node.scale.z * scale_change)
    }
    
    func placeNodeInFrontOfCamera(node: SCNNode) {
        if let currentFrame = sceneView.session.currentFrame {
            //Add node set distance in front of camera
            var translation = matrix_identity_float4x4
            translation.columns.3.x = 0
            translation.columns.3.y = 0
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)
            node.worldPosition = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        }
        
        self.updatePlaneEquation()
    }
    
    func replaceHeartNodeWith(node: SCNNode) {
        let original_heart_transform = heartNode!.transform
        
        heartNode!.removeFromParentNode()
        
        heartNode = nil
        
        heartNode = node
        
        heartNode?.transform = original_heart_transform
                
//        placeNodeInFrontOfCamera(node: heartNode!)
        
        setFragmentShader(node: heartNode!)
        
        if self.currentToolState == ToolState.slicing {
            addSlicingShaders(node: heartNode!)
        }
        
        sceneView.scene.rootNode.addChildNode(heartNode!)
    }
	
	// Creating an adjustable light SCNNode
    func createLightNode()->SCNNode?{

        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.scale = SCNVector3(1,1,1)
        lightNode.light?.intensity = 400
        lightNode.castsShadow = true
        lightNode.position = SCNVector3Zero
        lightNode.light?.type = SCNLight.LightType.directional
        lightNode.light?.color = UIColor.white
        return lightNode
    }
	
	
	func restartSession() {
		sceneView.session.pause()
		sceneView.scene.rootNode.enumerateChildNodes {
			(node, _) in node.removeFromParentNode()
		}
		sceneView.session.run(arkitConfig, options: [.resetTracking, .removeExistingAnchors])
	}
	
}
