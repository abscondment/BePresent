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
created_at DATE
);"
    end
  end

  def record(what:String, duration:long):void
    v = ContentValues.new
    v.put 'what', what
    v.put 'duration', Long.new(duration)
    v.put 'created_at', generate_created_at
    
    db = getWritableDatabase
    db.insert('events', String(nil), v)
    db.close
  end

  protected
  
  def version:int
    @version
  end

  def generate_created_at:String
    cal = Calendar.getInstance(SimpleTimeZone.new 0, "GMT")
    df = SimpleDateFormat.new("yyyy-MM-dd'T'HH:mm:ss'Z'")
    df.setCalendar cal
    df.format(cal.getTime)
  end
  
end
