import qs.modules.common
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    
    // 可自定义属性
    property color textColor: "#A7C080"
    property color backgroundColor: "transparent"
    property int fontSize: 12
    property bool showIcons: true
    property string iconDown: "↓"
    property string iconUp: "↑"
    
    // 内部状态
    property real downloadSpeed: 0
    property real uploadSpeed: 0
    
    implicitWidth: layout.implicitWidth + 26
    implicitHeight: 20
    color: backgroundColor
    radius: 4
    
    // Python 进程
    Process {
        id: networkMonitor
        command: ["python3", "/home/zerone/projects/dots-hyprland/.config/quickshell/ii/scripts/network_speed.py"]  // 修改为你的脚本路径
        running: true
        stdout: SplitParser {
            onRead: (line) => {
                try {
                    let data = JSON.parse(line);
                    root.downloadSpeed = data.download;
                    root.uploadSpeed = data.upload;
                } catch (e) {
                    console.error("Failed to parse network data:", e);
                }
            }
        }
    }
    
    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 8
        
        // 下载速度
        Row {
            spacing: 4
            
            Text {
                text: root.showIcons ? root.iconDown : ""
                color: "#4CAF50"
                font.pixelSize: root.fontSize
                font.family: Appearance.font.family.main
                verticalAlignment: Text.AlignVCenter
            }
            
            Text {
                text: formatSpeed(root.downloadSpeed)
                color: root.textColor
                font.pixelSize: root.fontSize
                font.family: Appearance.font.family.main
                verticalAlignment: Text.AlignVCenter
            }
        }
        
        // 分隔符
        Rectangle {
            width: 1
            height: root.fontSize + 4
            color: root.textColor
            opacity: 0.3
        }
        
        // 上传速度
        Row {
            spacing: 4
            
            Text {
                text: root.showIcons ? root.iconUp : ""
                color: "#FF9800"
                font.pixelSize: root.fontSize
                font.family: Appearance.font.family.main
                verticalAlignment: Text.AlignVCenter
            }
            
            Text {
                text: formatSpeed(root.uploadSpeed)
                color: root.textColor
                font.pixelSize: root.fontSize
                font.family: Appearance.font.family.main
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    
    // 格式化速度显示
    function formatSpeed(kb) {
        if (kb < 1) {
            return "0 KB/s";
        } else if (kb < 1024) {
            return kb.toFixed(1) + " KB/s";
        } else {
            let mb = kb / 1024;
            return mb.toFixed(1) + " MB/s";
        }
    }
}
