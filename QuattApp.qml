//11-2023
//by JeroenDerde

import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;

App {
	id: iboodApp
	property bool 		debugOutput: false
	property url 		tileUrl : "QuattTile.qml"
	property url 		thumbnailIcon: "qrc://apps/statusUsage/drawables/tile_total_thumb.svg"
	property 			QuattTile QuattTile
	
	function init() {
		registry.registerWidget("tile", tileUrl, this, "QuattTile", {thumbLabel: qsTr("Quatt"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
	}
} 
