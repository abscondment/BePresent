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
