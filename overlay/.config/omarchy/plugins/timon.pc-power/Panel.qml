import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// Live CPU + GPU watts, read in-process every 1 s (no process per tick).
// CPU: Ryzen 7000 reports socket PPT through the iGPU's amdgpu hwmon
// (power1_input) - readable without root, unlike RAPL energy_uj.
// GPU: the dedicated amdgpu hwmon (power1_average, else power1_input).
// iGPU vs dGPU is told apart by VRAM size, so hwmon renumbering is fine.
Panel {
  id: root
  moduleName: "timon.pc-power"

  property string cpuPath: ""
  property string gpuPath: ""
  property real cpuW: -1
  property real gpuW: -1

  Process {
    id: discover
    running: true
    command: ["sh", "-c",
      "for h in /sys/class/hwmon/hwmon*; do [ \"$(cat $h/name 2>/dev/null)\" = amdgpu ] || continue; " +
      "f=$h/power1_average; [ -r $f ] || f=$h/power1_input; [ -r $f ] || continue; " +
      "echo \"$(cat $h/device/mem_info_vram_total 2>/dev/null || echo 0) $f\"; done | sort -n"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        var lines = text.trim().split("\n").filter(function(l) { return l !== "" })
        if (lines.length >= 2) root.cpuPath = lines[0].split(" ")[1]
        if (lines.length >= 1) root.gpuPath = lines[lines.length - 1].split(" ")[1]
      }
    }
  }

  FileView { id: cpuFile; path: root.cpuPath; blockLoading: true }
  FileView { id: gpuFile; path: root.gpuPath; blockLoading: true }

  function read(file, path) {
    if (path === "") return -1
    file.reload()
    var v = Number(file.text()) / 1e6
    return isFinite(v) ? v : -1
  }

  Timer {
    interval: 1000
    running: root.gpuPath !== ""
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      root.cpuW = root.read(cpuFile, root.cpuPath)
      root.gpuW = root.read(gpuFile, root.gpuPath)
    }
  }

  readonly property real totalW: Math.max(0, root.cpuW) + Math.max(0, root.gpuW)

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    // Stock text-widget layout, copied from the vanilla weather widget:
    // BarIconButton with the status slot, plain "<N>W", no icon.
    text: (root.gpuW >= 0 && !vertical) ? Math.round(root.totalW) + "W" : ""
    slotSize: Style.bar.statusSlot
    tooltipText: (root.cpuW >= 0 ? "CPU " + Math.round(root.cpuW) + " W" : "CPU n/a") +
                 "\nGPU " + (root.gpuW >= 0 ? Math.round(root.gpuW) + " W" : "n/a")
  }
}
