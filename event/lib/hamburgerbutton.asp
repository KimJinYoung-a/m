<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<%
'#######################################################
'	History	:  2019.01.11 이종화
'	Description : 햄버거 레이어 버튼
'#######################################################
Dim eCode , pageNumber , evt_kind , pageSize
dim arrEventList , sqlStr , i
dim totalcount , countSqlStr
 
eCode       = getNumeric(requestCheckVar(request("eventid"),10))
pageNumber  = getNumeric(requestCheckVar(request("page"),8))
evt_kind    = getNumeric(requestCheckVar(request("evt_kind"),8))

if eCode = "" then eCode = 0
if pageNumber = "" then pageNumber 	= 1
if evt_kind = "" then evt_kind 	= 1
pageSize = 4

IF eCode > 0 and evt_kind > 0 then
    countSqlStr = "SELECT count(evt_code) FROM db_event.dbo.tbl_event WHERE evt_kind="& evt_kind &" and evt_state >= 5 and evt_using = 'Y' and evt_startdate <= getdate()"
    rsget.Open countSqlStr,dbget
	IF not rsget.EOF THEN
		totalcount = rsget(0)
	END IF
	rsget.close
    
    sqlStr = "db_event.dbo.[usp_WWW_Event_EventKindList_Get] ("& pageNumber &", "& pageSize &", "& evt_kind &")"
    rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly, adCmdStoredProc
    IF Not (rsget.EOF OR rsget.BOF) THEN
        arrEventList = rsget.getRows()
    END IF
    rsget.close
end if 

if isArray(arrEventList) then
%>
<div id="navFashion" class="nav-fashion">
    <div class="navName"><b>CONTENTS LIST</b></div>
    <ul>
        <% for i=0 to ubound(arrEventList,2) %>
        <li>
        <% If isApp="1" Then %>
            <a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%=arrEventList(0,i)%>&page=<%=pageNumber%>" <% if Trim(eCode)=Trim(arrEventList(0,i)) then %>class='on'<% end if %>>
        <% Else %>
            <a href="/event/eventmain.asp?eventid=<%=arrEventList(0,i)%>&page=<%=pageNumber%>" <% if Trim(eCode) = Trim(arrEventList(0,i)) then %>class='on'<% end if %>>
        <% End If %>
            <div class="thumb"><img src="<%=arrEventList(3,i)%>" alt="" /></div>
            <strong>
                <b>VOL. <%=totalcount-i-(pageSize*(pageNumber-1))%></b> <%=replace(arrEventList(7,i),"""","")%></strong>
            </a>
        </li>
        <% Next %>
    </ul>
    <%= fnDisplayPaging_NewEvt(pageNumber,totalcount,3,3,"goLayerPage",eCode,evt_kind) %>
</div>
<% End If %>
<!-- #include virtual="/lib/db/dbclose.asp" -->