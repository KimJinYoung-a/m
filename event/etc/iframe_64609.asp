<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 브랜드 어워드
' History : 2015.07.09 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim evt_code13 , evt_code14, evt_code15 , evt_code16 , evt_code17 , evt_code20 , evt_code21 , evt_code22 , evt_code23, evt_code24
Dim evt_code, userid
	evt_code = request("eventid")
	userid = getloginuserid()

dim currenttime
	currenttime =  now()
	'currenttime = #07/13/2015 09:00:00#

	IF application("Svr_Info") = "Dev" THEN
		evt_code13 = 64822
		evt_code14 = 64738
		evt_code15 = 64890
		evt_code16 = 64803
		evt_code17 = 64829
		evt_code20 = 64733
		evt_code21 = 64981
		evt_code22 = 65052
		evt_code23 = 65059
		evt_code24 = 65109
	Else
		evt_code13 = 64609
		evt_code14 = 64738
		evt_code15 = 64890
		evt_code16 = 64803
		evt_code17 = 64829
		evt_code20 = 64733
		evt_code21 = 64981
		evt_code22 = 65052
		evt_code23 = 65059
		evt_code24 = 65109
	End If
%>

<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.mBrandAward iframe {vertical-align:top;}
.selectBrand {height:45px; padding:0 5%; background:url(http://webimage.10x10.co.kr/eventIMG/2015/brandaward/m/bg_rookie_select_area.png) no-repeat 0 0 #68d0fd; background-size:100% auto;}
.selectBrand select {display:inline-block; width:100%; height:35px; padding:0 10px; border:0; color:#fff; font-weight:bold; background:url(http://webimage.10x10.co.kr/eventIMG/2015/brandaward/m/blt_rookie_arrow.png) no-repeat 96% 50% #1a8fff; background-size:21px 21px; border-radius:0;}
.aboutBrand {padding:0 5% 30px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/brandaward/m/bg_rookie_brand_info.png) no-repeat 0 0; background-size:100% auto;}
.brandInfo {position:relative; padding:6px 6px 24px; background:#fff; box-shadow:0 3px 10px 0 rgba(0,0,0,.4);}
.brandInfo .story {padding-top:18px;}
.brandInfo .story .goBrand {display:block; width:40%; margin:20px auto 0;}
.brandInfo .swiper .bPagination {position:absolute; bottom:18px; left:0; width:100%; height:8px; text-align:center; z-index:100;}
.brandInfo .swiper .bPagination span {display:inline-block; position:relative; width:8px; height:8px; margin:0 4px; border:1.5px solid #fff; cursor:pointer; vertical-align:top; border-radius:50%;}
.brandInfo .swiper .bPagination .swiper-active-switch {background:#1285ff; border:2px solid #1285ff;}
.brandInfo .swiper {position:relative;}
@media all and (min-width:480px){
	.selectBrand select {height:48px;}
	.aboutBrand {padding:30px 5% 45px;}
	.brandInfo {padding:9px 9px 36px;}
	.brandInfo .story {padding-top:27px;}
	.brandInfo .story .goBrand {margin-top:30px;}
	.brandInfo .swiper .bPagination {bottom:27px; height:12px;}
	.brandInfo .swiper .bPagination span {width:12px; height:12px; margin:0 6px; border:2px solid #fff;}
}
</style>
<script type="text/javascript">

$(function(){
	showSwiper= new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		pagination:'.bPagination',
		paginationClickable:true,
		speed:180
	});
	$(window).on("orientationchange",function(){
		var oTm = setInterval(function () {
		showSwiper.reInit();
		clearInterval(oTm);
		}, 1);
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$(".ma").show();
		$(".mw").hide();
	}else{
		$(".ma").hide();
		$(".mw").show();
	}
});

function chgBA(v){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		parent.location.href="/apps/appcom/wish/web2014/event/eventmain.asp?eventid="+v;	//앱영역 스크립트
	}else{
		parent.location.href="/event/eventmain.asp?eventid="+v;	//모바일영역 스크립트
	}
}

</script>
</head>
<body>

<% '<!-- iframe (사이즈 100% x 45px) --> %>
<div class="selectBrand">
	<select onchange="chgBA(this.value);">
		<% If left(currenttime,10)>="2015-07-13" Then %>
			<option value="<%= evt_code13 %>" <% if CStr(evt_code) = CStr(evt_code13) then response.write "selected" end if %>>07.13(월) | COCO HUMMING</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-14" Then %>
			<option value="<%= evt_code14 %>" <% if CStr(evt_code) = CStr(evt_code14) then response.write "selected" end if %>>07.14(화) | KAREL CAPEK</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-15" Then %>
			<option value="<%= evt_code15 %>" <% if CStr(evt_code) = CStr(evt_code15) then response.write "selected" end if %>>07.15(수) | NOVESTA</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-16" Then %>
			<option value="<%= evt_code16 %>" <% if CStr(evt_code) = CStr(evt_code16) then response.write "selected" end if %>>07.16(목) | HOUMMING K&amp;L</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-17" Then %>
			<option value="<%= evt_code17 %>" <% if CStr(evt_code) = CStr(evt_code17) then response.write "selected" end if %>>07.17(금) | GUDETAMA</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-20" Then %>
			<option value="<%= evt_code20 %>" <% if CStr(evt_code) = CStr(evt_code20) then response.write "selected" end if %>>07.20(월) | DAILYMONDAY</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-21" Then %>
			<option value="<%= evt_code21 %>" <% if CStr(evt_code) = CStr(evt_code21) then response.write "selected" end if %>>07.21(화) | CONTAINER FACTORY</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-22" Then %>
			<option value="<%= evt_code22 %>" <% if CStr(evt_code) = CStr(evt_code22) then response.write "selected" end if %>>07.22(수) | LOGOS</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-23" Then %>
			<option value="<%= evt_code23 %>" <% if CStr(evt_code) = CStr(evt_code23) then response.write "selected" end if %>>07.23(목) | SSEKO</option>
		<% End If %>
		<% If left(currenttime,10)>="2015-07-24" Then %>
			<option value="<%= evt_code24 %>" <% if CStr(evt_code) = CStr(evt_code24) then response.write "selected" end if %>>07.24(금) | AMBER</option>
		<% End If %>

	</select>
</div>
<% '<!--// iframe --> %>

</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->