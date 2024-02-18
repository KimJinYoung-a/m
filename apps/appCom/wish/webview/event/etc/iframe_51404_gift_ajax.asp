<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description :  텐바이텐 위시 APP 런칭이벤트 1차
' History : 2014.03.27 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event51404Cls.asp" -->

<%
dim eCode, userid, kakaotalkscriptcount, giftscriptcount, sqlstr
	eCode=getevt_code
	userid = getloginuserid()

kakaotalkscriptcount=0
giftscriptcount=0

dim refer
refer = request.ServerVariables("HTTP_REFERER")
if InStr(refer,"10x10.co.kr")<1 then
	Response.Write "잘못된 접속입니다."
	dbget.close() : Response.End
end if

If userid = "" Then
	Response.Write "<script type='text/javascript'>alert('로그인을 해주세요'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
End IF

kakaotalkscriptcount = getevent_subscriptexistscount(eCode, userid, "", "2", "")	'//카카오톡 초대여부
if kakaotalkscriptcount = 0 then
	Response.Write "<script type='text/javascript'>alert('카카오톡 초대후, 참여 하실수 있습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if

dim cgift
set cgift=new Cevent_etc_common_list
	cgift.frectevt_code=eCode
	cgift.frectsub_opt2="3"
	cgift.frectuserid=userid
	cgift.event_subscript_one

if cgift.ftotalcount = 0 then
	Response.Write "<script type='text/javascript'>alert('선물 참여 내역이 없습니다.'); parent.top.location.href='/apps/appcom/wish/webview/event/eventmain.asp?eventid="&eCode&"'</script>"
	dbget.close() : Response.End
end if
%>

<div class="pCont">
	<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/txt_win.png" alt="축하합니다. 받은 선물은 선물 보관함에서 확인하실 수 있습니다." /></p>
	<div class="myPresent">
		<% if cgift.FOneItem.fsub_opt1="giftcon" then %>
			<%
			sqlstr = "select top 1"
			sqlstr = sqlstr & " t.couponidx, t.bigo"
			sqlstr = sqlstr & " from db_temp.dbo.tbl_event_etc_yongman t"
			sqlstr = sqlstr & " where isusing='Y' and t.userid='"& userid &"' and t.event_code="&eCode&" "

			'response.write sqlstr & "<Br>"
			rsget.Open sqlstr,dbget
			IF not rsget.EOF THEN
			%>
				<div class="gifticon">
					<p class="img"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/img_gifticon0<%= rsget("couponidx") %>.jpg" alt="" /></p>
					<p class="barcode">
						<img src="http://company.10x10.co.kr/barcode/barcode.asp?data=<%= getNumeric(rsget("bigo")) %>&height=40">
					</p>
				</div>
			<%
			END IF
			rsget.close
			%>
		<% end if %>

		<% if cgift.FOneItem.fsub_opt1="macbook" then %>
			<div class="macbook"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/img_macbook.png" alt="맥북" /></div>
		<% end if %>

		<% if cgift.FOneItem.fsub_opt1="coupon" then %>
			<div class="tenCoupon"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/img_coupon.png" alt="3,000원 할인 쿠폰" /></div>
		<% end if %>
	</div>
	<span class="closeBtn"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51404/appland_btn_confirm.png" alt="확인" /></span>
</div>
<div class="bg"></div>

<% set cgift=nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->