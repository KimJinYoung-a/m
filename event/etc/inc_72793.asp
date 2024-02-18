<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [★★2016 F/W 웨딩 메인] Big sale
' History : 2016-09-13 유태욱 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/htmllib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
dim eCode, redt
IF application("Svr_Info") = "Dev" THEN
	eCode			= 66199	'현재 이벤트 코드
Else
	eCode			= 72793	'현재 이벤트 코드
End If

redt = requestCheckVar(Request("redt"),2)

if redt <> "on" then
	if isapp then
		If date() < "2016-10-03" then
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=187550&redt=on")
		elseIf date() >= "2016-10-03" and  date() < "2016-10-10" then
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=187551&redt=on")
		else
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=187552&redt=on")
		End If
	else
		If date() < "2016-10-03" then
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=187550&redt=on")
		elseIf date() >= "2016-10-03" and  date() < "2016-10-10" then
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=187551&redt=on")
		else
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=187552&redt=on")
		End If
	end if
end if
%>
<style type="text/css">
img {vertical-align:top;}
.evtHeadV15 {display:none;}
.saleNav {position:relative;}
.saleNav iframe {position:absolute; width:100%; height:100%; vertical-align:top;}
</style>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtContV15">

	<div class="mEvt72793">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2016/72793/m/tit_big_sale_v2.gif" alt="1Week BIG SALE - 매주 달라지는 일주일의 특가" /></h2>
		<div class="saleNav">
			<iframe id="iframe_sale" src="/event/etc/group/iframe_72793.asp?eventid=72793" frameborder="0" scrolling="no"></iframe>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2016/72793/m/bg_frame.png" alt="" /></div>
		</div>
	</div>
</div>
<!--// 이벤트 배너 등록 영역 -->
	