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
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%
'#######################################################
' Discription : MA_item_prd // cache DB경유
' History : 2018-01-17 이종화 생성
' 			2018-08-30 최종원 등급별 제품상세광고배너 노출
' 			2018-10-25 최종원 카테고리별 제품상세 광고배너 노출
'           2019-07-22 원승현 앱 전용 상품 상세 배너 노출
'#######################################################
Dim poscode , intI ,intJ
Dim sqlStr , rsMem , arrList
Dim CtrlDate : CtrlDate = now()
Dim limitcnt : limitcnt = 0 '//최대 배너 갯수
DIM userLevel, userOS

'카테고리정보
dim vitemid	: vitemid = requestCheckVar(request("itemid"),9)

''facebook 예외처리 2019/06/04 ex)?itemid=123123&targeturl=...&itemid=123123 
if InStr(vitemid,",")>0 then
	vitemid = LEFT(vitemid,InStr(vitemid,",")-1)
end if

dim catecode
userLevel = cstr(session("ssnuserlevel"))
userOS	  = flgDevice

dim oItem, ItemContent
set oItem = new CatePrdCls
oItem.GetItemData vitemid

'// 상품코드 토스트 팝업 구분
Function fnGubunToastPopup(vItemid , evalyn)
	If IsNull(vItemid) Or vItemid="" Then Exit Function
	On Error Resume Next
	dim sqlStr , gubuncode : gubuncode = ""
	dim CheckGetSellingTime : CheckGetSellingTime = checkrealtimeitem(vItemid)
	sqlStr = "SELECT gubun FROM db_temp.dbo.tbl_toastpopup_itemid WHERE ItemID ='"& CStr(vItemid) &"'"
	rsget.CursorLocation = adUseClient
	rsget.CursorType=adOpenStatic
	rsget.Locktype=adLockReadOnly
	rsget.Open sqlStr, dbget

	if CheckGetSellingTime > 0 then gubuncode = "selling"
	If evalyn = "Y" Then gubuncode = "eval"
	
	If Not(rsget.bof Or rsget.eof) Then
		Do until rsget.EOF
			gubuncode = rsget("gubun")
			rsget.movenext
		Loop 
	End If
	rsget.close

	If gubuncode = "weekly" Then 
		fnGubunToastPopup = "<div class=""toast-1""><p>이번주 난리난 베스트 상품 👍</p></div>"
	ElseIf gubuncode = "mdpick" Then 
		fnGubunToastPopup = "<div class=""toast-1""><p>텐바이텐 MD가 적극 추천합니다 😍</p></div>"
	ElseIf gubuncode = "eval" Then 
		fnGubunToastPopup = "<div class=""toast-1""><p>후기가 증명한 상품! (✪‿✪)ノ</p></div>"
	elseif gubuncode = "selling" then
		fnGubunToastPopup = "<div class=""toast-1""><p>"& Gettimeset(CheckGetSellingTime) &" 판매된 상품! 🎁</p></div>"
	End If 
	On Error goto 0
End Function

Dim Existeval : Existeval = chkiif(oItem.Prd.FEvalCnt >= 100 And fnEvalTotalPointAVG(oItem.Prd.Fpoints,"") > 90,"Y","N")

function checkrealtimeitem(vItemid)
	If IsNull(vItemid) Or vItemid="" Then Exit Function
	On Error Resume Next
	dim sqlStr , selldate : selldate = ""
	dim sellingtimeset
	dim MyDate : MyDate = now()
	dim objConn, objCmd, rs

	set objConn = CreateObject("ADODB.Connection")
	objConn.Open Application("db_main") 
	Set objCmd = Server.CreateObject ("ADODB.Command")	

	sqlStr = " SELECT selldate FROM db_temp.dbo.tbl_app_realtime_sell_items WHERE ItemID = ? "

	objCmd.ActiveConnection = objConn
	objCmd.CommandType = adCmdText
	objCmd.CommandText = sqlStr

	objCmd.Parameters.Append(objCmd.CreateParameter("itemid",adchar, adParamInput, Len(vItemid), vItemid))

	set rs = objCmd.Execute

	if  not rs.EOF  then
		selldate = rs("selldate")
	End if		
	
	objConn.Close
	SET objConn = Nothing	

	checkrealtimeitem = DateDiff("s", selldate, MyDate)
	On Error goto 0
end function 

'// 판매완료상품 시간
function Gettimeset(v)
	if v < 60 then
		Gettimeset = "조금전"
	elseif(v < 3600) then
		Gettimeset = int(v/60)&"분전"
	elseif(v < 86400) then
		Gettimeset = int(v/3600)&"시간전"
	end if
end function

poscode = 739

'//DB 시간 타이머 00시부터 00시 5분 사이에는 DB 캐쉬 1분에 한번 읽기
Dim cTime , dummyName
If timer > 10 And Cint(timer/60) < 6 Then
	cTime = 60*1
	dummyName = "WPIMG2_"&Cint(timer/60)
Else
	cTime = 60*1
	dummyName = "WPIMG2"
End If

IF poscode = "" THEN
	Call Alert_Return("잘못된 접근입니다.")
	response.End
END IF

Dim topcnt : topcnt = 1

sqlStr = " EXEC [db_sitemaster].[dbo].[usp_ten_banners_get] '" & topcnt & "', '"& poscode &"', '"& vitemid &"', '" & userLevel & "', '" & userOS & "', '' "

'Response.write sqlStr &"<br/>"

set rsMem = getDBCacheSQL(dbget, rsget, dummyName, sqlStr, cTime)
IF Not (rsMem.EOF OR rsMem.BOF) THEN
	arrList = rsMem.GetRows
END IF
rsMem.close

on Error Resume Next
If IsArray(arrList) Then
	If (request.Cookies("catePrdLowBannerMA2") <> "done" or request.Cookies("catePrdLowBannerMA2")="") Then
		Dim img , link , altname, categoryOptions, categoryArr, isTargetCategory, i, idx, priorityFlag, channel, bannerType, couponidx, layerId
		dim maincopy, subcopy, btnFlag, buttonCopy, buttonUrl, couponInfo, couponVal, couponMin, checkCouponIssue
		checkCouponIssue = False
		
		For intI = 0 To ubound(arrlist,2)

			categoryOptions = arrlist(7,intI)
			catecode = arrlist(8,intI)
			idx = arrlist(9,intI)
			priorityFlag = true
			isTargetCategory = false

			if ubound(arrlist,2) > 0 and categoryOptions = "" Then
				priorityFlag = false
			end if		

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

			If CDate(CtrlDate) >= CDate(arrlist(2,intI)) AND CDate(CtrlDate) <= CDate(arrlist(3,intI)) and isTargetCategory Then

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
	%>
			<% If Not(checkCouponIssue) Then '// 쿠폰 이벤트일 경우 쿠폰을 발급 받았으면 표시하지 않음%>	
			<script>
				// 하단 기획전 배너 (20180319)
				function setPopupCookie( name, value, expiredays ) {
					var todayDate = new Date();
					todayDate = new Date(parseInt(todayDate.getTime() / 86400000) * 86400000 + 54000000);
					if (todayDate > new Date() ) {
						expiredays = expiredays - 1;
					}
					todayDate.setDate( todayDate.getDate() + expiredays );
					document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
				}
				function bannerCloseToSevenDay(){	//오늘 하루 보지 않기
					setPopupCookie("catePrdLowBannerMA2", "done", 1)
					<% ' 18주년 세일 기간 동안 하단 배너 클래스 변경
					'If date() > "2019-09-30" AND date() < "2019-11-01" Then 
					'2019-11-13 이후로 18주년 배너와 동일하게 사이즈 및 에니메이션 변경. 혹시 다시 되돌릴 수 있어서 Else 구문 남겨둠. (JIRA : MKTEVTPJT1-337)
                	If date() > "2019-11-12" Then 
					%>
						$(".bnr-anniv18").hide();
					<% Else %>
						$(".bnr-evtV19").hide();
					<% End If %>
					fnAmplitudeEventMultiPropertiesAction('click_marketing_bnrClose','','');
				}
			</script>
				<%'2019-11-13 이후로 18주년 배너와 동일하게 사이즈 및 에니메이션 변경. 변경 전 class: 'bnr-evtV19 evt-toast2' (JIRA : MKTEVTPJT1-337)%>
					<div class="bnr-anniv18">
						<div onclick="handleClicKBanner('<%=isapp%>','<%=link%>', '<%=bannerType%>', '<%=couponidx%>', '<%=layerId%>', 'click_marketing_bnr');"><img src="<%=img%>" alt="<%=altname%>"></div>
						<button class="btn-close" onclick="bannerCloseToSevenDay();"><img src="//fiximage.10x10.co.kr/m/2019/temp/btn_close.png" alt="오늘 하루 보지 않기"></button>
					</div>			
					<div class="lyr-coupon" id="<%=layerId%>">
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
			<%
				End If
			End if
		Next
	End If
%>
<% Else %>
	<%' 토스트 팝업 2018-08-09 이종화 %>
		<%=fnGubunToastPopup(vitemid , Existeval)%>
	<%' 토스트 팝업 2018-08-09 이종화 %>
<%
End If
Set oItem = Nothing
on Error Goto 0
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->