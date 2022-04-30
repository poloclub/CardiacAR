import SwiftUI
import Introspect
import SceneKit



// MARK: - ARViewIndicator

struct SceneViewIndicator: UIViewControllerRepresentable {
	typealias UIViewControllerType = SceneViewController
	
	func makeUIViewController(context: Context) -> SceneViewController {
		return SceneViewController()
	}
	
	func updateUIViewController(_ uiViewController:
								SceneViewIndicator.UIViewControllerType, context:
								UIViewControllerRepresentableContext<SceneViewIndicator>) { }
}


extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

var screenSize: CGRect = UIScreen.main.bounds
var addedNodes: [SCNVector3] = []


struct MainView: View {
	@State private var tabSelection = 1
	@State var uiTabarController: UITabBarController?
    @State private var presentImporter = false
    @State private var modelPath: URL?
    @State private var showPopUp: Bool = false


	init() {

		UITabBar.appearance().tintColor = .systemCyan
		UITabBar.appearance().unselectedItemTintColor = UIColor.white
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
		
	}
	var body: some View {
//        ScrollView {
        TabView(selection: $tabSelection) {
                
    //            HomeView()


    //            NavigationView {
    //                ZStack {
    //                    Color.CardiacARBackgroundBlue
    //                        .ignoresSafeArea()
    //                    Text("Welcome to CardiacAR!")
    //                        .font(.system(size: 25.0))
    //                        .fontWeight(.semibold)
    //                        .foregroundColor(.white)
    //                    .navigationBarTitle("Home")
    //
    //
    //                }
    //
    //            }
            NavigationView {
                
                ZStack(alignment: .top) {
                    Color.CardiacARBackgroundBlue
                        .ignoresSafeArea()
                    
                    VStack(alignment:.center, spacing:10) {
                        
    //                    Spacer().frame(height:124)
                        
                        Text("Home")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 42*screenSize.height*0.001))
                            .padding(.top, 60)
                            .padding(.bottom, 10)
                        
    //                    Spacer().frame(height:-18)
                        
                        /* Button {
                            self.tabSelection = 3
                        } label: {
                            ZStack(alignment: .top) {
                                                    
                                Rectangle()
                                    .fill(Color.limeGreen)
                                    .frame(minHeight:screenSize.height*0.2, maxHeight:screenSize.height*0.5,  alignment: .center)
                                    .cornerRadius(25)
                                
                                VStack(alignment: .center) {
                                    
                                    Spacer().frame(height:25)
                                    
                                    HStack(alignment: .center) {
                                        
        //                                Spacer()
        //                                    .frame(width:23)
                                        
                                        ZStack{
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                .cornerRadius(12)
                                                .opacity(0.35)

                                            Image("Courses")
                                        }

                                        Spacer().frame(width: 18)
                                        
                                        Text("Recently Opened")
                                            .bold()
                                            .font(.customStyle)
                                            .frame(minWidth: 0, alignment: .leading)
                                            .foregroundColor(.white)
                                        
        //                                Spacer()
        //                                    .frame(width:40.48)

                                    }
        //                            .frame(alignment: .center)
                                    
                                    Spacer().frame(height:25)
                                    
                                    ScrollView {
                                        
                                        ForEach(1..<11) { num in
                                            HStack(alignment: .center) {

                //                                Spacer().frame(width:28)

                                                VStack(alignment: .leading, spacing:10) {
                                                    Text("Project \(num)")
                                                        .font(.subheadingStyle)
                                                        .foregroundColor(.white)
                                                        .bold()

                                                    Text("Would you like to continue?")
                                                        .foregroundColor(.white)
                                                }

                                                Spacer()

                                                ZStack {

                                                    Circle()
                                                        .fill(Color.white)
                                                        .frame(width: 37.41, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                                                    Circle()
                                                        .fill(Color.white)
                                                        .frame(width: 46.76, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                                        .opacity(0.35)

                                                    Text("OK")
                                                        .foregroundColor(Color.limeGreen)
                                                        .font(.system(size:14))
                                                        .bold()

                                                }

                                            }
                                            
                                            Divider().opacity(0.2)
                                        }
                                        
                                    }
                                    .padding(.bottom, 15)
                                    
                                }
                                .frame(minWidth: 200, maxWidth: screenSize.width*0.8, minHeight:screenSize.height*0.2, maxHeight:screenSize.height*0.5, alignment: .center)
                        
                                
                                
                            }
        //                    .padding(.top)
                            .padding(.trailing)
                            .padding(.leading)
        //                    .frame(height:500)

                        } */
                        
                        
                        Button {
                            self.tabSelection = 2
                        } label: {
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .fill(Color.pastelRed)
                                    .frame(minHeight:screenSize.height*0.1, maxHeight:screenSize.height*0.15,  alignment: .center)
                                    .cornerRadius(25)
                                
                                HStack(alignment: .center) {
                                    
                                    Spacer()
                                    
                                    ZStack(alignment: .center) {

                                        Circle()
                                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(.white)
                                            .opacity(0.35)

                                        Circle()
                                            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(.white)

                                        Image("camera")

                                    }
                                    .padding(.trailing, 15)

                                    
                                    VStack() {
                                        
                                        Text("AR View")
                                            .bold()
                                            .font(.customStyle)
                                            .frame(minWidth: 0, alignment: .center)
                                            .foregroundColor(.white)
										Spacer()
											.frame(height: 5)
                                        
                                        Text("Use the camera to view the cardiac model in real-life scenes.")
											.multilineTextAlignment(.leading)
                                            .frame(minWidth: 0, alignment: .center)
                                            .foregroundColor(.white)
                                            .font(.system(size: 16))
                                    }

                                    Spacer()


                                    
                                }
                                .padding(.top, 25)
                                .padding(.bottom, 25)
                                .frame(minWidth: 0, maxWidth: screenSize.width*0.8, alignment: .center)

                            }
        //                    .padding(.bottom)
                            .padding(.leading)
                            .padding(.trailing)
        //                    .frame(height:screenSize.height*0.2)
        //                    .padding(.horizontal, 24)

                        }
                        /*
                        ZStack(alignment: .center) {
                            
                            Rectangle()
                                .fill(Color.ochreYellow)
                                .frame(minHeight: screenSize.height*0.1, idealHeight:screenSize.height*0.1, maxHeight: screenSize.height*0.12, alignment: .center)
                                .cornerRadius(25)
                            
                            HStack(alignment: .center) {
                                
                                Spacer()

                                
                                ZStack(alignment: .center) {

                                    Rectangle()
                                        .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.white)
                                        .opacity(0.35)
                                        .cornerRadius(12)
                                    
                                    Image("label")

                                }
                                .padding(.trailing, 15)
                                
    //                            Spacer()
                                
                                VStack() {
                                    
                                    Text("Labels")
                                        .bold()
                                        .font(.customStyle)
                                        .frame(minWidth: 0, alignment: .leading)
                                        .foregroundColor(.white)
                                    
                                    Text("Add and edit your labels")
                                        .multilineTextAlignment(.center)
                                        .frame(minWidth: 0, alignment: .center)
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
    //                                    .padding(.top, 15)
    //                                    .padding(.bottom, 25)
                                }

                                Spacer()

                                
                            }
    //                        .padding(.top, 25)
    //                        .padding(.bottom, 25)
                            .frame(minWidth: 0, maxWidth: screenSize.width*0.8, alignment: .center)
                        }
                        .padding(.bottom)
                        .padding(.leading)
                        .padding(.trailing)
                        
    //                    Spacer().frame(height:114)
                        
    //                    Spacer()
                        */
                    }
                    
                    Spacer()

                }
                .edgesIgnoringSafeArea(.top)
    //            .edgesIgnoringSafeArea(.bottom)
            }
            .ignoresSafeArea()
    //        .background(Color.navyBlue)
            .navigationViewStyle(StackNavigationViewStyle())
    //                .tabViewStyle(PageTabViewStyle())
//                    .edgesIgnoringSafeArea(.all)
                    .tabItem {
                        Label("Home", systemImage: "house")
                            .environment(\.symbolVariants, .none)
                    }
                    .background(Color.CardiacARBackgroundBlue)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tag(1)
                
                
                ZStack {
                    
                    SceneViewIndicator()
                        .ignoresSafeArea()
                    ZStack {
                    
                        VStack {
                                         
                            HStack {
                                Button{
                                    self.tabSelection = 1
                                    
                                }label: {
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .frame(width: 15)
                                        Text("Home")
                                    }
                                }
                                .font(Font.headline.weight(.bold))
                                .padding(.vertical, 30)
                                .padding(.leading, 20)
                                .contentShape(Rectangle())
                                //                        .frame(width: 100, height: 100)
                                Spacer()
                                
                            }
                            Spacer()

                        }
                        
//                        Button(action: {
//                                withAnimation(.linear(duration: 0.3)) {
//                                    showPopUp.toggle()
//                                }
//                            },
//                               label: {
//                                Text("Show PopUp Window")
//                            })
//                                .padding()
//                                .background(Color(#colorLiteral(red: 0.6196078431, green: 0.1098039216, blue: 0.2509803922, alpha: 1)))
//
//                        PopUpView(title: "Error", message: "Sorry, that email address is already used!", buttonText: "OK", show: $showPopUp)
//
                    }
                    
                }
                .tabItem {
                    Label("AR View", systemImage: "arkit")
                        .foregroundColor(.cyan)
                }
                .introspectTabBarController { (UITabBarController) in
//                            print("initial")
                            UITabBarController.tabBar.isHidden = true
                            uiTabarController = UITabBarController
                        }.onDisappear{
                            uiTabarController?.tabBar.isHidden = false
//                            print(false)
                        }
                        .onAppear{
                            uiTabarController?.tabBar.isHidden = true
//                            print(true)
                        }
                .tag(2)
                
//                ProjectView()
//                .tabItem {
//                    Label("Projects", systemImage: "tray.full.fill")
//                }
//                .navigationViewStyle(StackNavigationViewStyle())
//                .tag(3)

            }
            .frame(
                width: UIScreen.main.bounds.width ,
                height: UIScreen.main.bounds.height
            )
//            .tabViewStyle(PageTabViewStyle())
            .accentColor(Color(.systemCyan))
//        }
        .edgesIgnoringSafeArea(.all)
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
			.previewInterfaceOrientation(.portrait)
		//        ViewController()
	}
}



