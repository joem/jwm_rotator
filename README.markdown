JwmRotator
==========
Rotate backup files based on certain criteria.


Manual
------
First, I want to be clear: If you're on a unix-like system, you should probably use `logrotate` instead. It's good unix-y software that was designed for this type of thing by people much wiser than me, and it's either pre-installed or readily available. The only thing it's not really available for is Windows, which is what I was using when I wrote this. I suppose if you want a pure Ruby file rotator, that's the other time this is a good choice.

Unlike many log rotators, these rotators only consider external features, like age and size of the file. This means it works just fine with any file type, even binaries. (That said, you could easily add your own rotator that does parse the file contents, if you so choose.)

Arguments:
- **path** _(String)_  
  The path to the file to be backed-up/rotated, including the filename itself
- **options_hash** (Hash)  
  An optional hash containing the options. If no hash is specified, default values are used for all options.

Here's a brief example of the usage:

```ruby
require_relative 'lib/jwm_rotator'

options_hash = {
  rotator: 'NumberOfFiles',
  backup_path: 'my_backup_dir/',
  limit: 3,
}

JwmRotator.rotate('some_file.txt', options_hash)
```

This example uses the NumberOfFiles rotation method that only allows a certain number of backups and discards older ones to make room for newer ones. That certain number of files is set with `limit` so in this case it's 3.


Rotators
--------

There are a few rotators that come with this, and I hope to add more. You can add your own by adding a class to the `Rotators` module inside the `JwmRotator` module, so that it's named like so: `JwmRotator::Rotators::YourOwnCustomRotatorName`. (Rotators must accept two arguments, a path and a hash, and they must respond to `#rotate`, but other than that, the rotator can do whatever it wants.)


### JwmRotator::Rotators::NumberOfFiles

This method discards files when the total amount of backups is over a certain limit. It's options are:

- **backup_path** _(String, default: '.')_  
  The path to put the backups

- **limit** _(Integer >= 0, default: 1)_  
  The number of backups to keep


### JwmRotator::Rotators::Age

(Not implemented yet.) This method discards files that are older than a certain relative age (1 day, 3 weeks, 2 months, etc).


### JwmRotator::Rotators::Size

(Not implemented yet.) This method discards files once the sum size of the backups surpasses a certain size. The oldest files are discarded until the sum size comes under the limit.


Dependencies
------------

None. It's just ruby core and ruby stdlib!


History
-------
When I originally started this, I knew of nothing quite like it so it was written from scratch. But over time it became heavily based on https://github.com/rubymaniac/rotator, which, if I had known about from the beginning, I probably could have forked. I don't need the S3 uploading that rubymaniac/rotator seems to be centered around so it does not appear in my version (nor does the whole 'uploader' concept), but it should be possible to add something like that as one of the rotators.



