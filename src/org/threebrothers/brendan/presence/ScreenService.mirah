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
