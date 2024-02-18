<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 리마인드 쿠폰
' History : 2019-07-09 최종원
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<%
dim eCode, userid, couponIdx, couponType
IF application("Svr_Info") = "Dev" THEN
	eCode = "90421"
	couponIdx = "2903,2909"
Else
	eCode = "98366"
	couponIdx = "1223,1224"
End If
couponType = "evtsel,evtsel"

userid = GetEncLoginUserID()

dim eventEndDate, currentDate, eventStartDate
dim subscriptcount, totalsubscriptcount 
dim evtinfo : evtinfo = getEventDate(eCode)

if not isArray(evtinfo) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
end if

'변수 초기화
eventStartDate = cdate(evtinfo(0,0))
eventEndDate = cdate(evtinfo(1,0))
currentDate = date()
'currentDate = Cdate("2019-05-04")
eventStartDate = cdate("2019-05-10")

%>
<style type="text/css">
.mEvt98366 {position: relative; font-family: 'Roboto','Noto Sans KR','malgun Gothic','맑은고딕',sans-serif}
.mEvt98366 .topic {position: relative;}
.mEvt98366 .topic .inner {position: absolute; width: 100%; top: 0; padding: 0 8%; text-align: left;}
.mEvt98366 .topic .txt1 {padding-top: 19%; margin-bottom: 29%; font-size: 3.11rem; font-weight: 500; color: #222222; line-height: 1;}
.mEvt98366 .topic .txt2 {font-size: 1.28rem; color: #755b2f; line-height: 1.82; }
.mEvt98366 .topic .txt2 .name {margin-right: .2rem; font-size: 1.29rem; font-weight: bold; color: #43300f;}
.mEvt98366 .topic .ani {position: absolute; top: 27%; right: 14%; width: 4.27rem; height: 4.27rem; overflow: hidden; border-radius: 50%; animation: fire 1.2s ease infinite; transform-origin: 50%; background: url(//webimage.10x10.co.kr/fixevent/event/2019/98366/m/img_ani.png) center /4.27rem;} 
.mEvt98366 .noti {background-color: #9b845c;}
@keyframes fire {from {transform: scale(.85); opacity: 0;} 25% {opacity: 1;} 85% {transform: scale(1); opacity: 1;}	to {transform: scale(1); opacity: 0;}}
</style>
<script>
function handleClickCoupon(stype,idx){
    <% If not IsUserLoginOK() Then %>
        jsEventLogin();
        return false;
    <% end if %>
    var str = $.ajax({
        type: "POST",
        url: "/event/etc/coupon/couponshop_process.asp",
        data: "mode=cpok&stype="+stype+"&idx="+idx,
		dataType: "text",
		success: function(str){
			var str1 = str.split("||")
			if (str1[0] == "11"){
				fnAmplitudeEventMultiPropertiesAction("click_event_coupondown","evtcode","<%=eCode%>");
				alert("쿠폰이 발급되었습니다.\n잊지 말고 11월 8일까지 사용해주세요!")
				return false;
			}else if (str1[0] == "12"){
				alert('기간이 종료되었거나 유효하지 않은 쿠폰입니다.');
				return false;
			}else if (str1[0] == "13"){
				alert('이미 다운로드 받으셨습니다.');
				return false;
			}else if (str1[0] == "02"){
				alert('로그인 후 쿠폰을 받을 수 있습니다!');
				return false;
			}else if (str1[0] == "01"){
				alert('잘못된 접속입니다.');
				return false;
			}else if (str1[0] == "00"){
				alert('정상적인 경로가 아닙니다.');
				return false;
			}else{
				alert('오류가 발생했습니다.');
				return false;
			}           
		},
		error: function(data){
			alert('오류가 발생했습니다.');
		}
    })
}

function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid=?" & eCode)%>');
<% end if %>
	return;
}
</script>
</head>
<body>
	<!-- 98366 리마인드쿠폰 -->
	<div class="mEvt98366">
		<div class="topic">
			<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98366/m/bg_top.jpg" alt="고마워서 드리는 쿠폰"></span>
			<div class="inner">
				<div class="txt1">
					<span class="name"><%=chkIIF(IsUserLoginOK(), GetLoginUserName(), "고객")%></span>님
				</div>
				<div class="txt2">
					10월 한 달 동안, 텐바이텐 18주년을 <br>
					함께한  <span class="name"><%=chkIIF(IsUserLoginOK(), GetLoginUserName(), "고객")%></span>님께 감사의 쿠폰을 드립니다. <br>
					앞으로도 다양한 즐거움을 드리는 <br>
					텐바이텐이 되도록 하겠습니다!
				</div>
				<span class="ani"></span>
			</div>
		</div>
		<button onclick="handleClickCoupon('<%=couponType%>','<%= couponIdx %>')"><img src="//webimage.10x10.co.kr/fixevent/event/2019/98366/m/btn.jpg" alt="쿠폰 받기"></button>
		<span><img src="//webimage.10x10.co.kr/fixevent/event/2019/98366/m/txt_noti.jpg" alt="유의사항"></span>
	</div>
	<!-- // 98366 리마인드쿠폰 -->
<!-- #include virtual="/lib/db/dbclose.asp" -->