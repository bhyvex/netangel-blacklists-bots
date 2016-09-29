require 'resolv'
$stdout.sync = true

domains_filename = ARGV[0]
cleaned_filename = "#{domains_filename}-cleaned"
removed_filename = "#{domains_filename}-removed"

File.open( cleaned_filename, 'w' ) do |cleaned_file|
  File.open( removed_filename, 'w' ) do |removed_file|
    File.foreach( domains_filename ) do |line|
      domain = line.strip
      begin
        print Resolv.getaddress( domain )
        print "\t\s"
      rescue
        removed_file << "#{domain}\n"
        print "---.---.---.---\t\s"
        print "REMOVED\t\s"
        puts domain
        next
      end
      cleaned_file << "#{domain}\n"
      print "VALID\s\s\t\s"
      puts domain
    end
  end
end
