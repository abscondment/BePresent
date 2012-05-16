# Copyright 2012 Brendan Ribera
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    miny = maxx
    
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
        miny = y if y < miny

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

    setChartSettings(renderer, "In the last 6 hours...", String(nil), "Duration", minx - x_fudge, maxx + x_fudge, 0, maxy, Color.LTGRAY, Color.LTGRAY)
    
    renderer.setXLabels(0)
    interval = long(float((maxx - minx) + 2 * x_fudge) / 9.0)
    9.times do |i|
      at_x = minx + (interval * i)
      renderer.addXTextLabel at_x, timestamp_to_time(at_x)
    end
    
    renderer.setYLabels(0)
    interval = long(float(maxy - miny) / 6.0)
    6.times do |i|
      at_y = miny + (interval * i)
      renderer.addYTextLabel at_y, duration_in_words(at_y)
    end

    renderer.setShowGrid(true)
    renderer.setXLabelsAlign(Align.RIGHT)
    renderer.setYLabelsAlign(Align.RIGHT)
    renderer.setZoomButtonsVisible(false)
    
    limits = double[4]
    limits[0] = 0
    limits[1] = 0
    limits[2] = 0
    limits[3] = 0
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
    renderer.setChartTitle(title) unless title.nil?
    renderer.setXTitle(xTitle) unless xTitle.nil?
    renderer.setYTitle(yTitle) unless yTitle.nil?
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
    margins[1] = 70
    margins[2] = 20
    margins[3] = 10
    renderer.setMargins margins
    
    length = colors.length
    length.times do |i|
      r = XYSeriesRenderer.new
      r.setColor colors[i]
      r.setPointStyle styles[i]
      renderer.addSeriesRenderer r
    end
  end

  def timestamp_to_time(time:long)
    df = SimpleDateFormat.new("h:mm")
    df.setCalendar Calendar.getInstance(SimpleTimeZone.getDefault)
    df.format Date.new(time)
  end

  def duration_in_words(duration:long)
    if duration < 120_000
      seconds_duration = duration / 1_000
      return "#{seconds_duration}s"
    elsif duration < 3_600_000
      minute_duration = duration / 60_000
      return "#{minute_duration}m"
    elsif duration < 86_400_000
      hour_duration = duration / 3_600_000
      return "#{hour_duration}h"
    elsif duration < 2_629_743_000
      day_duration = duration / 86_400_000
      return "#{day_duration}d"
    else
      month_duration = duration / 2_629_743_000
      return "#{month_duration} months"
    end
    return 'never'
  end
end
