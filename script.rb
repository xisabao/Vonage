require 'watir-webdriver'
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