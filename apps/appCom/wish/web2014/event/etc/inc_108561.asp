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
	eCode = "104279"
	moECode = "102173"
Else
	eCode = "108561"
	moECode = "108560"
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

'// SNS 공유용
Dim vTitle, vLink, vPre, vImg
Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

snpTitle	= Server.URLEncode("[마일리지 지급 이벤트]")
snpLink		= Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode)
snpPre		= Server.URLEncode("10x10 이벤트")
snpImg		= Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2020/108561/m/img_kakao.jpg")
appfblink	= "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode 

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[마일리지 지급 이벤트]"
Dim kakaodescription : kakaodescription = "단 2일간 모두에게 마일리지 3,000p를 드립니다."
Dim kakaooldver : kakaooldver = "단 2일간 모두에게 마일리지 3,000p를 드립니다."
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2020/108561/m/img_kakao.jpg"
Dim kakaoAppLink, kakaoMobileLink, kakaoWebLink 
kakaoAppLink 	= "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
kakaoMobileLink = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& moECode
kakaoWebLink = "http://www.10x10.co.kr/event/eventmain.asp?eventid="& moECode
%>
<style>
.mEvt108561 {position:relative; overflow:hidden;}
.mEvt108561 button {width:100%;}
</style>
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
                alert('마일리지 발급이 완료되었습니다.\n사용하지 않은 마일리지는 이벤트 기간 이후 자동 소멸됩니다.');
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

function snschk(snsnum) {	
    fnAmplitudeEventMultiPropertiesAction('click_event_share','evtcode|sns','<%=eCode%>|'+snsnum)	
    if(snsnum=="fb"){
        <% if isapp then %>
        fnAPPShareSNS('fb','<%=appfblink%>');
        return false;
        <% else %>
        popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
        <% end if %>
    }else{
        <% if isapp then %>		
            fnAPPshareKakao('etc','<%=kakaotitle%>','<%=kakaoWebLink%>','<%=kakaoMobileLink%>','<%="url="&kakaoAppLink%>','<%=kakaoimage%>','','','','<%=kakaodescription%>');
            return false;
        <% else %>
            event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaoMobileLink%>' );	
        <% end if %>
    }		
}
function parent_kakaolink(label , imageurl , width , height , linkurl ){
    // 카카오 SNS 공유
    Kakao.init('c967f6e67b0492478080bcf386390fdd');

    Kakao.Link.sendTalkLink({
        label: label,
        image: {
        src: imageurl,
        width: width,
        height: height
        },
        webButton: {
            text: '10x10 바로가기',
            url: linkurl
        }
    });
}

// 카카오 SNS 공유 v2.0
function event_sendkakao(label , description , imageurl , linkurl){	
    Kakao.Link.sendDefault({
        objectType: 'feed',
        content: {
            title: label,
            description : description,
            imageUrl: imageurl,
            link: {
            mobileWebUrl: linkurl
            }
        },
        buttons: [
            {
            title: '웹으로 보기',
            link: {
                mobileWebUrl: linkurl
            }
            }
        ]
    });
}
</script>
			<div class="mEvt108561">
				<h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/tit_mileage.jpg" alt="3000 마일리지 이벤트"></h2>
				<button type="button" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/btn_mileage.jpg" alt="마일리지 받기"></button>
				<a href="#" onclick="fnAPPpopupBrowser(OpenType.FROM_RIGHT, [], '혜택 가이드', [], 'http://m.10x10.co.kr/apps/appCom/wish/web2014/event/benefit/');return false;">
					<img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/txt_tip.jpg" alt="마일리지 받으러 가기">
				</a>
				<p><img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/txt_guide.jpg" alt="마일리지는 결제 시 현금처럼 사용할 수 있습니다"></p>
				<button type="button" onclick="snschk('ka');"><img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/bnr_share.jpg" alt="카카오톡 공유하기"></button>
				<div><img src="//webimage.10x10.co.kr/fixevent/event/2020/108561/m/txt_notice.jpg" alt="유의사항"></div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->