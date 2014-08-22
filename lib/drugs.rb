require 'open-uri'
Bundler.require

class Drugs
	FILE = File.dirname(__FILE__) + '/../data/drugs.json'
	URL = 'http://ja.wikipedia.org/wiki/%E5%8C%BB%E8%96%AC%E5%93%81%E4%B8%80%E8%A6%A7'
	XPATH = '//*[@id="mw-content-text"]/ul/li/ul/li/a[1]'

	def save
		doc = Nokogiri::HTML(open(URL))
		chains = Hash.new {|h, k| h[k] = Array.new }
		originals = doc.css(XPATH).map {|a| a.text }
		originals.each do |original|
			['BOD', original.split(//), 'EOD'].flatten.each_cons(2) do |first, second|
				chains[first] << second unless chains[first].include?(second)
			end
		end
		File.write FILE, JSON.pretty_generate(originals: originals, chains: chains)
	end

	def generate
		json = JSON.parse File.read FILE
		chains = json['chains']
		chars = []
		char = 'BOD'
		until char == 'EOD'
			char = chains[char].sample
			chars << char
		end
		chars[0..-2].join
	end
end
