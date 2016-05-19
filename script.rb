require 'watir-webdriver'
require 'csv'
require 'time'
prefs = {
	download: {
		prompt_for_download: false,
		default_directory: "#{Dir.pwd}"
	}
}
browser = Watir::Browser.new(:chrome, prefs: prefs)

browser.goto('http://www.vonage.com/personal')

browser.link(text: "Sign In/My Account").hover
browser.text_field(id: "username").set("dmendell")
browser.text_field(id: "password").set("Portland2828")
browser.button(value: "Sign In").click

if browser.div(id: "IPEThemeBG").exists?
	browser.image(id: "nOff").click
end
browser.div(class: "button close").click
browser.div(id: "linePlan").wait_until_present
browser.link(text: "Recent Calls").click

browser.span(id: "csvPrintLink").click

sleep 2

browser.quit

entries = Dir.entries('.').sort_by { |x| File.mtime(x) }
csv_file = nil
entries.each do |entry|
	if entry.match('callActivity') != nil
		csv_file = entry
	end
end

rows = CSV.read(csv_file, headers: true).collect do |row|
	row.to_hash
end
column_names = ["Name", "Description", "Assigned To", "Created By", "Phone Number", "Call Date Time", "Call Duration", "Call Type", "Created By", "Caller"]
s = CSV.generate do |csv|
	csv << column_names
	rows.each do |row|
		m = Time.parse('00:00')
		time = (Time.parse(row["Length"]).to_i - m.to_i)/60
		values = [row["Date/Time"], "", "1f51d5fe-06e6-e0f8-1724-5591aba2732c", "1f51d5fe-06e6-e0f8-1724-5591aba2732c", row["Number"], row["Date/Time"], time, row["Type"], "1f51d5fe-06e6-e0f8-1724-5591aba2732c", "bc7e0285-b31e-f24a-becf-5575ccb77bce"]
		csv << values
	end
end

File.open(csv_file, 'w') { |file| file.write(s) }