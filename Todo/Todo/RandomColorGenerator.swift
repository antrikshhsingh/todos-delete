import UIKit

class RandomColorGenerator {
    var color1: UIColor
    var color2: UIColor
    var opacity: CGFloat
    
    init(color1: UIColor, color2: UIColor, opacity: CGFloat) {
        self.color1 = color1
        self.color2 = color2
        self.opacity = opacity
    }
    
    func randomColor() -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        let randomColor = UIColor(red: r, green: g, blue: b, alpha: opacity)
        
        return randomColor
    }
}
