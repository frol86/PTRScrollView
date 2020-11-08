import SwiftUI

struct PTRScrollView<Content: View>: View {
    
    private struct Refresh {
        var startOffset : CGFloat = 0
        var offset : CGFloat = 0
        var started : Bool
        var released: Bool
        var invalid : Bool = false
    }
    
    @State private var refresh = Refresh(started: false, released: false)
    
    private var content: Content
    private var onUpdate : ()->()
    
    init(@ViewBuilder content: ()-> Content, onUpdate: @escaping ()->()) {
        self.content = content()
        self.onUpdate = onUpdate
    }
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false, content: {
            GeometryReader { reader -> AnyView in
                DispatchQueue.main.async {
                    
                    if refresh.startOffset == 0 {
                        refresh.startOffset = reader.frame(in: .global).minY
                    }
                    
                    refresh.offset = reader.frame(in: .global).minY
                    
                    if refresh.offset - refresh.startOffset > 80 && !refresh.started {
                        refresh.started = true
                    }
                    
                    if refresh.startOffset == refresh.offset && refresh.started && !refresh.released {
                        withAnimation(Animation.linear){refresh.released = true}
                        update()
                    }
                    
                    if refresh.startOffset == refresh.offset && refresh.started && refresh.released && refresh.invalid {
                        refresh.invalid = false
                        update()
                    }
                }
                return AnyView(Color.black.frame(width: 0, height: 0))
            }
            .frame(width: 0, height: 0)
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                
                if refresh.started {
                    ProgressView()
                        .offset(y: -32)
                }
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
            }
            .offset(y: refresh.started ? 40 : -10)
        })
    }
    
    private func update() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(Animation.linear) {
                if refresh.startOffset == refresh.offset {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
                        withAnimation(Animation.linear) {
                            onUpdate()
                        }
                    }
                    refresh.released = false
                    refresh.started = false
                }
                else {
                    refresh.invalid = true
                }
            }
        }
    }
    
}
