import SwiftUI

struct WelcomeView: View {
	var body: some View {
		
		ZStack {
			
			Color.CardiacARBackgroundBlue.edgesIgnoringSafeArea(.all)
			
			Image("heart-sketch")
				.padding()
				.frame(width: 300.0, height: 300.0)
				.background(Color.CardiacARBackgroundBlue)
				.position(x:57+150, y:85+150)
			
			Image("AppName")
				.position(x:79+128, y:413+34.5)
			
			Image("subline")
				.position(x:96+111, y:618+17)
			
		}
		//        .ignoresSafeArea()
	}
}

struct WelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		WelcomeView()
	}
}
