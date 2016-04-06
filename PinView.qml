import QtQuick 2.5
import QtQuick.Dialogs 1.2

Item {
    anchors.fill: parent
    property string returnCode
    property alias field: code.field
    property int listIndex
    function clearText() { code.clear(); label.forceActiveFocus() }
    function setListIndex(val) { listIndex = val }

    Text { id: label; width: parent.width; height: label.font.pointSize * 2
        anchors { top: parent.top; topMargin: 20; }
        horizontalAlignment: Text.AlignHCenter
        text: "Wprowadź kod:"
        font.pixelSize: screenH/25      
        color: "gray"
    }

    CustomTextField { id: code;  width: parent.width/2; height: 50;
        anchors { horizontalCenter: parent.horizontalCenter; top: label.bottom; topMargin: 30; }
        horizontalAlignment: Text.AlignHCenter
        maximumLength : 6
        customReturnKey: true
    }

} // Item
