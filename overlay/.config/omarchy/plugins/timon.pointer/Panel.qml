import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "timon.pointer"
  ipcTarget: "timon.pointer"

  property var profiles: []
  property string activeId: ""
  property string activeLabel: "Mouse"
  property real activeSensitivity: 0
  property string statusError: ""
  property int editingCount: 0

  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property color dim: Qt.darker(foreground, 1.45)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family

  function refresh() {
    if (statusProc.running || root.editingCount > 0)
      return
    statusProc.running = true
  }

  function applyStatus(text) {
    var data
    try {
      data = JSON.parse(text)
    } catch (e) {
      statusError = "Could not read pointer speeds"
      return
    }
    statusError = ""
    profiles = data.profiles || []
    activeId = data.active || ""
    activeLabel = data.activeLabel || "Mouse"
    activeSensitivity = data.sensitivity === undefined ? 0 : data.sensitivity
  }

  function setSensitivity(id, value) {
    setProc.command = [Quickshell.env("HOME") + "/.local/bin/omarchy-pointer", "set", id, value.toFixed(2)]
    setProc.running = true
  }

  function formatSpeed(value) {
    var shown = Math.round(value * 100) / 100
    return (shown > 0 ? "+" : "") + shown.toFixed(2)
  }

  Component.onCompleted: refresh()

  Process {
    id: statusProc
    command: [Quickshell.env("HOME") + "/.local/bin/omarchy-pointer", "status"]
    stdout: StdioCollector {
      onStreamFinished: root.applyStatus(text)
    }
  }

  Process {
    id: setProc
    stdout: StdioCollector {
      onStreamFinished: root.applyStatus(text)
    }
    stderr: StdioCollector {
      onStreamFinished: {
        if (text.trim() !== "")
          root.statusError = text.trim()
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    bar: root.bar
    text: "󰍽"
    tooltipText: root.activeLabel + " " + root.formatSpeed(root.activeSensitivity)
    onPressed: root.toggle()
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: Style.space(320)
    contentHeight: panel.fittedContentHeight(column.implicitHeight, Style.space(420))

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      blocked: root.editingCount > 0

    Column {
      id: column
      width: parent.width
      spacing: Style.space(8)

      Text {
        width: parent.width
        text: root.activeLabel + "  " + root.formatSpeed(root.activeSensitivity)
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.heading
        elide: Text.ElideRight
      }

      Text {
        width: parent.width
        text: root.statusError !== "" ? root.statusError : "Flat acceleration. Drag a slider or click a number to type it."
        color: root.dim
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }

      Repeater {
        model: root.profiles

        Column {
          required property var modelData
          width: column.width
          spacing: Style.space(2)

          Row {
            width: parent.width
            spacing: Style.space(8)

            Text {
              text: modelData.connected ? "●" : "○"
              color: modelData.connected ? root.foreground : root.dim
              font.family: root.fontFamily
              font.pixelSize: Style.font.body
            }

            Text {
              text: modelData.label + (modelData.connected ? "" : "  unplugged")
              color: modelData.connected ? root.foreground : root.dim
              font.family: root.fontFamily
              font.pixelSize: Style.font.body
            }

            EditableNumber {
              value: modelData.sensitivity
              displayText: root.formatSpeed(modelData.sensitivity)
              minimum: -1
              maximum: 1
              decimals: 2
              color: root.dim
              editColor: root.foreground
              fontFamily: root.fontFamily
              onEditingChanged: root.editingCount += editing ? 1 : -1
              onCommitted: function(next) { root.setSensitivity(modelData.id, next) }
            }
          }

          PanelSlider {
            width: parent.width
            bar: root.bar
            minimum: -1
            maximum: 1
            step: 0.05
            value: modelData.sensitivity
            onReleased: function(next) {
              root.setSensitivity(modelData.id, next)
            }
          }
        }
      }
    }
    }
  }
}
