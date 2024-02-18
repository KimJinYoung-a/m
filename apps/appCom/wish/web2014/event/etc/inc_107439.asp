<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 반짝 2000 마일리지
' History : 2020-11-10 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, moECode, eGiveCode
IF application("Svr_Info") = "Dev" THEN
	eCode = "103261"
	moECode = "102186"
Else
	eCode = "107439"
	moECode = "107438"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

currenttime = now()
'currenttime = #11/12/2020 09:00:00#

if left(Cdate(currenttime),10) = "2020-11-11" then
    eGiveCode = "107482"
elseif left(Cdate(currenttime),10) = "2020-11-12" then
    eGiveCode = "107483"
elseif left(Cdate(currenttime),10) = "2020-11-13" then
    eGiveCode = "107484"
elseif left(Cdate(currenttime),10) = "2020-11-14" then
    eGiveCode = "107485"
elseif left(Cdate(currenttime),10) = "2020-11-15" then
    eGiveCode = "107486"
elseif left(Cdate(currenttime),10) = "2020-11-16" then
    eGiveCode = "107634"
elseif left(Cdate(currenttime),10) = "2020-11-17" then
    eGiveCode = "107635"
else
    eGiveCode = "107482"
end if

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount, mileage
dim limitcnt, currentcnt, eventType, soldOutMsg, timeLimitMsg
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()

if (GetLoginUserLevel="7") then
	IF currentDate < eventStartDate THEN
		eventStartDate = currentDate
	END IF
end if

mileage = 2000
subscriptcount=0
totalsubscriptcount=0
limitcnt = 99999
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eGiveCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", mileage, "")

currentcnt = limitcnt - totalsubscriptcount
'//본인 참여 여부
if currentcnt < 1 then currentcnt = 0
%>
<script type="text/javascript">
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>
	<% If IsUserLoginOK() Then %>
		<% if subscriptcount > 0 then %>
			alert("ID당 1회만 참여 가능합니다.");
			return;
        <% else %>
            <% if Hour(now()) >= Hour("00:00") and Hour(now()) < Hour("18:00") then %>
                alert("오후 6시부터 자정까지 마일리지 발급이 가능합니다.");
                return;
            <% else %>
                var str = $.ajax({
                    type: "post",
                    url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/doEventSubscript107439.asp",
                    data: {
                        eventType: '<%=eventType%>',
                        eventCode: '<%=eCode%>'
                    },
                    dataType: "text",
                    async: false
                }).responseText;	

                if(!str){alert("시스템 오류입니다."); return false;}

                var resultData = JSON.parse(str);

                var reStr = resultData.data[0].result.split("|");
                var currentcnt = resultData.data[0].currentcnt;
                var userMileage = resultData.data[0].mileage;		

                if(reStr[0]=="OK"){		
                    alert('마일리지 발급이 완료되었습니다.\n발급된 마일리지는 미사용 시 새벽 3시에 소멸됩니다.');
                    fnAmplitudeEventMultiPropertiesAction('click_mileage_button','evtcode','<%=eCode%>')
                    // console.log(resultData.data)
                    // showPopup();
                }else{
                    var errorMsg = reStr[1].replace(">?n", "\n");
                    alert(errorMsg);
                }
                return false;
            <% end if %>
		<% end if %>
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&moECode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
</script>
			<div class="mEvt107439">
				<a href="" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/107439/m/tit_mileage.jpg" alt="반짝 마일리지"></a>
				<a href="" onclick="fnAPPpopupBrowserURL('혜택 가이드','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/107439/m/txt_tip.jpg" alt="마일리지 사용 팁">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/107439/m/txt_mileage.jpg" alt="결제 시 현금처럼 사용"></p>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/107439/m/txt_notice.jpg" alt="이벤트 유의사항"></p>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->