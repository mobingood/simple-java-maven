## Ruby script

#!/usr/bin/env ruby

require 'etc'

# Configuration
log_dirs = ['/var/log', '/tmp/logs']   # Directories to clean
retention_days = 7                     # Delete logs older than these many days
users_to_create = ['devuser', 'qauser']  # Users to create

# Ensure script runs as root
if Process.uid != 0
  puts "⚠️ Please run this script with sudo or as root."
  exit 1
end

# --- Cleaning log files ---
puts "🧹 Cleaning log files older than #{retention_days} days..."

log_dirs.each do |dir|
  next unless Dir.exist?(dir)

  Dir.glob("#{dir}/**/*.log").each do |file|
    begin
      if File.mtime(file) < (Time.now - retention_days * 24 * 60 * 60)
        File.delete(file)
        puts "Deleted old log file: #{file}"
      end
    rescue => e
      puts "Error deleting #{file}: #{e.message}"
    end
  end
end

puts "✅ Log cleaning completed."

# --- Creating users ---


puts "👤 Creating Linux users..."

users_to_create.each do |username|
  begin
    Etc.getpwnam(username)
    puts "User '#{username}' already exists."
  rescue ArgumentError
    system("sudo useradd #{username}")
    if $?.exitstatus == 0
      puts "Created user: #{username}"
    else
      puts "Failed to create user: #{username}"
    end
  end
end

puts "✅ User creation completed."


# Ask user for the file name to compress
puts "Enter the file name to compress:"
file_name = gets.chomp

# Check if the file exists
if File.exist?(file_name)
  puts "File found: #{file_name}"

  # Create a gzip-compressed version of the file
  compressed_file = "#{file_name}.gz"

  # Run gzip system command to compress
  system("gzip -c #{file_name} > #{compressed_file}")
  puts "File compressed successfully to #{compressed_file}"

  # Create a target storage directory if not exists
  storage_dir = "/tmp/storage"
  Dir.mkdir(storage_dir) unless Dir.exist?(storage_dir)
  puts "Storage directory ready: #{storage_dir}"

  # Move the compressed file to the storage directory
  system("mv #{compressed_file} #{storage_dir}/")
  puts "File transferred to storage: #{storage_dir}/#{File.basename(compressed_file)}"

else
  puts "Error: File not found!"
end

# Package check 

# Ask the user for the package name
puts "Enter the package name to check:"
package = gets.chomp

# Detect the package manager type
if File.exist?("/usr/bin/dpkg")
  # For Debian/Ubuntu systems
  check_cmd = "dpkg -l | grep -w #{package}"
elsif File.exist?("/usr/bin/rpm")
  # For RedHat/CentOS systems
  check_cmd = "rpm -qa | grep -w #{package}"
else
  puts "Unsupported system: No dpkg or rpm found!"
  exit
end

# Run the command and capture output
result = `#{check_cmd}`

# Check if output is empty or not
if result.empty?
  puts "❌ Package '#{package}' is NOT installed."
else
  puts "✅ Package '#{package}' is installed."
end
