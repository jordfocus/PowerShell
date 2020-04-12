[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

function CreateChart($width, $height, $backgroundColor)
{
   $chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
   $chart.Width = $width
   $chart.Height = $height
   $chart.BackColor = $backgroundColor

   return $chart
}

function AddSerie($chart, $serieName, $datasource, $datasourceX, $datasourceY, $color, $chartType)
{
    if($chartType -eq $null)
    {
        $chartType = "Column"  
    }

    [void]$chart.Series.Add($serieName)
   $chart.Series[$serieName].ChartType = $chartType #https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.datavisualization.charting.seriescharttype?view=netframework-4.8
   $chart.Series[$serieName].BorderWidth  = 3
   $chart.Series[$serieName].IsVisibleInLegend = $true
   # $chart.Series[$serieName].chartarea = "ChartArea1"
   # $chart.Series[$serieName].Legend = "Legend1"
   $chart.Series[$serieName].color = $color
   $datasource | ForEach-Object {$chart.Series[$serieName].Points.addxy( $_.$datasourceX , $_.$datasourceY) }   
}

function SetupChartTitle($chart, $title, $font, $alignment)
{
   [void]$chart.Titles.Add($title)
   $chart.Titles[0].Font = $font
   $chart.Titles[0].Alignment = $alignment
}

function SetupChartArea($chart, $name, $axisXTitle, $axisYTitle, $axisXInterval, $axisYInterval)
{
   $chartarea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
   $chartarea.Name = $name
   $chartarea.AxisY.Title = $axisYTitle
   $chartarea.AxisX.Title = $axisXTitle
   $chartarea.AxisY.Interval = $axisYInterval
   $chartarea.AxisX.Interval = $axisXInterval
   $chart.ChartAreas.Add($chartarea)
  
}

function SetupChartLegend($chart, $name)
{
   $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
   $legend.name = $name
   $chart.Legends.Add($legend)
}


