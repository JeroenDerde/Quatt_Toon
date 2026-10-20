import QtQuick 2.1
import qb.components 1.0

Tile {
	id: fileinfoTile
	property var idArray : []
	property bool debugOutput: app.debugOutput
	property bool dimState: screenStateController.dimmedColors
	property bool showPrice:false;

	onClicked: {
		if (app.quattConfigurationScreen) {
			app.quattConfigurationScreen.show()
		}
	}

   
		
    Image {
		id: hunt
		fillMode: Image.PreserveAspectFit
		height: isNxt? 70:56
		source: "file:///qmf/qml/apps/quatt_toon/drawables/hunt.png"
		anchors {
			bottom: parent.bottom
			bottomMargin: 0
			right: parent.right
			rightMargin : 0
		}
		visible: !dimState
    }


    Text {
		id: title
		text: app.quattStatus !== "" ? app.quattStatus : app.quattUpdatedAt
		width: parent.width-20
		wrapMode: Text.WordWrap
		anchors {
			top: parent.top
			topMargin: 2
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt? 20:16
		font.family: qfont.bold.name
		color : dimState?  dimmableColors.clockTileColor : colors.clockTileColor
    }

    Text {
		id: hp1temperatureOutside
		text: app.quattOutsideTemperature
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt? 4:3
			left: parent.left
			leftMargin : 2
		}
		font.pixelSize: isNxt? 20:16
		font.family: qfont.bold.name
		visible: !dimState
    }

    Text {
		id: dimmedCOP
		text: app.quattCop === "" ? "" : "COP " + app.quattCop
		anchors {
			horizontalCenter: parent.horizontalCenter
			bottom: parent.bottom
			bottomMargin: isNxt? 30:24
		}
		color : dimState?  dimmableColors.clockTileColor : colors.clockTileColor
		font.pixelSize:isNxt? 30:24
		font.family: qfont.bold.name
		visible: dimState
    }

    Timer {
		id: scrapeTimer
		interval: 30000
		repeat: true
		running: true
		triggeredOnStart: true
		onTriggered: {
			app.getQuatt()
		}
   }

}
