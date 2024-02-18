<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 스페셜마일리지
' History : 2019-03-07 최종원
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
	eCode = "90243"
Else
	eCode = "93081"
End If

currenttime = now()
'currenttime = #02/04/2019 09:00:00#

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
'currentDate = Cdate("2019-03-11")
mileage = 3333
subscriptcount=0
totalsubscriptcount=0
limitcnt = 9999
eventType = ""
soldOutMsg = "오늘의 마일리지가 모두 소진 되었습니다!"
timeLimitMsg = "마일리지는 오전 10시부터 받으실수 있습니다."

if userid<>"" then
	subscriptcount = getevent_subscriptexistscount(eCode, userid, "", mileage, "")
end if

'//전체 참여수
totalsubscriptcount = getevent_subscripttotalcount(eCode, "", mileage, "")


currentcnt = limitcnt - totalsubscriptcount
'//본인 참여 여부
if currentcnt < 1 then currentcnt = 0
%>
<%
'// SNS 공유용
    Dim vTitle, vLink, vPre, vImg
    Dim snpTitle, snpLink, snpPre, snpTag, snpImg, appfblink

    snpTitle    = Server.URLEncode("[스페셜 마일리지!]")
    snpLink        = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode)
    snpPre        = Server.URLEncode("10x10 이벤트")
    snpImg        = Server.URLEncode("http://webimage.10x10.co.kr/fixevent/event/2019/93081/bnr_kakao.jpg")
    appfblink     = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode 

    '// 카카오링크 변수
    Dim kakaotitle : kakaotitle = " [스페셜 마일리지!]"
    Dim kakaodescription : kakaodescription = "3월을 기념하여, 현금처럼 쓸 수 있는 마일리지 3,333원을 드립니다!"
    Dim kakaooldver : kakaooldver = "3월을 기념하여, 현금처럼 쓸 수 있는 마일리지 3,333원을 드립니다!"
    Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/fixevent/event/2019/93081/bnr_kakao.jpg"
    Dim kakaolink_url 
    If isapp = "1" Then '앱일경우
        kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="& eCode
    Else '앱이 아닐경우
        kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="& eCode
    End If	    
%>
 <style type="text/css">
.mEvt93081 {position: relative;}
.mEvt93081 .blind {display: none; height: 0; line-height: 0; opacity: 0;}
.ani1 {position: absolute; top: 12rem; right: 2.2rem; width: 6.1rem; animation:bounce .7s 30;}
@keyframes bounce {
	from to {transform:translateY(0); animation-timing-function:ease-out;}
	50% {transform:translateY(-10px); animation-timing-function:ease-in;}
}
</style>
<script type="text/javascript" src="/event/etc/json/js_applyItemInfo.js"></script>
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
					url:"/event/etc/doeventsubscript/specialMileageEventSubscript.asp",
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
					alert('마일리지가 발급되었습니다.');
					// console.log(resultData.data)
					// showPopup();		
				}else{
					var errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
		//				document.location.reload();
				}			
				console.log(resultData);
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
// function showPopup(){
// 	$('#lyrSch1').fadeIn();
// 	$('body').css({'overflow':'hidden'})
// }
</script>
<script>
//공유용 스크립트
	function snschk() {		
		<% if isapp then %>
		fnAPPshareKakao('etc','<%=kakaotitle%>\n<%=kakaodescription%>','<%=kakaolink_url%>','<%=kakaolink_url%>','<%="url="&kakaolink_url%>','<%=kakaoimage%>','','','','');
		return false;
		<% else %>
		event_sendkakao('<%=kakaotitle%>' ,'<%=kakaodescription%>', '<%=kakaoimage%>' , '<%=kakaolink_url%>' );	
		<% end if %>
	}
	function parent_kakaolink(label , imageurl , width , height , linkurl ){
		//카카오 SNS 공유
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

	//카카오 SNS 공유 v2.0
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
</head>
<body>            
			<% if GetLoginUserLevel = "7" then %>
			<div style="color:red">*스태프만 노출</div>            
			<div>받은 고객 수 : <%=totalsubscriptcount%></div>			
			<% end if %>
			<div class="mEvt93081">
				<div class="topic">
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/tit_mileage.jpg" alt="3월을 기념하여, 스페셜 마일리지를 드립니다" />
                    <p class="ani1"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/img_ani.png" alt="단 2일간" /></p>
                    <button type="button" onclick="doAction();"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/btn_submit.jpg" alt="마일리지 받기" /></button>					
                    <img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/img_guide.jpg?v=1.01" alt="이벤트 유의사항" />
                    <div class="blind">
                        <h3>이벤트 유의사항</h3>
                        <ul>
                            <li>본 이벤트는 로그인 후에 참여할 수 있습니다. </li>
                            <li>ID당 1회만 참여가 가능합니다. </li>
                            <li>주문하시는 상품에 따라, 배송비용은 추가로 발생할 수 있습니다.</li>
                            <li>지급된 마일리지는 <b>3만원 이상 구매 시 현금처럼 사용 가능<b>합니다.</li>
                            <li>주문결제 시 마일리지 란에서 사용 가능합니다.</li>
                            <li>기간 내에 사용하지 않은 마일리지는 3월 12일 화요일 오후 23:59:59에 자동 소멸됩니다. </li>
                            <li>이벤트는 조기 마감될 수 있습니다. </li>
                        </ul>
                    </div>
					<a href="javascript:snschk();" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/bnr_01.jpg?v=1.01" alt="3월 마일리지 이벤트 친구에게 공유하기" /></a>
					<a href="/event/eventmain.asp?eventid=93058" onclick="jsEventlinkURL(93058);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/bnr_02.jpg?v=1.01" alt="당신의 추억이 새로워 지는 순간" /></a>
					<a href="/event/eventmain.asp?eventid=92898" onclick="jsEventlinkURL(92898);return false;"><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/bnr_03.jpg?v=1.01" alt="때가 됐다! 봄 신상 살 때!" /></a>
					<!-- <% if isapp = 1 then %>
						<a href="javascript:fnAPPpopupBrowserURL('sns아이템','<%=wwwUrl%>/apps/appCom/wish/web2014/snsitem/index.asp');" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/bnr_02.jpg" alt="요즘 핫 한 sns아이템 모두 모아보기" /></a>						
					<% else %>
						<a href="/snsitem/" ><img src="//webimage.10x10.co.kr/fixevent/event/2019/93081/m/bnr_02.jpg" alt="요즘 핫 한 sns아이템 모두 모아보기" /></a>
					<% end if %>                     -->
                </div>
			</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->