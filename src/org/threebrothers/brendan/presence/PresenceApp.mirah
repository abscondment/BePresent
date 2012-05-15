package org.threebrothers.brendan.presence

import android.app.Application
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.Toast

import android.util.Log

import java.util.ArrayList

class PresenceApp < Application
  class << self
    def record(intent:Intent):void
      a = intent.getAction
      if a.equals(Intent.ACTION_SCREEN_ON) || a.equals(Intent.ACTION_SCREEN_OFF) || a.equals(Intent.ACTION_USER_PRESENT)
        t = "#{System.currentTimeMillis}"
        Log.d 'PresenceApp', "#{t} => #{a}"
        
        editor = getPreferences.edit
        editor.putString(t, a)
        editor.commit
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
  end
end
