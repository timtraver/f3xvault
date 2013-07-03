twitter_feed = {
	user: 'iEnabled',
	numTweets: 2,
	appendTo: '#twitter-feed',

	// core function of jqtweet
	loadTweets: function() {
		$.ajax({
			url: 'http://api.twitter.com/1/statuses/user_timeline.json/',
			type: 'GET',
			dataType: 'jsonp',
			data: {
				screen_name: twitter_feed.user,
				include_rts: true,
				count: twitter_feed.numTweets,
				include_entities: true
			},
			success: function(data, textStatus, xhr) {

			 var html = '<div class="tweet"><p class="tweet-item">TWEET_TEXT<br/></p><div class="time">AGO</div>';
			//<em class="pre-time">Posted about</em>
				 // append tweets into page
				 for (var i = 0; i < data.length; i++) {
					$(twitter_feed.appendTo).append(
						html.replace('TWEET_TEXT', twitter_feed.ify.clean(data[i].text))
							.replace(/USER/g, data[i].user.screen_name)
							.replace('AGO', twitter_feed.timeAgo(data[i].created_at))
							.replace(/ID/g, data[i].id_str)
					);

				 }					
			}	

		});
		
	}, 

    timeAgo: function(dateString) {
		var rightNow = new Date();
		var then = new Date(dateString);	
		if ($.browser.msie) {	then = Date.parse(dateString.replace(/( \+)/, ' UTC$1'));	}
		var diff = rightNow - then;
		var second = 1000,
		minute = second * 60,
		hour = minute * 60,
		day = hour * 24,
		week = day * 7;

		if (isNaN(diff) || diff < 0) {				return ""; 		}
		if (diff < second * 2) {					return "just posted";		}
		if (diff < minute) {						return Math.floor(diff / second) + " seconds ago";}
		if (diff < minute * 2) {					return "about 1 minute ago";	}
		if (diff < hour) {							return Math.floor(diff / minute) + " minutes ago";	}
		if (diff < hour * 2) {						return "about 1 hour ago";		}
		if (diff < day) {							return  Math.floor(diff / hour) + " hours ago";		}
		if (diff > day && diff < day * 2) {			return "yesterday";		}
		if (diff < day * 365) {						return Math.floor(diff / day) + " days ago";	}
		else {
			return "over a year ago";
		}
	}, 
    
    ify:  {
      link: function(tweet) {
        	return tweet.replace(/\b(((https*\:\/\/)|www\.)[^\"\']+?)(([!?,.\)]+)?(\s|$))/g, function(link, m1, m2, m3, m4) {
          	var http = m2.match(/w/) ? 'http://' : '';
          	return '<a class="twtr-hyperlink" target="_blank" href="' + http + m1 + '">' + ((m1.length > 25) ? m1.substr(0, 24) + '...' : m1) + '</a>' + m4;
        });
      },

      at: function(tweet) {
        	return tweet.replace(/\B[@＠]([a-zA-Z0-9_]{1,20})/g, function(m, username) {
          	return '<a target="_blank" class="twtr-atreply" href="http://twitter.com/intent/user?screen_name=' + username + '">@' + username + '</a>';
        });
      },

      list: function(tweet) {
        	return tweet.replace(/\B[@＠]([a-zA-Z0-9_]{1,20}\/\w+)/g, function(m, userlist) {
          	return '<a target="_blank" class="twtr-atreply" href="http://twitter.com/' + userlist + '">@' + userlist + '</a>';
        });
      },

      hash: function(tweet) {
        	return tweet.replace(/(^|\s+)#(\w+)/gi, function(m, before, hash) {
          	return before + '<a target="_blank" class="twtr-hashtag" href="http://twitter.com/search?q=%23' + hash + '">#' + hash + '</a>';
        });
      },

      clean: function(tweet) {
        	return this.hash(this.at(this.list(this.link(tweet))));
      }
    } 

	
};



$(document).ready(function () {
	twitter_feed.loadTweets();
});
