require 'tempfile'

namespace :copyright do
  desc "Add the copyright mention to the top of the /assets/sublime.js file"
  task :add_to_top do
    text = "
////////////////////////////////////////////////////////////////////
//  Copyright (c) 2010 Jilion / Jime SA                           //
//  ============================================================  //
//  This software cannot be used beyond the purpose of this demo. //
//  Please contact info@jilion.com for any question relating to   //
//  its use in other contexts.                                    //
////////////////////////////////////////////////////////////////////

"
    File.prepend("#{RAILS_ROOT}/public/assets/sublime.js", text)
    puts "Copyright mention has been successfully added."
  end
end

class File
  def self.prepend(path, string)
    Tempfile.open File.basename(path) do |tempfile|
      # prepend data to tempfile
      tempfile << string

      File.open(path, 'r+') do |file|
        # append original data to tempfile
        tempfile << file.read
        # reset file positions
        file.pos = tempfile.pos = 0
        # copy all data back to original file
        file << tempfile.read
      end
    end
  end
end