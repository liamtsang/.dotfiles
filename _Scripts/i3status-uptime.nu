let uptime = (uptime -p)
let days = (echo $uptime | grep -oP '\d+(?= day)')
let hours = (echo $uptime | grep -oP '\d+(?= hour)')
let minutes = (echo $uptime | grep -oP '\d+(?= minute)')

let formatted_uptime = ""
if $days != "" {
  let formatted_uptime = $'($days)d'
}
let formatted_uptime = $"($formatted_uptime)($hours)h ($minutes)m"

echo $formatted_uptime | save -f ~/Scripts/outputs/i3status-uptime-output
