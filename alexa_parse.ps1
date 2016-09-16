$fileSites = $null
Write-Host 'Укажите файл со списком сайтов, которые нужно проанализировать'
Write-Host 'Значение по-умолчанию:'"$HOME\Desktop\sites.txt" 
$fileSites = Read-Host 'Введите путь к файлу'
$isfile = Test-Path $fileSites
if ($fileSites -ne "") {
    If ($isfile -ne "True") {
        $fileSites = "$HOME\Desktop\sites.txt"
        Write-Host 'Что-то пошло не так. Будем работать с файлом :'"$HOME\Desktop\sites.txt" 
    }
    else {
        Write-Host 'Отлично! Будем работать с файлом :' $fileSites
    }
}
else {
    $fileSites = "$HOME\Desktop\sites.txt"
    Write-Host 'Что-то пошло не так. Будем работать с файлом :'"$HOME\Desktop\sites.txt" 
}
$fileResult = "$HOME\Desktop\data.txt"
$fullInfo = "$HOME\Desktop\FullInfo.csv"
$i = 0
$сounterSites = (Get-Content $fileSites).Length
Write-Host 'Получение данных...'
do 
    {
    $siteName = (Get-Content $fileSites)[$i]
    $URI = “http://www.alexa.com/siteinfo/$siteName“
    $HTML = Invoke-WebRequest -Uri $URI 
    ($HTML.ParsedHtml.getElementsByTagName(‘strong’) | Where{ $_.className -eq ‘metrics-data align-vmiddle’}|Where{ $_.uniqueID -eq ‘ms__id3’}).innerTEXT | add-content $fileResult
    $i = $i+1
    }
While ($i -le $сounterSites)

$i = 0
Write-Host 'Обработка данных...'
do 
    {
    $siteName = (Get-Content $fileSites)[$i]
    $siteResult = (Get-Content $fileResult)[$i]
    Add-Content $fullInfo -Value $siteName, ";", $siteResult -NoNewline
    Add-Content $fullInfo -Value ""
    $i = $i+1
    }
While ($i -lt $сounterSites)
Write-Host 'Готово!'