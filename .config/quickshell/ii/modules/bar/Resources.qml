import qs.modules.common
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    property bool alwaysShowAllResources: false
    implicitWidth: rowLayout.implicitWidth + rowLayout.anchors.leftMargin + rowLayout.anchors.rightMargin
    implicitHeight: Appearance.sizes.barHeight
    hoverEnabled: true

    RowLayout {
        id: rowLayout

        spacing: 0
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        Resource {
            iconName: "memory"
            percentage: ResourceUsage.memoryUsedPercentage
            warningThreshold: Config.options.bar.resources.memoryWarningThreshold
        }

        // Resource {
        //     iconName: "swap_horiz"
        //     percentage: ResourceUsage.swapUsedPercentage
        //     shown: (Config.options.bar.resources.alwaysShowSwap && percentage > 0) ||
        //         (MprisController.activePlayer?.trackTitle == null) ||
        //         root.alwaysShowAllResources
        //     Layout.leftMargin: shown ? 6 : 0
        //
        //     tooltipHeaderIcon: "swap_horiz"
        //     tooltipHeaderText: Translation.tr("Swap usage")
        //     tooltipData: ResourceUsage.swapTotal > 0 ? [
        //         { icon: "clock_loader_60", label: Translation.tr("Used:"), value: formatKB(ResourceUsage.swapUsed) },
        //         { icon: "check_circle", label: Translation.tr("Free:"), value: formatKB(ResourceUsage.swapFree) },
        //         { icon: "empty_dashboard", label: Translation.tr("Total:"), value: formatKB(ResourceUsage.swapTotal) },
        //     ] : [
        //         { icon: "swap_horiz", label: Translation.tr("Swap:"), value: Translation.tr("Not configured") }
        //     ]
        // }

        Resource {
            iconName: "planner_review"
            percentage: ResourceUsage.cpuUsage
            shown: Config.options.bar.resources.alwaysShowCpu ||
                !(MprisController.activePlayer?.trackTitle?.length > 0) ||
                root.alwaysShowAllResources
            Layout.leftMargin: shown ? 6 : 0
            warningThreshold: Config.options.bar.resources.cpuWarningThreshold
        }

    }

    ResourcesPopup {
        hoverTarget: root
    }
}
