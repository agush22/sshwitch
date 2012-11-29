#!/usr/bin/env ruby
require 'fileutils'
require 'optparse'

include FileUtils

HOME_PATH = File.expand_path('~')+'/'
SSH_PATH = HOME_PATH + '.ssh/'
SWITCH_FILE = SSH_PATH+'.sshwitch'

def get_current
  begin
    File.open(SWITCH_FILE).first
  rescue
    File.new(SWITCH_FILE, 'w')
    nil
  end
end

def list
  begin
    Dir[SSH_PATH+'*/'].map { |a| File.basename(a) }
  end
end

def switch(name)
  if File.readable?(SSH_PATH+name+"/id_rsa") && File.readable?(SSH_PATH+name+"/id_rsa.pub")
    begin
      cp(SSH_PATH+name+"/id_rsa", SSH_PATH+"id_rsa", :verbose => true)
      cp(SSH_PATH+name+"/id_rsa.pub", SSH_PATH+"id_rsa.pub", :verbose => true)
      File.open(SWITCH_FILE, 'w') {|f| f.write(name) }
      puts "Changed key pair to: " + name
    rescue => e
      puts "Could not copy, check if you have permission to write on #{SSH_PATH}"
      puts e.message
    end
  else
    puts "Could not read key pair in #{SSH_PATH+name}"
    puts "Check if key pair exists in #{SSH_PATH+name}\n\n"
    puts "If not you can create a new one with: \"sshwitch -n #{name}\""
    puts "Or backup the current key pair in #{SSH_PATH} with: \"sshwitch -b #{name}\""
  end
end

def new(name)

end

options = {}

option_parser = OptionParser.new do |opts|
  exec_name = File.split($0)[1]
  opts.banner = "Switch and manage key pairs in #{SSH_PATH} \n\n"
  opts.banner += "Default usage: #{exec_name} key_pair_name \n\n"
  opts.banner += "Advanced usage: #{exec_name} [option]\n"

  opts.on("-c", "--current", "Get name of current key pair") do
    options[:current] = true
  end

  opts.on("-n NEW", "--new", "New key pair name") do |new|
    options[:new] = new
  end

  opts.on("-b BACKUP", "--backup", "Backup key pair in #{SSH_PATH}") do |backup|
    options[:backup] = backup
  end

  opts.on("-r OLDNAME,NEWNAME", "--rename", Array, "Rename a key pair") do |rename_names|
    if rename_names.count == 2
      puts "replace #{rename_names[0]} with #{rename_names[1]}"
      options[:oldname] = rename_names[0]
      options[:newname] = rename_names[1]
    else
      puts "Wrong number of arguments for Rename (#{rename_names.count} for 2)"
    end
  end

  opts.on("-l", "--list", "Get list of key pairs in #{SSH_PATH} \n\n") do
    options[:list] = true
  end

end.parse!

#If no options use default behavior switch()
if options.empty? && ARGV.count > 0
  name = ARGV.shift
  if get_current.nil?
    puts "WARNING! This will overwrite the key pair in #{SSH_PATH}, press Y to confirm"
    if (gets.chr.upcase == 'Y')
      switch(name)
    end
  elsif get_current == name
    puts "#{name} is the current key pair"
  else
    switch(name)
  end
elsif options[:list]
  puts list
end
