//11-2023
//by JeroenDerde

import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: quattApp
	property bool 		debugOutput: false
	property url 		tileUrl : "QuattTile.qml"
	property url		configurationScreenUrl: "QuattConfigurationScreen.qml"
	property url 		thumbnailIcon: "qrc://apps/statusUsage/drawables/tile_total_thumb.svg"
	property 			QuattTile QuattTile
	property var		quattConfigurationScreen
	property string		quattDataUrl: "http://<quatt-ip-address>/api/cic.json"
	property string		quattStatus: qsTr("Stel de Quatt-URL in")
	property string		quattUpdatedAt: ""
	property string		quattOutsideTemperature: ""
	property string		quattCop: ""

	FileIO {
		id: settingsFile
		source: "file:///mnt/data/tsc/quatt.settings.json"
	}
	
	function init() {
		registry.registerWidget("tile", tileUrl, this, "QuattTile", {thumbLabel: qsTr("Quatt"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
		registry.registerWidget("screen", configurationScreenUrl, this, "quattConfigurationScreen")
	}

	Component.onCompleted: loadQuattSettings()

	function loadQuattSettings() {
		try {
			var settings = JSON.parse(settingsFile.read())
			if (settings.jsonUrl) {
				quattDataUrl = settings.jsonUrl
			}
		} catch (error) {
			if (debugOutput) console.log("*********QUATT Could not read settings: " + error)
		}
	}

	function isValidQuattUrl(url) {
		return /^https?:\/\/[^<>\s]+$/.test(url)
	}

	function saveQuattSettings(url) {
		quattDataUrl = url
		quattStatus = qsTr("Quatt ophalen...")

		var request = new XMLHttpRequest()
		try {
			request.open("PUT", "file:///mnt/data/tsc/quatt.settings.json", true)
			request.onreadystatechange = function() {
				if (request.readyState === 4 && request.status >= 400) {
					quattStatus = qsTr("Instellingen opslaan mislukt")
					if (debugOutput) console.log("*********QUATT Could not save settings: " + request.status)
				}
			}
			request.onerror = function() {
				quattStatus = qsTr("Instellingen opslaan mislukt")
				if (debugOutput) console.log("*********QUATT Could not save settings")
			}
			request.send(JSON.stringify({ "jsonUrl": quattDataUrl }))
			return true
		} catch (error) {
			quattStatus = qsTr("Instellingen opslaan mislukt")
			if (debugOutput) console.log("*********QUATT Could not save settings: " + error)
			return false
		}
	}

	function getQuatt() {
		if (!isValidQuattUrl(quattDataUrl)) {
			quattStatus = qsTr("Stel de Quatt-URL in")
			return
		}

		var request = new XMLHttpRequest()
		try {
			request.open("GET", quattDataUrl, true)
		} catch (error) {
			quattStatus = qsTr("Quatt niet bereikbaar")
			if (debugOutput) console.log("*********QUATT Request failed: " + error)
			return
		}
		request.onreadystatechange = function() {
			if (request.readyState !== 4) return

			if (request.status < 200 || request.status >= 300) {
				quattStatus = qsTr("Quatt niet bereikbaar")
				if (debugOutput) console.log("*********QUATT Request failed: " + request.status)
				return
			}

			try {
				var data = JSON.parse(request.responseText)
				if (!data.time || !data.hp1 || data.hp1.temperatureOutside === undefined) {
					throw new Error("Missing time or heat-pump data")
				}

				var outsideTemperature = Number(data.hp1.temperatureOutside)
				if (data.hp1.temperatureOutside === null || !isFinite(outsideTemperature)) {
					throw new Error("Invalid outside temperature")
				}

				quattOutsideTemperature = outsideTemperature.toFixed(1) + "°C"
				quattUpdatedAt = data.time.tsHuman || qsTr("Quatt verbonden")

				var heatOutput = Number(data.hp1.power)
				var powerInput = Number(data.hp1.powerInput)
				quattCop = typeof data.hp1.power === "number" && typeof data.hp1.powerInput === "number"
						&& isFinite(heatOutput) && isFinite(powerInput) && powerInput > 0
						? (heatOutput / powerInput).toFixed(1)
						: ""
				quattStatus = ""
			} catch (error) {
				quattStatus = qsTr("Ongeldige Quatt-JSON")
				if (debugOutput) console.log("*********QUATT Could not parse response: " + error)
			}
		}
		request.onerror = function() {
			quattStatus = qsTr("Quatt niet bereikbaar")
			if (debugOutput) console.log("*********QUATT Network request failed")
		}
		try {
			request.send()
		} catch (error) {
			quattStatus = qsTr("Quatt niet bereikbaar")
			if (debugOutput) console.log("*********QUATT Request failed: " + error)
		}
	}
} 
