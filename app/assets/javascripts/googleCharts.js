
$(document).ready( function() {

      google.setOnLoadCallback(drawChart);

      function drawChart() {

      	var documentData = JSON.parse(document.getElementById("anal_chart").dataset.chart)
        // Create the data table.
        var data = google.visualization.arrayToDataTable(documentData);
        // Set chart options
        var options = {
	        width: 600,
	        height: 400,
	        legend: { position: 'top', maxLines: 3 },
	        bar: { groupWidth: '75%' },
	        isStacked: true,
          vAxis: {minValue: 0}
	      };

        var chart = new google.visualization.ColumnChart(document.getElementById("anal_chart"));
      	chart.draw(data, options);
      }
});