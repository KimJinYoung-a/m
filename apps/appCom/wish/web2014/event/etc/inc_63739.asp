<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<%
'session("ssBctBigo") = rsget("shopid")
response.Charset="UTF-8"
%>
<%
'####################################################
' Description : 아이커피 1차
' History : 2015.06.18 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #INCLUDE Virtual="/apps/appcom/wish/web2014/lib/util/commlib.asp" -->

<%
dim currenttime, userid, i
	userid = getloginuserid()
	currenttime =  now()
	'currenttime = #06/19/2015 09:00:00#

dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  63794
	eCodedisp = 63794
Else
	eCode   =  63739
	eCodedisp = 63739
End If

dim evtUserCell
	evtUserCell = get10x10onlineusercell(userid)

dim event_subscriptexistscount, event_subscripttotalcount
event_subscriptexistscount = 0
event_subscripttotalcount = 0

If IsUserLoginOK Then
	'/본인응모수
	event_subscriptexistscount = getevent_subscriptexistscount(eCode, userid, left(currenttime,10), "", "")
end if
%>

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->

<% if left(currenttime,10)<"2015-06-19" then %>
	<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/inc_63739_1.asp" -->
<% elseif left(currenttime,10)>="2015-06-19" and left(currenttime,10)<"2015-06-23" then %>
	<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/inc_63739_1.asp" -->
<% elseif left(currenttime,10)>="2015-06-23" and left(currenttime,10)<"2015-06-26" then %>
	<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/inc_63739_2.asp" -->
<% elseif left(currenttime,10)>="2015-06-26" and left(currenttime,10)<"2015-06-29" then %>
	<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/inc_63739_3.asp" -->
<% else %>
	<!-- #include virtual="/apps/appCom/wish/web2014/event/etc/inc_63739_3.asp" -->
<% end if %>

<form name="eventfrm" method="post" action="" style="margin:0px;">
<input type="hidden" name="mode" value="add" />
<input type="hidden" name="line1" id="line1" />
<input type="hidden" name="line2" id="line2" />
<input type="hidden" name="line3" id="line3" />
</form>	

<!-- #include virtual="/lib/db/dbclose.asp" -->