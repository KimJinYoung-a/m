<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : [★★2017 S/S 웨딩 메인] Big sale
' History : 2017-03-29 조경애 생성
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
	eCode			= 76948	'현재 이벤트 코드
End If

redt = requestCheckVar(Request("redt"),2)

if redt <> "on" then
	dim mQrParam: mQrParam = request("gaparam")		'// gaparam 접수
	if mQrParam<>"" then mQrParam = "&gaparam=" & mQrParam

	if isapp then
		If date() < "2017-04-17" then
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=203998&redt=on" & mQrParam)
		elseIf date() >= "2017-04-17" and  date() < "2017-04-24" then
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=203999&redt=on" & mQrParam)
		else
			response.redirect("/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode&"&eGc=204000&redt=on" & mQrParam)
		End If
	else
		If date() < "2017-04-17" then
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=203998&redt=on" & mQrParam)
		elseIf date() >= "2017-04-17" and  date() < "2017-04-24" then
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=203999&redt=on" & mQrParam)
		else
			response.redirect("/event/eventmain.asp?eventid="&eCode&"&eGc=204000&redt=on" & mQrParam)
		End If
	end if
end if
%>
<style type="text/css">
.saleNav {position:relative;}
.saleNav iframe {position:absolute; left:0; top:0; width:100%; height:100%; vertical-align:top;}
</style>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtContV15">

	<div class="mEvt76948">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/76948/m/tit_sale.png" alt="JUST 1Week BIG SALE - 매주 달라지는 일주일의 특가" /></h2>
		<div class="saleNav">
			<iframe id="iframe_sale" src="/event/etc/group/iframe_76948.asp?eventid=76948" frameborder="0" scrolling="no"></iframe>
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/76948/m/bg_frame.png" alt="" /></div>
		</div>
	</div>
</div>
<!--// 이벤트 배너 등록 영역 -->
	