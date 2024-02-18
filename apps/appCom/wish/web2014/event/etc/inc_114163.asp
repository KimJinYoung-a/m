<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 3000 마일리지
' History : 2020-12-21 정태훈
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, currenttime, moECode
IF application("Svr_Info") = "Dev" THEN
	eCode = "108394"
	moECode = "102173"
Else
	eCode = "114163"
	moECode = "114164"
End If

Dim gaparamChkVal
gaparamChkVal = requestCheckVar(request("gaparam"),30)

If isApp <> "1" Then
	Response.redirect "/event/eventmain.asp?eventid="& moECode &"&gaparam="&gaparamChkVal
	Response.End
End If

currenttime = now()
'currenttime = #02/04/2019 09:00:00#

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount, mileage
dim currentcnt, eventType, soldOutMsg, timeLimitMsg
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

mileage = 3000
subscriptcount=0
totalsubscriptcount=0
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", mileage, "")

currentcnt = totalsubscriptcount
'//본인 참여 여부
if currentcnt < 1 then currentcnt = 0

%>
<style>
.mEvt114163 a {display:inline-block;}
.mEvt114163 button {background:transparent;}
.mEvt114163 .topic {position:relative;}
.mEvt114163 .topic .btn-mileage {width:100%; height:10rem; position:absolute; left:0; bottom:12%;}
.mEvt114163 .section-01,
.mEvt114163 .section-02 {position:relative;}
.mEvt114163 .section-01 a {width:100%; height:13rem; position:absolute; left:0; bottom:9%;}
.mEvt114163 .section-02 .bnr-area {display:flex; flex-wrap:wrap; width:100%; position:absolute; left:0; top:18%;}
.mEvt114163 .section-02 .bnr-area div {width:100%;}
.mEvt114163 .section-02 .bnr-area a {width:100%; height:14rem;}
</style>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/common.js?v=4.812"></script>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.528"></script>
<script>
function doAction() {
	<% if not ( currentDate >= eventStartDate and currentDate <= eventEndDate ) then %>	
		alert("이벤트 참여기간이 아닙니다.");
		return false;
	<% end if %>			
	<% If IsUserLoginOK() Then %>			
		<% if subscriptcount > 0 then %>
			alert("이미 발급되었습니다. (ID당 최대 1회 발급 가능)");
			return;
		<% else %>	
            var str = $.ajax({
                type: "post",
                url:"/apps/appCom/wish/web2014/event/etc/doeventsubscript/specialMileageEventSubscript.asp",
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
                alert('3,000P 발급이 완료 되었습니다.\n사용하지 않은 마일리지는 이벤트 기간 이후 자동 소멸됩니다');
                fnAmplitudeEventMultiPropertiesAction('click_mileage_button','evtcode','<%=eCode%>')
                // console.log(resultData.data)
                // showPopup();
            }else{
                var errorMsg = reStr[1].replace(">?n", "\n");
                alert(errorMsg);
            }			
			return false;
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

function fnAPPEventGotoURL(v){
    fnAmplitudeEventAction('click_mileage_eventbanner','evtcode','' + v + '');
	setTimeout(fnAPPpopupBrowserURL('기획전','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+v),1000);
}
</script>
			<div class="mEvt114163">
				<div class="topic">
					<h2><img src="//webimage.10x10.co.kr/fixevent/event/2021/114163/m/img_main.jpg" alt="3,000p 를 받으세요!"></h2>
                    <!-- 마일리지 받기 버튼 -->
                    <button type="button" class="btn-mileage" onclick="doAction();"></button>
				</div>
                <div class="section-01">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114163/m/img_sub01.jpg" alt="마일리지 결제 시, 현금처럼 사용할 수 있습니다.">
                    <a href="" onclick="fnAPPEventGotoURL(113434);return false;" class="mApp"></a>
                </div>
                <div class="section-02">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2021/114163/m/img_bnr.jpg" alt="이번 주에 꼭 봐야 할 기획전 top5">
                    <div class="bnr-area">
                        <div>
                            <a href="" onclick="fnAPPEventGotoURL(113035);return false;" class="mApp"></a>
                        </div>
                        <div>
                            <a href="" onclick="fnAPPEventGotoURL(107904);return false;" class="mApp"></a>
                        </div>
                        <div>
                            <a href="" onclick="fnAPPEventGotoURL(113714);return false;" class="mApp"></a>
                        </div>
                        <div>
                            <a href="" onclick="fnAPPEventGotoURL(113839);return false;" class="mApp"></a>
                        </div>
                        <div>
                            <a href="" onclick="fnAPPEventGotoURL(113675);return false;" class="mApp"></a>
                        </div>
                    </div> 
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->