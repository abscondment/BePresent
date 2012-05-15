package org.threebrothers.brendan.presence

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import android.util.Log

class PresenceReceiver < BroadcastReceiver

  $Override
  def onReceive(context:Context, intent:Intent):void
    # Here is where we receive/record all Broadcasts.
    PresenceApp.record intent
    
    # Make sure the ScreenService is running.
    context.startService Intent.new(context, ScreenService.class)
  end
end
