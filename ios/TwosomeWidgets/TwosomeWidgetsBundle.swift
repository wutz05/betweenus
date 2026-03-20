import WidgetKit
import SwiftUI

@main
struct TwosomeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        DaysTogetherWidget()
        MessageWidget()
        DistanceWidget()
        UpcomingEventsWidget()
    }
}
