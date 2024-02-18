<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : 웨딩 기획전 MA
' History : 2017-10-11 김송이 생성
'#############################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/etc/event72792Cls.asp" -->
<script>
// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
		fnAPPpopupEvent(evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
	<!-- 웨딩 기획전 (1 WEEK BIG SALE) M/A -->
	<div  class="evt80618 wedding-evt">
		<div class="prd-list">
			<% if date() < "2017-10-19" then %>
				<%' 1주차(1012~1018) %>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80618/m/80618_week01.jpg" alt="1 WEEK BIG SALE 1주차" /></h3>

			<% elseif date() >= "2017-10-19" and date() < "2017-10-26" then %>
				<%' 2주차(1019~1025) %>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80618/m/80618_week02.jpg" alt="1 WEEK BIG SALE 2주차" /></h3>

			<% elseif date() >= "2017-10-26" then %>
				<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/80618/m/80618_week03.jpg" alt="1 WEEK BIG SALE 3주차" /></h3>
				<%' 3주차(1026~1101) %>
				
			<% end if %>
		</div>
	</div>
	<!--// 웨딩 기획전 (1 WEEK BIG SALE) M/A -->
<!-- #include virtual="/lib/db/dbclose.asp" -->