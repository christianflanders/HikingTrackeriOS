import Foundation
import Charts
 class XYMarkerView1: BalloonMarker
{
    open var xAxisValueFormatter: IAxisValueFormatter?
    open var yAxisValueFormatter: IAxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets, xAxisValueFormatter: IAxisValueFormatter, yAxisValueFormatter : IAxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        self.yAxisValueFormatter = yAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        let x = entry.x
        let y = entry.y
        
        setLabel("x: " + xAxisValueFormatter!.stringForValue(x, axis: nil) + ", y: " + yAxisValueFormatter!.stringForValue(y, axis: nil))
    }
}

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        
        let string = "x: "
            + xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            + ", y: "
            + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!
        setLabel(string)
    }
    
}
