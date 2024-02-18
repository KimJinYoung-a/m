<center>
<div id="divTailer" style="position:relative;clear:left" >
<!-- Google -->
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-16971867-4']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>

<!-- RecoPick -->
<script type="text/javascript">
  (function(w,d,n,s,e,o) {
    w[n]=w[n]||function(){(w[n].q=w[n].q||[]).push(arguments)};
    e=d.createElement(s);e.async=1;e.charset='utf-8';e.src='//static.recopick.com/dist/production.min.js';
    o=d.getElementsByTagName(s)[0];o.parentNode.insertBefore(e,o);
  })(window, document, 'recoPick', 'script');
  recoPick('service', '10x10.co.kr');
<%
	if request.cookies("uinfo")("shix")<>"" then
		response.Write "recoPick('setMID', '" & request.cookies("uinfo")("shix") & "');" & vbCrLf
	end if

	if (RecoPickSCRIPT<>"") then
		Response.Write RecoPickSCRIPT
	else
		Response.Write "recoPick('page','view');"
	end if
%>
</script>

</div>
</center>
</body>
</html>