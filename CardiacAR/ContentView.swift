import SwiftUI

extension Color {
    static let navyBlue = Color(red:2/255, green:67/255, blue:128/255)
}

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

struct ContentView: View {

    var body: some View {
    
        TabView {

			HomeView()
            .tabItem {
				Label("Home", systemImage: "house.fill")
                }

            
			SceneViewIndicator()
            .tabItem {
				Label("AR View", systemImage: "arkit")
            }
            .edgesIgnoringSafeArea(.top)
            
            ProjectView()
                .tabItem {
                    Label("Projects", systemImage: "tray.full.fill")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
.previewInterfaceOrientation(.landscapeRight)
//        ViewController()
    }
}
