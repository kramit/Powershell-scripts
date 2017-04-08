#function get-bbcnews {$bbc = invoke-restmethod -method get "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=7679045016094e248c1bb713ce2d03e2"
#$bbcoutput = $bbc.articles | Select title, description, publishedat
#Write-Output $bbcoutput }


function get-allsyria {
    $allnewssources = invoke-restmethod -method get "https://newsapi.org/v1/sources?language=en&apiKey=7679045016094e248c1bb713ce2d03e2"
    $a =  New-Object System.Collections.Generic.List[System.Object]
    foreach ($source in $allnewssources.sources.id) {
        if ($source -notlike '*the-next-web*') {
            $sourceget = invoke-restmethod -method get "https://newsapi.org/v1/articles?source=$source&sortBy=top&apiKey=7679045016094e248c1bb713ce2d03e2"
            foreach ($item in $sourceget.articles.title) {
                if ($item -like '*Syria*') {
                    $title = New-Object -TypeName psobject -Property @{'title' = $item}

                    $a.Add($title)
                }
            }
        }
    }
    $a
}

(get-allsyria).count







#foreach ($line in (get-bbcnews).title ) {
#
#if ($line -like '*Syria*') {
#Write-Host $line -ForegroundColor Magenta
#}

#}  