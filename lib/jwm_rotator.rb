require_relative 'jwm_rotator/version'
require_relative 'jwm_rotator/rotators/age'
require_relative 'jwm_rotator/rotators/number_of_files'
require_relative 'jwm_rotator/rotators/size'

#
# Here's a brief example of the usage:
#
#
#     require_relative 'lib/jwm_rotator'
#
#     options_hash = {
#       rotator: 'NumberOfFiles',
#       relative_backup_path: 'backups2/',
#       limit: 3,
#       abs_root_path: File.expand_path(__FILE__),
#     }
#
#     JwmRotator.rotate('magento.csv', options_hash)
#


module JwmRotator

  # A shortcut/wrapper/something to make a class based on the options.
  # It's a little roundabout, but it allows for other kinds of classes,
  # and they can be changed with just a config option, instead of hardcoded.
  #
  def self.rotate(path, opts)
    rotator = opts[:rotator]
    rotator = "JwmRotator::Rotators::" + rotator
    #rotator.constantize.new(path, opts).rotate        # for String#constantize
    self.constantize(rotator).new(path, opts).rotate  # for JwmRotator::constantize
  end


  # Essentially, the same thing as ActiveSupport's String#constantize
  #
  def self.constantize(str)
    str.split("::").inject(Module) {|acc, val| acc.const_get(val)}
  end

end


## Just in case you end up wanting to use this instead:
#
#     # String#constantize
#     class String
#       def constantize
#         self.split("::").inject(Module) {|acc, val| acc.const_get(val)}
#       end
#     end

