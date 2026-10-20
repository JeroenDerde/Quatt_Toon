import QtQuick 2.1
import qb.components 1.0

Screen {
	id: quattConfigurationScreen

	screenTitle: "Quatt instellingen"
	hasBackButton: true

	function saveQuattUrl(text) {
		urlLabel.inputText = text
	}

	onShown: {
		addCustomTopRightButton("Opslaan")
		urlLabel.inputText = app.quattDataUrl
	}

	onCustomButtonClicked: {
		var url = urlLabel.inputText.trim()
		if (!app.isValidQuattUrl(url)) {
			app.quattStatus = qsTr("Vul een geldige HTTP-URL in")
			return
		}

		if (!app.saveQuattSettings(url)) return
		hide()
		app.getQuatt()
	}

	EditTextLabel4421 {
		id: urlLabel
		x: 20
		y: 24
		width: 760
		height: 40
		leftTextAvailableWidth: 180
		leftText: "Quatt JSON-URL:"

		onClicked: {
			qkeyboard.open("Voer de URL van het Quatt JSON-bestand in", urlLabel.inputText, saveQuattUrl)
		}
	}

	Text {
		x: 24
		y: 78
		width: 740
		text: "Voorbeeld: http://<quatt-ip-address>/api/cic.json"
		font.pixelSize: 16
		color: "Black"
		wrapMode: Text.WordWrap
	}

	Text {
		x: 24
		y: 112
		width: 740
		text: app.quattStatus
		font.pixelSize: 16
		color: "Black"
		wrapMode: Text.WordWrap
	}
}
