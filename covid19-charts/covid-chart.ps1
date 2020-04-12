# Import common scripts
. ".\charts-lib.ps1"

# Set Script Variables
$outputFolder = "C:\CovidCharts\";
$countryCode = "MK";
$daysToAnalize = 50;

function CreateCovidChart($covidDataSource, $covidDataSourceYAxis, $YAxisName, $backgroundColor, $chartColor, $chartType)
{
    if($backgroundColor -eq $null)
    {
        $backgroundColor = "#FFFFFF"  
    }

    if($chartColor -eq $null)
    {
        $chartColor = "#62B5CC"  
    }

    # create chart object
   $chart = CreateChart -width 2000 -height 1200 -backgroundColor "#FFFFFF"
   # set title
    SetupChartTitle -chart $chart -title ("Covid " + $YAxisName) -font "Arial,14pt" -alignment "topLeft"
   # set chart area 
    $axisYIntervalStep = $null #$covidDataSource | Select-Object $covidDataSourceYAxis | Measure-Object -Maximum
    SetupChartArea -chart $chart -name "CovidChartArea" -axisYTitle $YAxisName -axisXTitle "Date"  -axisXInterval 1 #-axisYInterval 100
   # set legend 
    SetupChartLegend -chart $chart -name "Legend"
   #set serie 
     $datasource = $covidDataSource | Select-Object date, $covidDataSourceYAxis
     AddSerie -chart $chart -serieName $YAxisName -datasource $datasource -datasourceX "date" -datasourceY $covidDataSourceYAxis -color "#62B5CC" -chartType $chartType
   # save the chart
     
     $chart.SaveImage($outputFolder+$countryCode + "-" + $YAxisName+".png","png")
}


$j = Invoke-WebRequest ('https://api.thevirustracker.com/free-api?countryTimeline=' + $countryCode) | ConvertFrom-Json 

$startDate = (Get-Date).AddDays(-$daysToAnalize)
$currentDate = Get-Date
$covidDataArray = @();

# transform API data
for($i = $startDate; $i -lt $currentDate; $i = $i.AddDays(1))
{
    $date = $i.ToString("M/dd/yy")

    foreach($covid19Data in $j.timelineitems) {
        $tmp = $covid19Data.$date;
        if($tmp)
        {
            $tmp | Add-Member NoteProperty "date" $date
        }
        $covidDataArray += $tmp;
    }
}

#create charts
CreateCovidChart -covidDataSource $covidDataArray -covidDataSourceYAxis "new_daily_cases" -YAxisName "Covid Daily Cases" -chartType "Column"
CreateCovidChart -covidDataSource $covidDataArray -covidDataSourceYAxis "total_cases" -YAxisName "Total Cases" -chartType "Column"
CreateCovidChart -covidDataSource $covidDataArray -covidDataSourceYAxis "new_daily_deaths" -YAxisName "Daily Deaths" -chartType "Line"

#create CSV
$covidDataArray | Select-Object | Export-Csv ($outputFolder+$countryCode + "-covid19.csv")

#powershell.exe -executionpolicy bypass -file C:\Users\user\Documents\PowerShell\covid-chart.ps1

