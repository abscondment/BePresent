# Be Present

How distracting is your smartphone? Make it keep track and find out.

Definitely a work in progress...

## Building

### Prerequisites

 * You'll need to have
   [the Android SDK](http://developer.android.com/sdk/index.html)
   installed on your machine.
 * You need [JRuby](http://jruby.org/) 1.6+, which can be installed easily using [rbenv](https://github.com/sstephenson/rbenv#section_2) or [RVM](https://rvm.io/rvm/install/).

### Build it!
   
 1. Modify `local.properties.example` to point to your Android SDK.
 2. Grab the
    [achartengine jar](http://code.google.com/p/achartengine/downloads/list)
    and stick it in `libs`.
 3. `bundle install` to grab the dependencies (Mirah, Pindah, and rake).
 4. Build and install to a device like so:
    
         bundle exec rake clean debug install

## Notices

[Skull drawing](http://www.fotopedia.com/items/flickr-3561191040) used
via a [CC BY 2.0 license](http://creativecommons.org/licenses/by/2.0/).
