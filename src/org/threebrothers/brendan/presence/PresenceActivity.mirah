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
    
    # Make sure the ScreenService is running.
    startService Intent.new(self, ScreenService.class)
  end

  $Override
  def onResume
    super

    @events = PresenceApp.getPreferences.getAll 
    # get keys in the correct order
    @keys = ArrayList.new @events.keySet
    # NB: sorts in place
    Collections.sort(@keys)
    
    events = @events # scoping
    @keys.each do |k|
      Log.d "PresenceActivity", "#{k} => #{events.get k}"
    end
  end
end
