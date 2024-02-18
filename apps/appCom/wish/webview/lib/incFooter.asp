<!-- Google -->
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-16971867-6']);
  _gaq.push(['_setDomainName', '10x10.co.kr']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>

<!-- GSShop WCS -->
<script type="text/javascript">
<%
	if (GSShopSCRIPT<>"") then
		Response.Write GSShopSCRIPT
	end if
%>
	(function(w,d,n,s,i,e,o) {
		w[n]=w[n]||[];w[n].push(arguments);
		e=d.createElement(s);e.async= true;e.charset='utf-8' ;e.src='//wcs.gslook.com/static/js/wcs.min.js';
		o=d.getElementsByTagName(s)[0];o.parentNode.insertBefore(e,o);
	})(window, document, 'wcs', 'script' , '10x10');
</script>