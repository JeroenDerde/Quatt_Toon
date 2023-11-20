import QtQuick 2.1
import qb.components 1.0

Tile {
	id: fileinfoTile
	property var idArray : []
	property bool debugOutput: app.debugOutput
	property bool dimState: screenStateController.dimmedColors
	property bool showPrice:false;

	onClicked: {
		getQuatt()	
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
		text: "Wacht op Quatt"
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
		text:  ""
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt? 4:3
			left: parent.left
			leftMargin : 2
		}
		font.pixelSize: isNxt? 20:16
		font.family: qfont.bold.name
		font.strikeout: true
		visible: !dimState
    }

    Text {
		id: dimmedCOP
		text:  ""
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

    function getQuatt(){
        if (debugOutput) console.log("*********QUATT Start getQuatt")
        
		var http = new XMLHttpRequest()
        var siteURL = "https://www.ibood.com/offers/nl/s-nl?" + Math.random()*Math.random();
        var xhr = new XMLHttpRequest();
            xhr.open("GET", siteURL, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4) {
                    var parseString = xhr.responseText;
                                    
                    var quattState = JSON.parse(parseString);
					
					

                    scrapeTimer.interval = 30000
                    
                    if (debugOutput) console.log("*********QUATT " + "Scraper Interval: " + scrapeInterval)

                    title.text =  quattState.time.tsHuman

                    hp1temperatureOutside.text = quattState.hp1.temperatureOutside
                                     
					hp1DimmedCOP.text = "0"
                }
            }
            xhr.send();    
	}

    Timer {
		id: scrapeTimer
		interval: 30000
		repeat: true
		running: true
		triggeredOnStart: false
		onTriggered: {
			getQuatt()
		}
   }

}
