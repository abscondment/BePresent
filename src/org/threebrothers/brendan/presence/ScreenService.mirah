package org.threebrothers.brendan.presence

import android.app.Service
import android.content.Intent
import android.content.IntentFilter
import android.util.Log

class ScreenService < Service
  
  $Override
  def onCreate:void
    super

    filter = IntentFilter.new

    # For some reason, we can't register for these Broadcasts
    # from within AndroidManifest.xml; so, we do them from within
    # a service.
    filter.addAction Intent.ACTION_SCREEN_ON
    filter.addAction Intent.ACTION_SCREEN_OFF
    
    @receiver = PresenceReceiver.new
    registerReceiver @receiver, filter
  end

  $Override
  def onStartCommand(intent:Intent, flags:int, start_id:int):int
    # We want this service to be sticky.
    Service.START_STICKY
  end

  $Override
  def onDestroy
    super
    
    # Clean up our receiver.
    unregisterReceiver @receiver
  end

  protected
  def onHandleIntent(intent:Intent):void
    # no-op
  end
end
