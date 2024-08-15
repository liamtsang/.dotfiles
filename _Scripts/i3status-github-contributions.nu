let gh_json = gq https://api.github.com/graphql ...[ 
      -l
      -H 'Authorization: Bearer MY_API_KEY'
      -q 'query($userName:String!) { 
         user(login:$userName) {
           contributionsCollection {
             contributionCalendar {
               totalContributions
               weeks {
                 contributionDays {
                   contributionCount
                   date
                 }
               }
             }
           }
         }
       }' 
      --variablesJSON '{"userName": "liamtsang"}'] | from json

let contribution_list = do -i {$gh_json.data.user.contributionsCollection.contributionCalendar.weeks | last | $in.contributionDays | get contributionCount}
$contribution_list | reduce --fold '' {|it, acc| if $it == 0 {$acc + ◻} else {$acc + ◼} } | save -f ~/Scripts/outputs/i3status-github-contributions-output
# ◻ ◼
