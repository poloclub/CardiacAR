import SwiftUI

struct ProjectView: View {
    
    var body: some View {
        
        NavigationView {
            
            ZStack() {
                Color.navyBlue
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    Text("Projects")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 42*screenSize.height*0.001))
                        .padding(.top, 40)
                    
                     ScrollView {
                        ForEach(1 ..< 4) { item in
                            ZStack (alignment: .leading) {
                                Rectangle()
                                    .frame(height: screenSize.height*0.1)
                //                    .padding()
                                    .foregroundColor(Color.ochreYellow)
                                    .cornerRadius(25)
                            
                                VStack(alignment: .leading) {
                                
                                    Text("Project " + String(item))
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .bold()
                                    Text("Project Description")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .padding(.horizontal, 25)
                            }
                            .padding(.bottom, 10)
                            .padding(.horizontal, 25)
                        }
                         
                         
                         Button(action: {
                             
                             print("Add New Tapped")
                             
                         }) {
                             HStack(alignment:.center) {
                                 Image(systemName: "plus")
                                     .frame(height: screenSize.height*0.05)
                                 Text("Add New")
                                     .font(.customStyle)
                                     .bold()
                             }
                         }
                         .padding(.top, 20)
                         
                    }
                }
            }
            .ignoresSafeArea(edges: .top)

        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView()
    }
}
