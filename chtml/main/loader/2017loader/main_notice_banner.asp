<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<%
'#######################################################
' Discription : 공지사항 배너
' History : 2019-04-17 최종원 생성
'#######################################################
%>
<!-- 공지사항 배너 -->
<script>
$(function(){
	// 공지사항 롤링
	var newsWidth = $('.news-txt a').outerWidth();
	var newsInnerWidth = $('.news-txt a').width();
	var newSpace=$('.news-area').width();
	if(newsInnerWidth>newSpace){
		$('.news-txt').append($('.news-txt').html());
		setInterval(function(){ 
			$('.news-txt').animate({'margin-left':-newsWidth}, 5000, function() {
				$(this).css({'margin':'0'}).append($('.news-txt').find('> p:first'));
			})
		}, 7000);
	}
})
</script>	
<% If Trim(fnGetImportantNotice) <> "" Then %>
<%
	Dim importantNoticeSplit
	importantNoticeSplit = split(fnGetImportantNotice,"|||||")
%>
	<div class="news-area">
	<% if isapp then %>
		<button onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appCom/wish/web2014/common/news/index.asp','right','','sc');return false;">
	<% else %>	
		<button onclick="location.href='/common/news/index.asp'">
	<% end if %>	
			NOTICE
		</button> 
		<div class="news-txt">
			<% if isapp then %>
				<a href="" onclick="fnAPPpopupBrowserURL('공지사항','<%=wwwUrl%>/apps/appCom/wish/web2014/common/news/news_view.asp?idx=<%=importantNoticeSplit(0)%>&direct=1','right','','sc');return false;"><%=importantNoticeSplit(1)%></a>
			<% else %>	
				<a href="/common/news/news_view.asp?idx=<%=importantNoticeSplit(0)%>"><%=importantNoticeSplit(1)%></a>
			<% end if %>					
		</div>
	</div>
<% end if %>	
<!-- #include virtual="/lib/db/dbclose.asp" -->