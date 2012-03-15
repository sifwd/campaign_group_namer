# kw/group limits to use
max_keywords_per_group = 1000
max_groups_per_campaign = 50

keyword_num = 1;
group_num = 1;

infile_name = ARGV.shift
outfile_name = ARGV.shift
# read campaign prefix
puts "Enter Campaign Name Prefix (e.g. IT010-):"
campaign_prefix = gets.chomp # chomp newline

# read starting number
puts "Choose starting campaign number (default 1):"
campaign_start_number = gets.chomp.to_i
campaign_start_number = (campaign_start_number == 0) ? 1 : campaign_start_number #default 1
campaign_num = campaign_start_number;

puts "Enter any extra data to append to every row (e.g. max cpc)"
extras = gets.chomp
extras = extras.length == 0 ? "" : "\t" + extras

# (try to) open file
begin
  infile = File.new(infile_name, "r")
  outfile = File.new(outfile_name, "w")
rescue => err
  puts "Uh oh! #{err}" 
end

current_campaign = "#{campaign_prefix}"+ ("%02d" % campaign_start_number)
current_group = current_campaign + "_" + ("%05d" % keyword_num) + "-" + ("%05d" % (keyword_num + max_keywords_per_group - 1))

while (line = infile.gets)
# new group
  if 
    (keyword_num % max_keywords_per_group == 1 && keyword_num > 1) 
  then 
    current_group =  "#{campaign_prefix}" + ("%02d" % campaign_num) + "_" + ("%05d" % keyword_num) + "-" + ("%05d" % (keyword_num + max_keywords_per_group - 1))
    group_num = group_num + 1
  end
# new campaign
  if
     (keyword_num % max_keywords_per_group == 1 && keyword_num > 1 && group_num % max_groups_per_campaign == 1 && group_num > 1) 
  then
      keyword_num = 1
      campaign_num = campaign_num + 1
      current_campaign =  "#{campaign_prefix}" + ("%02d" % campaign_num)
      current_group =  "#{campaign_prefix}" + ("%02d" % campaign_num) + "_" + ("%05d" % keyword_num) + "-" + ("%05d" % (keyword_num + max_keywords_per_group - 1))      
  end
  outfile.puts line.chomp + "\t#{current_campaign}\t#{current_group}#{extras}" # + "KW num:#{keyword_num}"
  keyword_num = keyword_num + 1
end

outfile.close
