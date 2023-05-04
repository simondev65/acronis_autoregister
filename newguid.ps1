 $file="guid1.txt"
new-guid > $file
(Get-Content $file | Select-Object -Skip 3) | Set-Content $file 
$file="guid2.txt"
new-guid > $file
(Get-Content $file | Select-Object -Skip 3) | Set-Content $file 
