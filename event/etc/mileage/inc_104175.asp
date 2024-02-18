<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 단 2일간 6,000원 할인받는 팁
' History : 2020-07-07 이종화
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime
IF application("Svr_Info") = "Dev" THEN
	eCode = "102195"
Else
	eCode = "104175"
End If

currenttime = now()
userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, mileage
dim limitcnt, eventType, soldOutMsg, timeLimitMsg
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
'// 요건 이벤트 오픈때는 주석처리 할 것
'eventStartDate = Cdate("2019-11-11")

mileage = 2000
subscriptcount = 0
limitcnt = 99999
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", mileage, "")
end if
%>
<script>
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
		// 선착순 이벤트일때
			<% if eventType = "limitedEvent" then %>
				<% if currentcnt < 1 then %>
					alert("<%=soldOutMsg%>");
					return false;
				<% end if %>
				<% if Hour(currenttime) < 10 then %>
					alert("<%=timeLimitMsg%>");
					return false;
				<% end if %>	
			<% end if %>
				var str = $.ajax({
					type: "post",
					url:"/event/etc/mileage/do_proc.asp",
					data: {
						eventType: '<%=eventType%>',
                        eventCode: '<%=eCode%>',
                        jukyo : '이벤트 마일리지 2000 적립'
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
					alert('마일리지 발급이 완료되었습니다.\n사용하지 않은 마일리지는 이벤트 기간 이후 자동 소멸됩니다.');
					fnAmplitudeEventMultiPropertiesAction('click_mileage_button','evtcode','<%=eCode%>')
					// console.log(resultData.data)
					// showPopup();
				}else{
					var errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
				}			
				// console.log(resultData);
				<% if eventType = "limitedEvent" then %>
				$("#dispCnt").html(currentcnt)
				$("#dispMileage").html(setComma(userMileage))
				<% end if %>
			return false;
		<% end if %>
	<% else %>
		<% if isApp=1 then %>
			parent.calllogin();
			return false;
		<% else %>
			parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
			return false;
		<% end if %>
	<% End If %>
}
</script>
<div class="mEvt100018">
    <h2><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_02.jpg" alt="마일리지이벤트"></h2>
    <button onclick="doAction();"><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_03.jpg" alt="마일리지 받기"></button>
    <div><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_04.jpg" alt=""></div>
    <a href="/event/eventmain.asp?eventid=104096" target="_blank" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_05.jpg" alt="육아템 빅세일"></a>
    <a href="" onclick="fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid=104096');return false;" target="_blank" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_05.jpg" alt="육아템 빅세일"></a>
    <div><img src="http://webimage.10x10.co.kr/eventIMG/2020/104175/m_06.jpg" alt="유의사항"></div>
</div>