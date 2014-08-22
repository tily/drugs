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

__END__
@@ /
!!! 5
%html
	%head
		%title= drug
		%link{rel:'stylesheet',href:'bootstrap.min.css'}
		:css
			.jumbotron { background-color: white }
			* { color: red }
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

