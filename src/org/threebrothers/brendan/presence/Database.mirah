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

import android.content.ContentValues
import android.content.Context

import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteDatabase.CursorFactory
import android.database.sqlite.SQLiteOpenHelper

import java.sql.Time
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.SimpleTimeZone

class Database < SQLiteOpenHelper

  def initialize
    # TODO: better versioning
    
    super Context(PresenceApp.get), 'presence.db', CursorFactory(nil), 1
    @version = 1
  end

  $Override
  def onCreate(db:SQLiteDatabase):void
    onUpgrade db, 0, version
  end

  $Override
  def onUpgrade(db:SQLiteDatabase, old_version:int, new_version:int):void
    # TODO: better migrations
    
    if old_version < 1 && new_version >= 1
      db.execSQL "CREATE TABLE events (
id INTEGER PRIMARY KEY,
what TEXT,
duration INTEGER,
created_at INTEGER
);"
    end
  end

  def record(what:String, duration:long):void
    v = ContentValues.new
    v.put 'what', what
    v.put 'duration', Long.new(duration)
    v.put 'created_at', Long.new(System.currentTimeMillis)
    
    db = getWritableDatabase
    db.insert('events', String(nil), v)
    db.close
  end

  protected
  
  def version:int
    @version
  end
  
end
