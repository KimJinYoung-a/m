<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'###############################################
' Discription : BETWEEN 공통 함수 / 세션 처리
' History : 2014.04.17 허진원 : 신규 생성
'###############################################

'+------------------------------------------+-------------------------------------------------------------------+
'|                함 수 명                  |                              기     능                            |
'+------------------------------------------+-------------------------------------------------------------------+
'| fnGetUserInfo(vItem)                     | 나의 비트윈 정보 접수(vItem:ID,Name,Sex,Birth,tenId,tenSn,tenLv)  |
'+------------------------------------------+-------------------------------------------------------------------+
'| fnGetPartnerInfo(vItem)                  | 파트너 비트윈 정보 접수 (vItem:ID,Name,Sex,Birth)                 |
'+------------------------------------------+-------------------------------------------------------------------+
'| fnGetAnniversary(vItem)                  | 기념일 정보 접수 (vItem:First,Wedding)                            |
'+------------------------------------------+-------------------------------------------------------------------+
'| GetBetweenCartCount()                  	| 비트윈용 장바구니 담긴 갯수                                       |
'+------------------------------------------+-------------------------------------------------------------------+
'| SetBetweenCartCount()                  	| 비트윈용 장바구니 갯수 세팅 			                            |
'+------------------------------------------+-------------------------------------------------------------------+
'| getIsTenLogin()                          | 텐바이텐 로그인 여부                                              |
'+------------------------------------------+-------------------------------------------------------------------+
'| getIsTodayAnniv(dt)                      | 오늘이 기념일인지 여부 (윤년계산)                                 |
'+------------------------------------------+-------------------------------------------------------------------+
'| getTermAnniv(dt)                         | 다음 기념일까지 남은 날 수                                        |
'+------------------------------------------+-------------------------------------------------------------------+
'| getAnniversary(dt)                       | 올해 기준으로 기념일 날짜 반환                                    |
'+------------------------------------------+-------------------------------------------------------------------+

	Dim btwToken, btwUserid, chkWebTest
	Dim CGLBAppName: CGLBAppName="betweenshop"

	btwToken = session("btwToken")
	btwUserid = session("btwUserid")
	chkWebTest = false
	'세션 확인 및 접수
	if session("tenUserSn")="" then
		'전송값 확인(POST Data)
		btwToken = Request.form("gift_token")
		btwUserid = Request.form("user_id")

		if not(btwToken="" or btwUserid="") then
			session("btwToken") = btwToken
	 		session("btwUserid") = btwUserid

			'비트윈에서 정보 접수 및 세션 처리
			Call getBetweenUserInfo(btwToken,btwUserid)
		else
			Call fnErrMsg("900")
			response.End
		end if
	end if

	'회원 정보 접수
	Function fnGetUserInfo(vItem)
		Select Case uCase(vItem)
			Case "ID"
				fnGetUserInfo = session("MyUserid")
			Case "NAME"
				fnGetUserInfo = session("MyName")
			Case "SEX"
				fnGetUserInfo = session("MyGender")
			Case "BIRTH"
				fnGetUserInfo = session("MyBirthday")
			Case "TENID"
				fnGetUserInfo = session("tenUserid")		'텐바이텐 회원ID
			Case "TENSN"
				fnGetUserInfo = session("tenUserSn")		'비트윈 매칭 회원일련번호(주문서 작성용)
			Case "TENLV"
				fnGetUserInfo = session("tenUserLv")		'텐바이텐 회원 등급 (주문서 작성용)
		End Select
	End Function

	'파트너 정보 접수
	Function fnGetPartnerInfo(vItem)
		Select Case uCase(vItem)
			Case "ID"
				fnGetPartnerInfo = session("partnerUserid")
			Case "NAME"
				fnGetPartnerInfo = session("partnerName")
			Case "SEX"
				fnGetPartnerInfo = session("partnerGender")
			Case "BIRTH"
				fnGetPartnerInfo = session("partnerBirthday")
		End Select
	End Function

	'기념일 정보 접수
	Function fnGetAnniversary(vItem)
		Select Case uCase(vItem)
			Case "FIRST"
				fnGetAnniversary = session("firstMeetDay")
			Case "WEDDING"
				fnGetAnniversary = session("weddingDay")
		End Select
	End Function

'2014-11-18 김진영 테스트 APK용 토큰 및 UserID 시작
	Public MessageUsingToken
	Public MessageUsingUserid
	MessageUsingToken = Request.form("gift_token")
	MessageUsingUserid = Request.form("user_id")
	
	if not(MessageUsingToken="" or MessageUsingUserid="") then
		session("MessageUsingToken") = MessageUsingToken
		session("MessageUsingUserid") = MessageUsingUserid
	End If
'2014-11-18 김진영 테스트 APK용 토큰 및 UserID 끝

	'########################## 나와 사용자 정보 받기 ###########################################
	Sub getBetweenUserInfo(weentoken, weenid)
		Dim betweenAPIURL, objXML, iRbody, jsResult
		Dim obj1, i, obj2, obj3, Errmsg
		Dim vTenId, vTenSn, vTenLv, vCartNo
		if chkWebTest then
			betweenAPIURL = "https://between-gift-dummy.vcnc.co.kr/api/users/"
		else
			IF application("Svr_Info")="Dev" THEN
				betweenAPIURL = "http://test-tokyo-between-gift.mintnote.com/api/users/"
			else
				betweenAPIURL = "https://between-gift-shop.vcnc.co.kr/api/users/"
			end if
		end if

		on Error Resume Next

		Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
		    objXML.Open "GET", betweenAPIURL&weenid , False
			objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			objXML.SetRequestHeader "Authorization","between-gift " & weentoken
			objXML.Send()
			iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
	
			if objXML.Status<>"200" then
				Call fnErrMsg(objXML.Status)
				response.End
				Exit Sub
			end if
			
			If objXML.Status = "200" Then
				Set jsResult = JSON.parse(iRbody)
					set obj1 = jsResult.data
						'// 나의 정보
						session("MyGender")			= left(obj1.user.gender,1)
						session("MyUserid")			= obj1.user.id
						session("MyName")			= obj1.user.name

						'// 파트너 정보
						session("partnerGender")	= left(obj1.partner.gender,1)
						session("partnerUserid")	= obj1.partner.id
						session("partnerName")		= obj1.partner.name
	
						'//기념일 JSON 파싱
						set obj2 = obj1.anniversaries
							For i=0 to obj2.length-1
								Select Case obj2.get(i).type
									Case "USER_BIRTHDAY"			'나와 파트너의 생일
										If obj2.get(i).birthday_user_id = session("MyUserid") Then
											'나의 생일
											session("MyBirthday") = Left(obj2.get(i).date, 10)
										ElseIf obj2.get(i).birthday_user_id = session("partnerUserid") Then
											'파트너 생일
											session("partnerBirthday") = Left(obj2.get(i).date, 10)
										End If

									Case "DAY_WE_FIRST_MET"			'처음 만난날
										session("firstMeetDay") = Left(obj2.get(i).date, 10)

									Case "WEDDING_ANNIVERSARY"		'결혼기념일
										session("weddingDay") = Left(obj2.get(i).date, 10)
								End Select
							Next
						set obj2 = nothing

						'// 사용자 정보 저장
						Call fnSaveBtwUserInfo(session("MyUserid"), session("MyGender"), session("partnerUserid"), session("partnerGender"), vTenId, vTenSn, vTenLv, vCartNo)
						if vTenSn<>"" then
							session("tenUserid") = vTenId
							session("tenUserSn") = vTenSn
							session("tenUserLv") = vTenLv
							session("cartCnt") = vCartNo
						end if
					set obj1 = Nothing
				Set jsResult = Nothing
			End If
		Set objXML = Nothing
		On Error Goto 0
	End Sub
	'############################################################################################

	'############################################################################################
	Sub sendBetweenItem(weentoken, weenid, iurl_link, icontent, ibutton_text, isendImg)
		Dim betweenAPIURL, objXML, iRbody, jsResult
		Dim obj1, i, obj2, obj3, Errmsg, strParam, issuccess
		betweenAPIURL = "https://between-gift-shop.vcnc.co.kr/api/messages/"
		on Error Resume Next
		strParam = "url=https://m.10x10.co.kr/apps/appCom/between"&iurl_link&"&content="&icontent&"&button_text="&ibutton_text&"&image="&isendImg
		Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
'		    objXML.Open "POST", betweenAPIURL&weenid , False
'			objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
'			objXML.SetRequestHeader "Authorization","between-gift " & weentoken

		    objXML.Open "POST", betweenAPIURL&session("MessageUsingUserid") , False
			objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			objXML.SetRequestHeader "Authorization","between-gift " & session("MessageUsingToken")
			objXML.Send(strParam)
			iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
			if objXML.Status<>"200" then
				Call fnErrMsg(objXML.Status)
				response.End
				Exit Sub
			end if

			If objXML.Status = "200" Then
				Set jsResult = JSON.parse(iRbody)
					issuccess	= jsResult.data
				Set jsResult = Nothing

				If issuccess <> True Then
					Call fnErrMsg("800")
					response.End
				End If
			else
				Call fnErrMsg(objXML.Status)
				response.End
			End If
		Set objXML = Nothing
	End Sub

	'########################### 토큰 받기 (임시) ####################################################
	Sub getToken(byRef vToken, byRef vUid)
		Dim betweenAPIURL, betweenAuthNo, jsResult
		Dim objXML, xmlDOM, iRbody
			betweenAPIURL = "https://between-gift-dummy.vcnc.co.kr/token/issue"
			On Error Resume Next
				Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
				    objXML.Open "GET", betweenAPIURL , False
					objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
					objXML.Send()
					iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
					If objXML.Status = "200" Then
						Set jsResult = JSON.parse(iRbody)
							vToken	= jsResult.data.gift_token
							vUid	= jsResult.data.user_id
						Set jsResult = Nothing
					else
						Call fnErrMsg(objXML.Status)
						response.End
					End If
				Set objXML = Nothing
			On Error Goto 0
	End Sub

	'// 사용자 정보 저장
	Sub fnSaveBtwUserInfo(byVal btwUid, byVal btwSex, byVal ptnUid, byVal ptnSex, byRef tenUid, byRef tenUSn, byRef tenULv, byRef cartNo)
		Dim sqlStr, chkUid
		
		if btwUid="" or isNull(btwUid) then Exit Sub
		
		'존재여부 확인
		sqlStr = "Select top 1 isNull(userid,'') as userid, userSn "
		sqlStr = sqlStr & "From db_etcmall.dbo.tbl_between_userinfo "
		sqlStr = sqlStr & "Where btwUserCd='" & btwUid & "'"
		rsget.Open sqlStr,dbget,1
		if Not(rsget.EOF or rsget.BOF) then
			chkUid = rsget("userid")
			tenUSn = cStr(rsget("userSn"))
		else
			chkUid = null
		end if
		rsget.Close

		'// 데이터 처리
		if isNull(chkUid) then
			'#신규 저장
			sqlStr = "Insert Into db_etcmall.dbo.tbl_between_userinfo "
			sqlStr = sqlStr & " (btwUserCd, gender, ptnUserCd, ptnGender) values "
			sqlStr = sqlStr & "('" & btwUid & "'"
			sqlStr = sqlStr & ",'" & btwSex & "'"
			sqlStr = sqlStr & ",'" & ptnUid & "'"
			sqlStr = sqlStr & ",'" & ptnSex & "')"
			dbget.Execute(sqlStr)

			sqlStr = "Select IDENT_CURRENT('db_etcmall.dbo.tbl_between_userinfo') as idx "
			rsget.Open sqlStr,dbget,1
				tenUSn = rsget("idx")
			rsget.close
		else
			'텐바이텐 아이디 처리
			tenUid = chkUid
		end if

		'텐바이텐 회원이라면 텐바이텐 회원등급 접수
		tenULv = "5"		'기본 어륀지
		if Not(tenUid="" or isNull(tenUid)) then
			sqlStr = "Select userlevel From db_user.dbo.tbl_logindata Where userid='" & tenUid & "'"
			rsget.Open sqlStr,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				tenULv = rsget("userlevel")
			end if
			rsget.close
		end if

		'장바구니 갯수 파악
		if tenUSn<>"" then
			sqlStr = "select count(*) as cnt "
			sqlStr = sqlStr & "from db_my10x10.dbo.tbl_my_baguni "
			sqlStr = sqlStr & "where userkey='BTW_USN_" & tenUSn & "' "
			sqlStr = sqlStr & "	and isLoginUser='N'"
			rsget.Open sqlStr,dbget,1
				cartNo = rsget("cnt")
			rsget.Close
		else
			cartNo = 0
		end if

	End Sub


	'// 텐바이텐 아이디 매칭정보 업데이트
	Sub fnUpdateTenUser(tenUid)
		Dim sqlStr, tenULv
		if session("MyUserid")="" then Exit Sub

		sqlStr = "Update db_etcmall.dbo.tbl_between_userinfo "
		sqlStr = sqlStr & "Set userid='" & tenUid & "' "
		sqlStr = sqlStr & "	,lastUpdate=getdate() "
		sqlStr = sqlStr & "Where btwUserCd='" & session("MyUserid") & "'"
		dbget.Execute(sqlStr)
	End Sub


	'// Response.Write + br
	Function rw(ByVal str)
		response.write str & "<br>"
	End Function 

	'// Call Error Msg
	Sub fnErrMsg(errcd)
		Dim errMsg
		Select Case errcd
			Case "401", "400", "404", "405"
				errMsg = "서비스 연결에 문제가 발생했습니다."
			Case "500"	errMsg = "서버에서 처리 중 문제가 발생하였습니다."
			Case "900"	errMsg = "접속시간 초과로 연결이 끊어졌습니다."
			Case "800"	errMsg = "상품 공유에 실패하였습니다"
			Case "999"	errMsg = "기타 오류가 발생했습니다."
		End Select

		if errMsg<>"" then
			Response.Write "<script type=""text/javascript"">"
			Response.Write "alert('" & errMsg & "');"
			Response.Write "window.location.href='between://gift-shop';"
			Response.Write "</script>"
		end if
	End Sub
	
	
	'// 장바구니 갯수 :
	Function GetBetweenCartCount()
	    dim tmp
	    GetBetweenCartCount = 0
	
	    tmp = session("cartCnt")
	
	    if (Not IsNumeric(tmp)) then Exit function
	
	    if tmp<1 then tmp = 0
	
	    GetBetweenCartCount = tmp
	End Function

	'// 장바구니 갯수세팅
	Sub SetBetweenCartCount(cartcount)
	    dim tmp
	    tmp = cartcount
	
	    if (Not IsNumeric(tmp)) then Exit Sub
	    if tmp<1 then tmp = 0
	
	    session("cartCnt") = tmp
	End Sub

	'// 텐바이텐 로그인 여부
	Function getIsTenLogin()
		getIsTenLogin = session("tenUserid")<>""
	End Function

	''EMail ComboBox
	function DrawEamilBoxHTML_App(frmName,txBoxName, cbBoxName,emailVal,classNm1,classNm2,jscript1,jscript2)
	    dim RetVal, i, isExists : isExists=false
	    dim eArr : eArr = Array("naver.com","netian.com","paran.com","hanmail.net","dreamwiz.com","nate.com" _
	                ,"empal.com","orgio.net","unitel.co.kr","chol.com","kornet.net","korea.com" _
	                ,"freechal.com","hanafos.com","hitel.net","hanmir.com","hotmail.com")
		emailVal = LCase(emailVal)
	
	    RetVal = "<input name='"&txBoxName&"' class='"&classNm1&"' type='text' value='' style='display:none;' "&jscript1&" />&nbsp;"
	    RetVal = RetVal & "<select name='"&cbBoxName&"' id='select3' class='"&classNm2&"' "&jscript2&" \>"
	    ''RetVal = RetVal & "<option value=''>메일선택</option>"
	    for i=LBound(eArr) to UBound(eArr)
	        if (eArr(i)=emailVal) then
	            isExists = true
	            RetVal = RetVal & "<option value='"&eArr(i)&"' selected>"&eArr(i)&"</option>"
	        else
	            RetVal = RetVal & "<option value='"&eArr(i)&"' >"&eArr(i)&"</option>"
	        end if
	    next
	
	    if (Not isExists) and (emailVal<>"") then
	        RetVal = RetVal & "<option value='"&emailVal&"' selected>"&emailVal&"</option>"
	    end if
	    RetVal = RetVal & "<option value='etc' >직접 입력</option>"
	    RetVal = RetVal & "</select>"
	
	    response.write RetVal
	
	end Function

	' 페이징 함수 <%=fnPaging_Apps(페이지파라미터, 토탈레코드카운트, 현재페이지, 페이지사이즈, 블럭사이즈) 앱용
	Function fnPaging_Apps(ByVal pageParam, ByVal iTotalCount, ByVal iCurrPage, ByVal iPageSize, ByVal iBlockSize)
	
		If iTotalCount = "" Then iTotalCount = 0
		Dim iTotalPage
		iTotalPage  = Int ( (iTotalCount - 1) / iPageSize ) + 1
		If iTotalCount = 0 Then	iTotalPage = 1
	
		Dim str, i, iStartPage
		Dim url, arr
		url = getThisFullURL()
		If InStr(url,pageParam) > 0 Then
			arr = Split(url, pageParam&"=")
			If UBOUND(arr) > 0 Then
				If InStr(arr(1),"&") Then
					url = arr(0) & Mid(arr(1),InStr(arr(1),"&")+1) & "&" & pageParam&"="
				Else
					url = arr(0) & pageParam&"="
				End If
			End If
		ElseIf InStr(url,"?") > 0 Then
			url = url & "&" &  pageParam & "="
		Else
			url = url & "?" &  pageParam & "="
		End If
		url = Replace(url,"?&","?")
	
		Dim imgPrev01, imgNext01, imgPrev02, imgNext02
		imgPrev01	= "&lt;"
		imgNext01	= "&gt;"
	
		' 시작페이지
		If (iCurrPage Mod iBlockSize) = 0 Then
			iStartPage = (iCurrPage - iBlockSize) + 1
		Else
			iStartPage = ((iCurrPage \ iBlockSize) * iBlockSize) + 1
		End If
	
		' 이전 Block으로 이동
		If (iCurrPage / iBlockSize) > 1 Then
			str = str & "<a href=""javascript:goPage(" & (iStartPage - iBlockSize) & ");"" class=""btn-prev"">" & imgPrev01 & "</a>"
		Else
			str = str & "<a href=""javascript:goPage(1);"" class=""btn-prev"">" & imgPrev01 & "</a>"
		End If
	
		' 페이지 Count 루프
		i = iStartPage
	
		Do While ((i < iStartPage + iBlockSize) And (i <= iTotalPage))
			If i > iStartPage Then str = str & ""
			If Int(i) = Int(iCurrPage) Then
				str = str & "<a href=""javascript:goPage(" & i & ");"" class=""current""><span>" & i & "</span></a>"
			Else
				str = str & "<a href=""javascript:goPage(" & i & ");"" class=""""><span>" & i & "</span></a>"
			End If
			i = i + 1
		Loop
	
		' 다음 Block으로 이동
		If (iStartPage+iBlockSize) < iTotalPage+1 Then
			str = str & "<a href=""javascript:goPage(" & i & ");"" class=""btn-next"">" & imgNext01 & "</a>"
		Else
			str = str & "<a href=""javascript:goPage(" & iTotalPage & ");"" class=""btn-next"">" & imgNext01 & "</a>"
		End If
	
		fnPaging_Apps	= str
	
	End function

	'// 송장 링크(app 외부 브라우저 호출)
	function GetSongjangURL(currST,dlvURL,songNo)
		if (currST<>"7") then
			GetSongjangURL = ""
			exit function
		end if
	
		if (dlvURL="" or isnull(dlvURL)) or (songNo="" or isnull(songNo)) then
			GetSongjangURL = "<span onclick=""alert('▷▷▷▷▷ 화물추적 불능안내 ◁◁◁◁◁\n\n고객님께서 주문하신 상품의 배송조회는\n배송업체 사정상 조회가 불가능 합니다.\n이 점 널리 양해해주시기 바라며,\n보다 빠른 배송처리가 이뤄질수 있도록 최선의 노력을 다하겠습니다.');"" style=""cursor:pointer;"">" & songNo & "</span>"
		else
			GetSongjangURL = "<span onclick=""openbrowser'" & db2html(dlvURL) & songNo & "');"">" & songNo & "</span>"
		end if
	end function

	'// 오늘이 기념일인지 확인(윤년 계산)
	function getIsTodayAnniv(dt)
		dim vDt(2), vAnnv
		getIsTodayAnniv = false
		if dt="" or isNull(dt) then Exit Function
		if len(dt)<>10 then Exit Function

		'vDt(0) = left(dt,4)
		vDt(0) = year(date)
		vDt(1) = mid(dt,6,2)
		vDt(2) = right(dt,2)
		vAnnv = dateSerial(vDt(0),vDt(1),vDt(2))
		if cInt(vDt(1))<>month(vAnnv) then
			vAnnv = dateSerial(vDt(0),vDt(1),vDt(2)-1)
		end if
		getIsTodayAnniv = (vAnnv=date)
	end function

	'// 기념일까지 남은 날 수
	function getTermAnniv(dt)
		dim vDt(2), vAnnv, vTgDt
		getTermAnniv = -1
		if dt="" or isNull(dt) then Exit Function
		if len(dt)<>10 then Exit Function

		'vDt(0) = left(dt,4)
		vDt(0) = year(date)
		vDt(1) = mid(dt,6,2)
		vDt(2) = right(dt,2)
		vAnnv = dateSerial(vDt(0),vDt(1),vDt(2))
		if cInt(vDt(1))<>month(vAnnv) then
			vAnnv = dateSerial(vDt(0),vDt(1),vDt(2)-1)
		end if
		if datediff("d",date,vAnnv)<0 then
			vAnnv = dateadd("yyyy",1,vAnnv)
		end if
		vTgDt = date
		getTermAnniv = datediff("d",vTgDt,vAnnv)
	end function

	'// 올해 기준으로 기념일 날짜 반환
	function getAnniversary(dt)
		dim vDt(2), vAnnv
		if dt="" or isNull(dt) then Exit Function
		if len(dt)<>10 then Exit Function

		vDt(0) = year(date)
		vDt(1) = mid(dt,6,2)
		vDt(2) = right(dt,2)
		vAnnv = dateSerial(vDt(0),vDt(1),vDt(2))
		if cInt(vDt(1))<>month(vAnnv) then
			vAnnv = dateSerial(vDt(0),vDt(1),vDt(2)-1)
		end if
		getAnniversary = vAnnv
	end function
%>