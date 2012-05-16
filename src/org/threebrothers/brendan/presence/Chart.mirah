package org.threebrothers.brendan.presence

import java.text.DateFormat
import java.text.SimpleDateFormat

import java.util.ArrayList
import java.util.Calendar
import java.util.Date
import java.util.List
import java.util.SimpleTimeZone

import org.achartengine.ChartFactory
import org.achartengine.chart.PointStyle
import org.achartengine.renderer.XYMultipleSeriesRenderer
import org.achartengine.renderer.XYSeriesRenderer
import org.achartengine.model.XYMultipleSeriesDataset
import org.achartengine.model.XYSeries

import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Paint.Align
import android.util.Log


class Chart
  def execute(context:Context):Intent
    titles = String[2]
    titles[0] = 'User Present'
    titles[1] = 'Screen On'

    dataset = XYMultipleSeriesDataset.new

    x_fudge = long(1000 * 60 * 5)
    maxx = System.currentTimeMillis
    minx = maxx
    maxy = long(-1)
    
    db = PresenceApp.database.getReadableDatabase
    length = titles.length
    length.times do |i|
      series = XYSeries.new(titles[i], 0)
      
      args = String[2]
      if i == 0
        args[0] = 'USER_PRESENT'
      elsif i == 1
        args[0] = 'SCREEN_ON'
      end
      
      # 6 hours ago
      args[1] = "#{maxx - long(1000 * 60 * 60 * 6)}"
      
      results = db.rawQuery "SELECT created_at, duration FROM events WHERE what = ? AND created_at >= ?;", args
      results.moveToFirst
      ci = results.getColumnIndexOrThrow 'created_at'
      di = results.getColumnIndexOrThrow 'duration'

      scale = 1000.0 * 60.0 * 5.0
      while (!results.isAfterLast)
        x = results.getLong(ci)
        minx = x if x < minx
        
        y = results.getLong(di)
        maxy = y if y > maxy

        Log.d 'Chart', " -> (#{x}, #{y})"
        
        series.add(x, y)
        results.moveToNext
      end
      results.close
      
      dataset.addSeries(series)
    end

    db.close

    colors = int[2]
    colors[0] = Color.GREEN
    colors[1] = Color.BLUE
    # colors[2] = Color.CYAN
    # colors[3] = Color.YELLOW
    
    styles = PointStyle[2]
    styles[0] = PointStyle.CIRCLE
    styles[1] = PointStyle.DIAMOND
    # styles[2] = PointStyle.TRIANGLE
    # styles[3] = PointStyle.SQUARE
    
    renderer = buildRenderer(colors, styles)
    
    length = renderer.getSeriesRendererCount
    length.times do |i|
      XYSeriesRenderer(renderer.getSeriesRendererAt i).setFillPoints true
    end

    setChartSettings(renderer, "Recent Usage", "Time", "Use", minx - x_fudge, maxx + x_fudge, 0, maxy, Color.LTGRAY, Color.LTGRAY)
    
    renderer.setXLabels(12)
    renderer.setYLabels(10)
    renderer.setShowGrid(true)
    renderer.setXLabelsAlign(Align.RIGHT)
    renderer.setYLabelsAlign(Align.RIGHT)
    renderer.setZoomButtonsVisible(true)

    limits = double[4]
    limits[0] = -10
    limits[1] = maxx + 20
    limits[2] = -10
    limits[3] = maxy + 20
    renderer.setPanLimits limits
    renderer.setZoomLimits limits    
    
    ChartFactory.getCubicLineChartIntent(context, dataset, renderer, float(0.33), "Usage")
  end
  
  protected

  def buildRenderer(colors:int[], styles:PointStyle[]):XYMultipleSeriesRenderer
    renderer = XYMultipleSeriesRenderer.new
    setRenderer(renderer, colors, styles)
    renderer
  end
  
  def setChartSettings(renderer:XYMultipleSeriesRenderer, title:String, xTitle:String, yTitle:String, xMin:double, xMax:double, yMin:double, yMax:double, axesColor:int, labelsColor:int):void
    renderer.setChartTitle(title)
    renderer.setXTitle(xTitle)
    renderer.setYTitle(yTitle)
    renderer.setXAxisMin(xMin)
    renderer.setXAxisMax(xMax)
    renderer.setYAxisMin(yMin)
    renderer.setYAxisMax(yMax)
    renderer.setAxesColor(axesColor)
    renderer.setLabelsColor(labelsColor)
  end

  def setRenderer(renderer:XYMultipleSeriesRenderer, colors:int[], styles:PointStyle[]):void
    renderer.setAxisTitleTextSize(16)
    renderer.setChartTitleTextSize(20)
    renderer.setLabelsTextSize(15)
    renderer.setLegendTextSize(15)
    renderer.setPointSize float(5)
    margins = int[4]
    margins[0] = 20
    margins[1] = 30
    margins[2] = 15
    margins[3] = 20
    renderer.setMargins margins
    
    length = colors.length
    length.times do |i|
      r = XYSeriesRenderer.new
      r.setColor colors[i]
      r.setPointStyle styles[i]
      renderer.addSeriesRenderer r
    end
  end
  
  def date_format:DateFormat
    format = SimpleDateFormat.new("yyyy-MM-dd'T'HH:mm:ss'Z'")
    format.setCalendar Calendar.getInstance(SimpleTimeZone.new 0, "GMT")
    format
  end
end
