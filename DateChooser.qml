import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQml 2.2
import QtGraphicalEffects 1.0

Item {
    id: dateChooser
    anchors.fill: parent

    property alias defaultFontPixelSize: hiddenText.font.pixelSize
    property alias stack: hoursStackView.stack
    property var area: area
    property int listIndex
    property var calendar: bookingCalendar
    property var startDateTime: hoursStackView.startDateTime
    property var endDateTime: hoursStackView.endDateTime

    Text {id: hiddenText}

    function setListIndex(val) {
        listIndex = val
        hoursStackView.setListIndex(val)
    }

    SwipeArea {
         id: mouseM
         menu: menuView
         anchors.fill: parent
         onMove: {
             console.log("onMove...")
             area.enabled = false
             menuView.x = (-mainArea.width * menuView.currentIndex) + x // changing menu x
             normalViewMask.opacity = (1 -((Math.abs(menuView.x)/menuView.width)))/1.5 // changing normal view opacity
         }
         onSwipe: {
             console.log("onSwipe...")
             mainArea.menuChange()
         }
         onCanceled: {
             console.log("onCanceled...")
             menuView.currentIndexChanged()
             normalViewMask.opacity = menuView.currentIndex === 1 ? 0 : 0.7
             area.enabled = menuView.currentIndex === 1 ? true : false
         }
     }

    Rectangle {
        id: area
        property int offset: 20
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; top: parent.top; margins: offset }
        property int areaHeight: (screenH - topFrame.height - (2*offset))

        Calendar {
           id: bookingCalendar
           anchors.top: parent.top
           anchors.left: parent.left
           anchors.right: parent.right
           width: parent.width
           height: parent.height * 0.5
           z: hoursStackView.z + 1

           style: CalendarStyle {
               gridVisible: false
               background: Rectangle { color: "white";}
               navigationBar: Rectangle {
                          id: naviBar
                          color: "#FF6900"
                          height: dateText.height * 2

                          ToolButton {
                              id: previousMonth
                              width: parent.height
                              height: width
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.left: parent.left
                              iconSource: "/images/images/left-angle-arrow.png"
                              onClicked: control.showPreviousMonth()
                          }
                          Label {
                              id: dateText
                              text: styleData.title
                              font.pixelSize: defaultFontPixelSize * 1.2
                              color: "white"
                              horizontalAlignment: Text.AlignHCenter
                              verticalAlignment: Text.AlignVCenter
                              fontSizeMode: Text.Fit
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.left: previousMonth.right
                              anchors.leftMargin: 2
                              anchors.right: nextMonth.left
                              anchors.rightMargin: 2
                          }
                          ToolButton {
                              id: nextMonth
                              width: parent.height
                              height: width
                              anchors.verticalCenter: parent.verticalCenter
                              anchors.right: parent.right
                              iconSource: "/images/images/right-angle-arrow.png"
                              onClicked: control.showNextMonth()
                          }
               }

               dayDelegate: Rectangle {
                   id: rect
                   border.width: 1;
                   border.color: "lightgray"
                   color: styleData.selected ? "#97d4ff" : "transparent";

                   Canvas {
                       id: root
                       // canvas size
                       height: 20
                       width: 20
                       // handler to override for drawing
                       onPaint: {
                           // get context to draw with
                           var ctx = getContext("2d")
                           // setup the stroke
                           ctx.lineWidth = 4
                           ctx.strokeStyle = "blue"
                           // setup the fill
                           ctx.fillStyle = "steelblue"
                           // begin a new path to draw
                           ctx.beginPath()
                           // top-left start point
                           ctx.moveTo(50,50)
                           // upper line
                           ctx.lineTo(150,50)
                           // right line
                           ctx.lineTo(150,150)
                           // bottom line
                           ctx.lineTo(50,150)
                           // left line through path closing
                           ctx.closePath()
                           // fill using fill style
                           ctx.fill()
                           // stroke using line width and stroke style
                           ctx.stroke()
                       }
                   }
//                   Rectangle {
//                       height: parent.height/3
//                       width: parent.height/3
//                       color: (carViewClass.carList[listIndex].isDateReserved(styleData.date)) ? "darkorange" : "transparent";
//                       gradient: Gradient {
//                           GradientStop { position: 0.0; color: "lightsteelblue" }
//                           GradientStop { position: 1.0; color: "blue" }
//                       }
//                   }

                   Label {
                       text: styleData.date.getDate()
                       anchors.centerIn: parent
                       readonly property color sameMonthDateTextColor: "#444"
                       readonly property color selectedDateTextColor: "#111"
                       readonly property color differentMonthDateTextColor: "#bbb"
                       readonly property color invalidDatecolor: "#dddddd"

                       color: "gray"
//                       {
//                           var color = invalidDatecolor;
//                           if (styleData.valid) {
//                               // Date is within the valid range.
//                               color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
//                               if (styleData.selected) {
//                                   color = selectedDateTextColor;
//                               }
//                           }
//                           color;
//                       }
                   }

               }

           } // CalendarStyle

        } // Calendar

        HoursStackView {
            id: hoursStackView
            anchors.top: calendar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: 10
            width: parent.width
            height: parent.height * 0.5
        }

    } // Rectangle

} // Item

