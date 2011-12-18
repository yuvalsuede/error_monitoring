/**
* Created by IntelliJ IDEA.
* User: yuvals
* Date: 12/13/11
* Time: 11:26 AM
* To change this template use File | Settings | File Templates.
*/
var chart; // globally available
var colors = [
	'#4572A7',
	'#AA4643',
	'#89A54E',
	'#80699B',
	'#3D96AE',
	'#DB843D',
	'#92A8CD',
	'#A47D7C',
	'#B5CA92'
];
$(document).ready(function() {
    var chartOptions = {
        chart: {
            renderTo: 'container',
            defaultSeriesType: 'line',
            zoomType: 'x',
            width: '900',
            height: '500'
        },
        title: {
            text: 'Total JS Errors',
            style: {
                 color: '#0196e3',
                 fontFamily :'Myriad Pro,Arial,Helvetica,sans-serif',
                 fontSize:'16px',
                 fontWeight :'bold'
             }

        },
        xAxis: {
            categories: categories,
            maxZoom:  12, // two hours
            title: {
               text: null
            },
            tickInterval: 12 // display category each 2 hours
        },
        yAxis: {
            title: {
                text: '# Errors',
                style: {
                    color: '#0196e3',
                    fontFamily :'Myriad Pro,Arial,Helvetica,sans-serif',
                    fontSize:'14px',
                    fontWeight :'bold'
                }
            },
            min: 0
        },
        tooltip: {
            formatter: function() {
                var s = '<b>'+ this.x +'</b>';
                $.each(this.points, function(i, point) {
                    s += '<br/>'+
                        '<span style="color:'+ point.series.color + '">' +
                        point.series.name +': '+ point.y + '</span>';
                });

                return s;
            },
            shared: true
        },
          legend: {
              enabled:true,
              borderWidth:0,
              symbolPadding:1,
              margin: 20,
              verticalAlign:'top',
              layout: 'vertical',
              align: 'right',
              floating: true,
              backgroundColor: 'white',
              style: {
                  top:'70px'
              },
              borderWidth:'2'

          },
        plotOptions: {
             line: {
                lineWidth: 1.5,
                marker: {
                   enabled: false,
                   states: {
                      hover: {
                         enabled: true,
                         radius: 5
                      }
                   }
                },
                shadow: false,
                states: {
                   hover: {
                      lineWidth: 3
                   }
                }
             },
             series: {
                cursor: 'pointer',
                point: {
                    events: {
                        click: function() {
                          // showTotalErrors();
                        }
                    }
                }
            }
        },

        series: []

    }

chartOptions.series.push(
        {
           type: 'line',
           name: days[0],
           data: data[0]
        },
        {
           type: 'line',
           name: days[1],
           data: data[1]
        },
        {
           type: 'line',
           name: days[2],
           data: data[2]
        }
)
var showTotalErrors = function () {
    chartOptions.series.push(
                {
            type: 'pie',
            name: 'Total Daily Errors',
            data: [
                {
                    name: days[0],
                    y :totalErrors[0],
                    color: colors[0]
                },
                {
                    name: days[1],
                    y :totalErrors[1],
                    color: colors[1]
                },
                {
                    name: days[2],
                    y :totalErrors[2],
                    color: colors[2]
                }
            ],
             center: [100, 80],
             size: 100,
             showInLegend: false,
             dataLabels: {
                enabled: false
             }
         //   visible: false
        }

    )
    //alert("hi");
    chart = new Highcharts.Chart(chartOptions);
}
chart = new Highcharts.Chart(chartOptions);

});