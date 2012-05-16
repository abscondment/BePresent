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
