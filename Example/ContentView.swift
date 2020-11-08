import SwiftUI
import PTRScrollView

struct ContentView: View {
    
    @State var records = ["Record 1", "Record 2", "Record 3", "Record 4", "Record 5"]
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                Text("PTRScrollView")
                    .font(.largeTitle)
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea(.all, edges: .top))
            
            Divider()
            
            PTRScrollView {
                VStack{
                    ForEach(records, id: \.self) { record in
                        HStack{
                            Text(record)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .background(Color.white)
                .padding()
                
            } onUpdate: {
                records.append("Record \(records.count + 1)")
            }
        }
        .background(Color.black.opacity(0.1).ignoresSafeArea())
    }
}
