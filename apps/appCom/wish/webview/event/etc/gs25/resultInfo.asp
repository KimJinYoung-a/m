<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description : GS25 NFC 응모 결과 확인
' History : 2014.07.24 허진원 생성
'###########################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/rndSerial.asp" -->
<%
	Dim vUidx, vName, vHp, vStat, vDiv
	Dim vResult, chkErr, sqlStr
	chkErr = False
	
	vUidx = requestcheckvar(request("uid"),10)
	vResult = getNumeric(requestcheckvar(request("rst"),1))

	vUidx = rdmSerialDec(vUidx)

	if vUidx="" then chkErr=True
	if vResult="" then chkErr=True

	if chkErr then
		Call Alert_Move("파라메터 오류입니다.","/apps/appcom/wish/webview/event/etc/gs25/")
		dbget.close() : Response.End
	end if

	'// 응모자 정보 확인
	sqlStr = "Select name,hp,stat,div From db_temp.dbo.tbl_gs25nfcInfo where idx='" & vUidx & "'"
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) then
		vName = rsget("name")
		vHp = rsget("hp")
		vStat = rsget("stat")
		vDiv = rsget("div")
	else
		chkErr=True
	end if
	rsget.Close

	if chkErr then
		Call Alert_Move("처리중 오류가 발생했습니다.(2)","/apps/appcom/wish/webview/event/etc/gs25/")
		dbget.close() : Response.End
	end if

	'// 응모결과에 따른 분류 (rst= 1:모바일쿠폰 발급, 2:한정종료, 3:디바이스 중복, 4:휴대폰번호 중복, 9:기타오류)
	if vStat="0" then
		Select Case vResult
			Case "1"
				'바나나맛 우유 당첨 처리
				sqlStr = "Update db_temp.dbo.tbl_gs25nfcInfo Set stat='1', div='G', lastUpdate=getdate() Where idx=" & vUidx
				dbget.execute(sqlStr)
	
			Case "2"
				'텐바이텐 보너스쿠폰 발급 (바나나 한정 종료시)
				dim cpIdx, cpAuth
				sqlStr = "select top 1 idx, authodata " & vbCrLf
				sqlStr = sqlStr & "from db_eventdata.dbo.tbl_coupon2coupondata " & vbCrLf
				sqlStr = sqlStr & "where couponmasteridx=620 " & vbCrLf
				sqlStr = sqlStr & "	and userid is null " & vbCrLf
				sqlStr = sqlStr & "	and ssnkey is null"
				rsget.Open sqlStr,dbget,1
				if Not(rsget.EOF or rsget.BOF) then
					cpIdx = rsget("idx")
					cpAuth = rsget("authodata")
				end if
				rsget.Close
	
				if cpIdx<>"" then
					'당첨 처리
					sqlStr = "Update db_temp.dbo.tbl_gs25nfcInfo Set stat='1', div='C', cpAuthNo='" & cpAuth & "', lastUpdate=getdate() Where idx=" & vUidx
					dbget.execute(sqlStr)
	
					'쿠폰 발급 처리(ssnkey에 기록)
					sqlStr = "Update db_eventdata.dbo.tbl_coupon2coupondata Set ssnkey='" & vUidx & "' Where idx=" & cpIdx
					dbget.execute(sqlStr)
	
					'고객에게 SMS 쿠폰번호 전달
					sqlStr = "Insert into [db_sms].[ismsuser].em_tran(tran_phone, tran_callback, tran_status, tran_date, tran_msg ) values " &_
							" ('" & vHp & "'" &_
							" ,'1644-6030','1',getdate()" &_
							" ,'[텐바이텐] 쿠폰 등록 번호" & vbCrLf & cpAuth & vbCrLf & "등록하기: http://bit.ly/10x10mc')"
					dbget.execute(sqlStr)
				else
					Call Alert_Move("처리중 오류가 발생했습니다.(4)","/apps/appcom/wish/webview/event/etc/gs25/")
					dbget.close() : Response.End
				end if
	
			Case "3"
				'디바이스 중복
				Call Alert_Move("이미 이벤트에 참여하셨습니다.\n한 기기당 1회만 참여하실 수 있습니다.(2)","/apps/appcom/wish/webview/event/etc/gs25/")
				dbget.close() : Response.End
	
			Case "5","4"
				'휴대폰번호 중복
				Call Alert_Move("이미 이벤트에 참여하셨습니다.\n한 개의 휴대폰 번호 당 1회만 참여하실 수 있습니다.(3)","/apps/appcom/wish/webview/event/etc/gs25/")
				dbget.close() : Response.End
	
			Case Else
				Call Alert_Move("처리중 오류가 발생했습니다.(3)"&vResult,"/apps/appcom/wish/webview/event/etc/gs25/")
				dbget.close() : Response.End
		End Select
	elseif vStat="1" then
		Select Case vDiv
			Case "G"
				vResult = "1"
			Case "C"
				vResult = "2"
		End Select
	end if
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.bananaMilk {position:relative;}
.bananaMilk img {width:100%; vertical-align:top;}
.bananaMilk p {max-width:100%;}
.bananaMilk section {display:block; margin:0; padding:0;}
.bananaMilk .celebration {position:relative;}
.bananaMilk .celebration .deco {position:absolute; top:5%; left:0; width:100%;}
.bananaMilk .celebration .mobileNum {position:absolute; bottom:24.5%; left:0; width:100%;}
.bananaMilk .celebration .mobileNum strong {display:block; position:absolute; top:15%; left:35%; width:36.458333%; color:#fdffbf; font-size:19px; font-style:italic; line-height:1.5em; text-align:center;}
@media all and (max-width:480px){
	.bananaMilk .celebration .mobileNum strong {top:12%; font-size:13px;}
}
@media all and (min-width:768px){
	.bananaMilk .celebration .mobileNum strong {font-size:24px;}
}
.bananaMilk .celebrationB .deco {position:absolute; top:13%;}
.bananaMilk .celebrationB .mobileNum {bottom:30%;}
.bananaMilk .celebrationB .btnGo {position:absolute; bottom:17.5%; left:0; width:100%; padding:0 13.125%; box-sizing:border-box; -moz-box-sizing:border-box; -webkit-box-sizing:border-box;}
.bananaMilk .snsArea {padding-bottom:8%; background-color:#56a38c;}
.bananaMilk .snsArea .spread {overflow:hidden; text-align:center;}
.bananaMilk .snsArea .spread a {padding:0 4%;}
.bananaMilk .snsArea .spread a img {width:15.625%;}
.animated {-webkit-animation-duration:5s; animation-duration:5s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity: 0;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity: 0;}
}
.flash {-webkit-animation-name:flash; animation-name:flash;}
</style>
<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">
function kakaosendcall(){
	kakaosendNFC();
}

function kakaosendNFC(){
	var url =  'http://bit.ly/10x10nfc';
	kakao.link("talk").send({
		msg : "텐바이텐 APP 다운받고 바나나맛 우유도 받자!",
		url : url,
		appid : "m.10x10.co.kr",
		appver : "2.0",
		appname : "텐바이텐",
		type : "link"
	});
}
</script>
</head>

<body class="event">
	<!-- wrapper -->
	<div class="wrapper">    
		<!-- #content -->
		<div id="content">
			<!-- 텐바이텐 앱 다운받고 바나나맛 우유 받으세요! -->
				<div class="bananaMilk">
					<section>
				<%
					'### 바나나맛 우유 당첨
					if vResult="1" then
				%>
						<div class="celebration celebrationA">
							<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_celebration_bananamilk.gif" alt="축하합니다! 바나나맛 우유로 교환할 수 있는 모바일 쿠폰에 당첨되셨습니다." /></h1>
							<div class="deco animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/img_deco.png" alt="" /></div>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/img_visual_bananamilk.jpg" alt="바나나맛 우유" /></div>
							<p class="mobileNum">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_send.png" alt="응모하신 번호로 모바일 쿠폰이 전송 되었습니다." />
								<strong><%=vHp%></strong>
							</p>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_becareful.gif" alt="모바일 쿠폰은 응모 내역이 없는 다른 번호로 재전송이 불가합니다. 발송된 SMS를 안전하게 저장해주세요." /></p>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_bananamilk_friend.gif" alt="바나나맛 우유, 친구도 함께 받자!" /></p>
						</div>
				<%
					'### 3천원 쿠폰 / 우유메모지 당첨
					elseif vResult="2" then
				%>
						<div class="celebration celebrationB">
							<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_celebration_coupon.gif" alt="오늘의 바나나맛 우유가 모두 소진되었습니다. 바나나맛 우유처럼 달콤한 텐바이텐 쿠폰을 선물로 드립니다!" /></h1>
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/img_visual_coupon.jpg" alt="만원이상 구매시 사용 가능한 삼천원 할인쿠폰" /></div>
							<p class="mobileNum">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_send_coupon.png" alt="응모하신 번호로 쿠폰 등록이 가능한 핀번호가 전송되었습니다." />
								<strong><%=vHp%></strong>
							</p>
							<div class="btnGo"><a href="/apps/appcom/wish/webview/my10x10/changecoupon.asp"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/btn_go_coupon.png" alt="쿠폰 등록하러 가기" /></a></div>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_tentencoupon_friend.gif" alt="텐바이텐 쿠폰, 친구도 함께 받자!" /></p>
						</div>
				<%
					end if
				%>
						<div class="snsArea">
						<%
							dim snpTitle, snpLink, snpPre, snpTag, snpImg
							snpTitle = Server.URLEncode("텐바이텐 APP 다운받고 바나나맛 우유도 받자!")
							snpLink = Server.URLEncode("http://bit.ly/10x10nfc")
							snpPre = Server.URLEncode("텐바이텐")
							snpImg = Server.URLEncode("http://webimage.10x10.co.kr/eventIMG/2014/53715/img_visual_app.jpg")

							'기본 태그
							snpTag = Server.URLEncode("#텐바이텐 #바나나맛우유")
						%>
							<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/txt_sns.gif" alt="아래 SNS를 통해 친구에게도 이벤트를 알려주세요." /></p>
							<div class="spread">
								<a href="" onclick="kakaosendcall(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/ico_sns_kakao.png" alt="카카오톡" /></a>
								<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/ico_sns_facebook.png" alt="페이스북" /></a>
								<a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag%>');return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53715/ico_sns_twitter.png" alt="트위터" /></a>
							</div>
						</div>
					</section>
				</div>
				<!-- //텐바이텐 앱 다운받고 바나나맛 우유 받으세요! -->
		</div><!-- #content -->

		<!-- #footer -->
		<footer id="footer">
			
		</footer><!-- #footer -->

	</div><!-- wrapper -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->