<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/login/checkUserGuestlogin.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	strHeadTitleName="등급별 혜택"

Function besturl(v)
	Select Case v
		Case 0 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=0" 'WHITE
		Case 1 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=1" 'RED
		Case 2 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=2" 'VIP
		Case 3 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=3" 'VIP GOLD
		Case 4 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=4" 'VVIP
		Case 5 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=0" 'WHITE
		Case 6 : besturl = "/apps/appcom/wish/web2014/award/awarditem.asp?userlevel=4" 'VVIP
		Case Else 
			besturl = "/apps/appcom/wish/web2014/award/awarditem.asp" 'STAFF
	End select
End Function
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script>
$(function(){
	$(".tabNav li").click(function() {
		$(this).siblings("li").removeClass("current");
		$(this).addClass("current");
		$(this).closest(".tabNav").nextAll(".tabContainer:first").find(".tabContent").hide();
		var activeTab = $(this).find("a").attr("href");
		$(activeTab).show();
		return false;
	});
});
</script>
</head>
<body class="default-font body-sub">
	<!-- contents -->
		<div id="content" class="content membershipV18">
			<!-- #include virtual="/my10x10/userinfo/inc_gradelist.asp" -->
		</div>
	<!-- //contents -->
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>