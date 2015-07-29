module Unmix
  class UnmixThor < Thor

    default_task :unmix

    desc "Auto", "Automaticlly analyze and Unmix a given URL"
    long_desc <<-LONGDESC
      Analyze Source url and run unmix
    LONGDESC
    option :source_url,    :aliases => "-i",  :desc => "Source URL", :required => true
    option :skip_download, :aliases => "-ss", :desc => "Assumes source url was already downloaded"

    def unmix
      binding.pry
      app = UnmixApp.new options
      app.run
    end

    desc "doctor", "Script doctor, validate that the script's dependencies exists"
    def doctor
      EXTERNAL_COMMANDS.each do |cmd|
        Unmix::cmd_exist?(cmd.to_s)? puts("#{cmd} was found".green) : puts("#{cmd} was not found".red)
      end
    end

  end  
end