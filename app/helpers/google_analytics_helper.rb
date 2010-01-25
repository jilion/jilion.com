module GoogleAnalyticsHelper
  
  def google_analytics
    if Rails.env.production?
      haml_tag :script, :type => "text/javascript" do
        haml_concat("var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-10280941-1']);
      _gaq.push(['_setDomainName', '.jilion.com']);
      _gaq.push(['_trackPageview']);
      
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
        })();"
        )
      end
    end
  end
  
end
