<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
Session.Codepage = 65001
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : MA_item_prd // cache DB경유
' History : 2019-08-21 최종원 생성
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수
DIM userLevel, userOS, targetChannel, checkCouponIssue
checkCouponIssue = False

if isapp > 0 then
	targetChannel = "2"
else
	targetChannel = "3"
end if

'카테고리정보
dim vitemid	: vitemid = requestCheckVar(request("itemid"),9)
dim catecode

''facebook 예외처리 2019/06/04 ex)?itemid=123123&targeturl=...&itemid=123123 
if InStr(vitemid,",")>0 then
	vitemid = LEFT(vitemid,InStr(vitemid,",")-1)
end if

if vitemid="" or vitemid="0" then
	Call Alert_Return("상품번호가 없습니다.")
	response.End
elseif Not(isNumeric(vitemid)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
else
	'정수형태로 변환
	vitemid=CLng(getNumeric(vitemid))
end if

userLevel = cstr(session("ssnuserlevel"))
userOS	  = flgDevice

poscode = 716

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "WPIMG_"&Cint(timer/60)
Else
	cTime = 60*1
	dummyName = "WPIMG"
End If
IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 1

sqlStr = " EXEC [db_sitemaster].[dbo].[usp_ten_banners_get] '" & topcnt & "', '"& poscode &"', '"& vitemid &"', '" & userLevel & "', '" & userOS & "', '" & targetChannel & "' "

'Response.write sqlStr &"<br/>"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
If IsArray(arrList) Then
%>
<script>
$(function(){
	$('.lyr-coupon .btn-close').click(function(e){
		e.preventDefault();
		$('.lyr-coupon').hide();
	});
});
</script>
<style>
	<% '18주년 세일 기간 동안 이 style 제외
	'If date() < "2019-09-26" OR date() > "2019-09-30" Then 
	If date() < "2019-10-01" OR date() > "2019-10-31" Then
	%>
		.item-etc-info ul,
		.deal-item .item-etc-info p {border-top:0;}
	<%
	End if %>
.lyr-coupon {display:none; position:fixed; top:0; left:0; z-index:99999; width:100vw; height:100vh; background-color:rgba(91, 91, 91, 0.52);}
.lyr-coupon .inner {position:absolute; left:6.5%; top:50%; width:87%; padding:12.28vw 0 10vw; transform:translateY(-50%); text-align:center; background-color:#fff; -webkit-border-radius:0.2rem; border-radius:0.2rem;}
.lyr-coupon .btn-close1 {position:absolute; top:0; right:0; width:16vw; height:16vw; font-size:0; color:transparent; background:url(//fiximage.10x10.co.kr/web2019/common/ico_x.png) no-repeat 50% / 5.4vw;}
.lyr-coupon h2 {font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:1.88rem;}
.lyr-coupon .cpn {position:relative; width:54.13vw; margin:2.35rem auto 1.2rem;}
.lyr-coupon .cpn p {position:absolute; left:0; width:100%;}
.lyr-coupon .cpn .amt {top:20%; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; font-size:2.17rem; color:#fff;}
.lyr-coupon .cpn .amt b {margin-right:0.2rem; font-size:3.16rem; vertical-align:text-bottom;}
.lyr-coupon .cpn .txt1 {top:66%; font-family:'AvenirNext-DemiBold', 'AppleSDGothicNeo-SemiBold'; font-weight:bold; font-size:1.02rem; color:#919ff2; letter-spacing:-.05rem;}
.lyr-coupon .cpn .txt1 b {margin-right:0.1rem; font-size:1.11rem;}
.lyr-coupon .txt2 {font-size:1.28rem; color:#999; line-height:1.96rem;}
.lyr-coupon .txt2 strong {font-weight:normal; color:#ff3434;}
.lyr-coupon .btn-area {margin-top:1.9rem; padding-bottom:0.6vw; font-size:0;}
.lyr-coupon .btn-area button {height:3.93rem; font-family:'AvenirNext-Bold', 'AppleSDGothicNeo-Bold'; font-weight:bold; -webkit-border-radius:0.2rem; border-radius:0.2rem;}
.lyr-coupon .btn-area .btn-close2 {width:9.3rem; font-size:1.28rem; background-color:#c2c2c2; color:#444;}
.lyr-coupon .btn-area .btn-down {width:12.2rem; margin-left:0.7rem; font-size:1.24rem; background-color:#222; color:#fff;}
</style>
<script>
function jsEvtCouponDown(stype, idx, cb) {
	<% If IsUserLoginOK() Then %>
	$.ajax({
			type: "POST",
			url: "/event/etc/coupon/couponshop_process.asp",
			data: "mode=cpok&stype="+stype+"&idx="+idx,
			dataType: "text",
			success: function(message) {
				if(message) {
					var str1 = message.split("||")
					if (str1[0] == "11"){
						fnAmplitudeEventMultiPropertiesAction('click_marketing_top_bnr','','')
						cb();
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
				}
			}
	})
	<% Else %>
		jsEventLogin();
		return false;
	<% End IF %>
}
function handleClicKBanner(isapp, link, bannerType, couponidx, lyrId, ampeventid){
	var couponType

	if(bannerType == 1){ //링크배너
		if(isapp == 1){
			fnAmplitudeEventMultiPropertiesAction(''+ampeventid+'','','', function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014'+link);return false;}});
		}else{
			fnAmplitudeEventMultiPropertiesAction(''+ampeventid+'','','')
			window.location.href = link
		}
	}else if(bannerType == 2){ //쿠폰배너
		couponType = couponidx == 1190 ? 'month' : 'evtsel'
		jsEvtCouponDown(couponType, couponidx, function(){
			popupLayer(lyrId)
		})
	}else{ // 레어어팝업 배너
		fnAmplitudeEventMultiPropertiesAction(''+ampeventid+'','','')
		popupLayer(lyrId)
	}
}
function handleClickBtn(url){
	<% if isapp = 1 then %>
	<% else %>
		window.location.href = url
	<% end if %>
}
function popupLayer(lyrId){
	$("#"+lyrId).show();
}
function jsEventLogin(){
<% if isApp="1" then %>
	calllogin();
<% else %>
	top.location.href = "/login/login.asp?backpath=<%=Server.URLencode(request.serverVariables("SCRIPT_NAME")&"?"&Request.ServerVariables("QUERY_STRING")) %>";
<% end if %>
	return;
}

function eventClicKBanner(isapp, link, actionEvent, actionEventProperty, actionEventPropertyValue){
	if(isapp == 1){
		fnAmplitudeEventMultiPropertiesAction(actionEvent, actionEventProperty, actionEventPropertyValue, function(bool){if(bool) {fnAPPpopupEvent_URL('http://m.10x10.co.kr/apps/appcom/wish/web2014'+link);return false;}});
	}else{
		fnAmplitudeEventMultiPropertiesAction(actionEvent, actionEventProperty, actionEventPropertyValue)
		window.location.href = link
	}	
}
</script>
<%
	Dim img , link , altname, categoryOptions, categoryArr, isTargetCategory, i, idx, channel, bannerType, couponidx, layerId
	dim maincopy, subcopy, btnFlag, buttonCopy, buttonUrl, couponInfo, couponVal, couponMin

	For intI = 0 To ubound(arrlist,2)

		categoryOptions = arrlist(7,intI)
		catecode = arrlist(8,intI)
		idx = arrlist(9,intI)
		isTargetCategory = false

		if categoryOptions <> "" Then
			categoryArr = split(categoryOptions, ",")
			for i=0 to ubound(categoryArr) - 1
				if categoryArr(i) = catecode Then
					isTargetCategory = true
					exit for
				end if
			next
		else
			isTargetCategory = true
		end if
		If isTargetCategory Then '카테고리 체크
			img				= staticImgUrl & "/main/" + db2Html(arrlist(0,intI))
			link			= db2Html(arrlist(1,intI))
			altname			= db2Html(arrlist(4,intI))
			bannerType		= arrlist(10,intI) '1: 링크배너 / 2: 쿠폰배너 / 3: 레이어팝업배너
			couponidx		= arrlist(12,intI)
			maincopy 		= arrlist(13,intI) '메인 카피
			subcopy 		= arrlist(14,intI) '서브 카피
			btnFlag 		= arrlist(15,intI) '버튼 유무
			buttonCopy 		= arrlist(16,intI) '버튼 카피
			buttonUrl 		= arrlist(17,intI) '버튼 렌딩
			layerId			= "lyrCoupon" & idx
			'0 : white
			'1 : red
			'2 : vip
			'3 : vip gold
			'4 : vvip

			'// 배너타입이 쿠폰발급 일 경우 해당 쿠폰을 받은 사용자는 배너 노출을 시키지 않는다.
			If bannerType = "2" And IsUserLoginOK Then
				Dim monthAppCouponCode
				IF application("Svr_Info") = "Dev" THEN
					monthAppCouponCode = "2949"
				Else
					monthAppCouponCode = "1190"
				End If
				sqlStr = " SELECT * FROM db_user.dbo.tbl_user_coupon WITH(NOLOCK) "
				sqlStr = sqlStr & " WHERE userid='"&getLoginUserid&"' "
				sqlStr = sqlStr & " AND masteridx = '"&couponidx&"' "
				sqlStr = sqlStr & " AND masteridx <> 0 "
				If trim(couponidx) = monthAppCouponCode Then '// 월별 앱쿠폰일경우만 조건 실행
					sqlStr = sqlStr & " AND GETDATE() BETWEEN startdate AND expiredate  "
				End If
				rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly
				If not(rsget.bof) Then
					checkCouponIssue = True
				End If
				rsget.close
			End If			
			
			'다이어리 프로모션 쿠폰 띠배너 특정 아이템만 노출
			If intI = 0 AND date() > "2019-11-12" AND date() < "2019-12-11" AND (vitemid = 2488134 OR vitemid = 2110036 OR vitemid = 2510594 OR vitemid = 2209032 OR vitemid = 2542576 OR vitemid = 2512750 OR vitemid = 2523735) Then
				Select Case vitemid
					case 2488134 '미미
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_02.jpg"					
					case 2110036 '유아
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_03.jpg"
					case 2510594 '효정
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_01.jpg"
					case 2209032 '지호
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_05.jpg"
					case 2542576 '비니
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_06.jpg"
					case 2512750 '승희
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_04.jpg"
					case 2523735 '아린
						img = "http://webimage.10x10.co.kr/fixevent/event/2019/98339/m/bnr_evt_07.jpg"
				end select
				altname = "오마이걸의 픽 이벤트 참여하러 가기"
%>
				<div onclick="eventClicKBanner('<%=isapp%>','/event/eventmain.asp?eventid=98339', 'click_event_move_bnr', '98339', 'vitemid');"><img src="<%=img%>" alt="<%=altname%>"></div>
<%
			Else
			%>
				<% If Not(checkCouponIssue) Then '// 쿠폰 이벤트일 경우 쿠폰을 발급 받았으면 표시하지 않음%>		
					<div class="bnr-mkt1" onclick="handleClicKBanner('<%=isapp%>','<%=link%>', '<%=bannerType%>', '<%=couponidx%>', '<%=layerId%>', 'click_marketing_top_bnr');"><img src="<%=img%>" alt="<%=altname%>"></div>
					<div class="lyr-coupon" id="<%=layerId%>" onclick="ClosePopLayer();">
						<div class="inner">
							<h2><%=maincopy%></h2>
							<button type="button" class="btn-close btn-close1">닫기</button>
							<%
								if bannerType = "2" then
								couponInfo = getCouponInfo(couponidx)
									if IsArray(couponInfo) then
										for i=0 to ubound(couponInfo,2)
											couponVal = formatNumber(couponInfo(1, i), 0)
											couponMin = formatNumber(couponInfo(3, i), 0)
										next
							%>						
							<div class="cpn">
								<img src="//fiximage.10x10.co.kr/m/2019/common/bg_cpn.png" alt="">
								<p class="amt"><b><%=couponVal%></b>원</p>
								<% if couponMin <> "0" and couponMin <> "" then%><p class="txt1"><b><%=couponMin%></b>원 이상 구매 시 사용 가능</p><% end if %>
							</div>
							<% 
									end if
								end if 
							%>
							<p class="txt2"><%=subcopy%></p>
							<div class="btn-area">
								<button type="button" class="btn-close btn-close2">닫기</button>
								<% if btnFlag = "1" then %><button type="button" onclick="handleClickBtn('<%=buttonUrl%>');" class="btn-down"><%=buttonCopy%></button><% end if %>
							</div>
						</div>
					</div>
				<% End If %>
			<%
			End if
		End if
	Next
%>
<%
End If
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->