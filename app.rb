require 'date'
require 'builder'
require 'sinatra'
require './lib/drugs.rb'

helpers do
	def drug
		@drug ||= Drugs.new.generate
	end
end

get '/' do
	haml :'/'
end

get '/json' do
	content_type 'text/json'
	JSON.pretty_generate(drug: drug)	
end

get '/rss' do
	content_type 'application/xml'
	builder :'/rss'
end

__END__
@@ /
!!! 5
%html
	%head
		%title= drug
		%meta{name:"viewport",content:"width=device-width,initial-scale=1.0"}
		%link{rel:'stylesheet',href:'bootstrap.min.css'}
		:css
			.jumbotron { background-color: white }
	%body
		%div.jumbotron
			%a{href:"http://ja.wikipedia.org/wiki/%E5%8C%BB%E8%96%AC%E5%93%81%E4%B8%80%E8%A6%A7"} 医薬品一覧 - Wikipedia
			のマルコフ連鎖
			(
			%a{href:"/json"} JSON
			)
			%a.twitter-share-button.pull-right{"href"=>"https://twitter.com/share"} Tweet
			%hr
			%h1.text-center= drug
			:javascript
				!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');
@@ /rss
xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
	xml.channel do
		xml.title "drugs"
		xml.description "医薬品一覧 - Wikipedia のマルコフ連鎖"
		xml.link "http://drugs.herokuapp.com/"
		xml.item do
			xml.title drug
			xml.link "http://drugs.herokuapp.com/"
			xml.description drug
			xml.pubDate Time.parse Date.today.to_s
			xml.guid Time.parse Date.today.to_s
		end
	end
end
