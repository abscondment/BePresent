package org.threebrothers.brendan.presence

import android.app.Application
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.Toast

import android.util.Log

import java.io.File
import java.util.ArrayList

class PresenceApp < Application
  class << self
    def get; @@instance; end
    
    def record(intent:Intent):void
      action = intent.getAction
      time = System.currentTimeMillis

      if action.equals(Intent.ACTION_USER_PRESENT) || action.equals(Intent.ACTION_SCREEN_ON)
        # Store this as last time the this action happened
        getPreferences.edit.putLong(action, time).apply
        Log.d 'PresenceApp', "STORED -> #{action} @ #{time}"
        
      elsif action.equals(Intent.ACTION_SCREEN_OFF)
        prefs = getPreferences

        on_duration = time - prefs.getLong(Intent.ACTION_SCREEN_ON, time)
        present_duration = time - prefs.getLong(Intent.ACTION_USER_PRESENT, time)

        @@database.record('SCREEN_ON', on_duration) if on_duration > 0
        @@database.record('USER_PRESENT', present_duration) if present_duration > 0

        # reset watermarks
        prefs.edit.clear.apply

        Log.d 'PresenceApp', "SCREEN_OFF:"
        Log.d 'PresenceApp', " -> SCREEN_ON for #{on_duration}"
        Log.d 'PresenceApp', " -> USER_PRESENT for #{present_duration}"
      end
    end

    def getPreferences:SharedPreferences
      @@instance.getSharedPreferences("Presence", Context.MODE_PRIVATE)
    end
  end

  $Override
  def onCreate:void
    super
    @@instance = self
    @@database = Database.new
  end
end
