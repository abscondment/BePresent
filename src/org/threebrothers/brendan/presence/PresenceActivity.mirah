package org.threebrothers.brendan.presence

import android.app.Activity
import android.content.Intent
import android.util.Log

import java.util.ArrayList
import java.util.List
import java.util.Collections

class PresenceActivity < Activity
  def onCreate(state)
    super state
    setContentView R.layout.main
  end

  protected
  
  $Override
  def onStart
    super

    # Show the Chart
    startActivity Chart.new.execute(self)
    
    # Make sure the ScreenService is running.
    startService Intent.new(self, ScreenService.class)
    
    finish
  end
end
