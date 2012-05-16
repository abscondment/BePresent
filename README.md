# Be Present

Definitely a work in progress...

## Building

First, grab the [achartengine jar](http://code.google.com/p/achartengine/downloads/list).

Next, you'll need JRuby with bundler installed. Once you're ready, `bundle install`
will fetch Mirah and Pindah. Then you can install to a device like so:

    bundle exec rake clean debug install
