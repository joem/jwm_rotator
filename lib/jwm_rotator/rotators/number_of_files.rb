require 'date'
require 'fileutils'

module JwmRotator

  module Rotators

    class NumberOfFiles


      def initialize(relative_file_path, opts = {})
        @timestamp = DateTime.now.strftime("%Y%m%d.%H%M%S")
        @original_file_path = File.expand_path(File.join(opts[:abs_root_path], '..', relative_file_path))
        @new_path = File.expand_path(File.join(opts[:abs_root_path], '..', opts[:relative_backup_path]))
        @new_name = "#{File.basename(relative_file_path)}.#{@timestamp}"
        @new_file_path = File.join(@new_path, @new_name)
        @limit = opts[:limit]
      end


      def rotate
        check_original
        create_backup_path
        check_new
        copy_to_backup
        remove_excess_backups
      end


    private


      # Check if original file exists, and if not, Error out.
      #
      def check_original
        if !File.exist?(@original_file_path)
          #TODO: error properly
          abort
        end
      end


      # Check if the BACKUP_PATH exists, and if not, create it.
      #
      def create_backup_path
        if File.exist?(@new_path)
          if !File.directory?(@new_path)
            #TODO: error properly
            abort
          end
        else
          FileUtils.mkdir_p @new_path
        end
      end


      # Make sure you're not overwriting a file with your cp
      #
      def check_new
        if File.exist?(@new_file_path)
          #TODO: error properly
          abort
        end
      end


      # Copy file to backup_path, appending the date onto the filename
      #
      def copy_to_backup
        FileUtils.cp(@original_file_path, @new_file_path)
      end


      # if too many files (matching the filename) in backup dir
      #   delete (or archive) extra files
      #
      def remove_excess_backups
        glob_path = File.join(@new_path, "#{File.basename(@original_file_path)}*")

        backups = Dir.glob(glob_path).sort_by do |f|
          File.mtime(f)
        end

        if @limit > 0
          if backups.length > @limit
            #FileUtils.rm backups[0..(backups.length - (limit + 1))]  # Same thing.
            backups[0..(backups.length - (@limit + 1))].each do |extra_file|
              FileUtils.rm extra_file
            end
          end
        end
      end


      # Goal: Get rid of the oldest files over the max number of files.
      #
      #
      # Example 1 (not at the limit yet):
      #   Assume :limit is 3
      #   Assume files in :backup_path dir are:
      #     some_file.txt.2013-04-27
      #     some_file.txt.2013-05-12
      #   Assume today is 2013-06-01
      #
      #   We rotate today's some_file.txt into the mix.
      #
      #   The files in the :backup_path dir now are:
      #     some_file.txt.2013-04-27
      #     some_file.txt.2013-05-12
      #     some_file.txt.2013-06-01
      #
      #   Result: Today's some_file.txt was copied into :backup_path and the
      #   date was appended to the file name. No files were removed, since it
      #   was not at the limit yet.
      #
      #
      #
      # Example 2 (at the limit):
      #   Assume :limit is 3
      #   Assume files in :backup_path dir are:
      #     some_file.txt.2013-04-27
      #     some_file.txt.2013-05-12
      #     some_file.txt.2013-06-01
      #   Assume today is 2013-08-19
      #
      #   We rotate today's some_file.txt into the mix.
      #
      #   The files in the :backup_path dir now are:
      #     some_file.txt.2013-05-12
      #     some_file.txt.2013-06-01
      #     some_file.txt.2013-08-19
      #
      #   Result: Today's some_file.txt was copied into :backup_path and the
      #   date was appended to the file name.  The limit was reached, so
      #   some_file.txt.2013-04-27 was removed since it was the oldest. No
      #   other files were removed, since that brought the number of files down
      #   to the :limit.
      #


    end

  end

end
