<%@ language=vbscript %>
<% option explicit %>
<%
'History : 2014.03.28 김진영 생성
'Description :  토큰 및 정보 호출..10분 유예기간이나 혹시나 해서 9분으로 설정
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'response.Charset="UTF-8"
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


	Sub getBetweenUserInfo(weentoken, weenid)
		Dim betweenAPIURL, objXML, iRbody, jsResult
		Dim obj1, i, obj2, obj3, Errmsg
		Dim vTenId, vTenSn, vTenLv, vCartNo
		betweenAPIURL = "https://between-gift-shop.vcnc.co.kr/api/users/"
		on Error Resume Next
		Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
		    objXML.Open "GET", betweenAPIURL&weenid , False
			objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			objXML.SetRequestHeader "Authorization","between-gift " & weentoken
			objXML.Send()
			iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")
			
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
											rw Left(obj2.get(i).date, 10)
										End If

									Case "DAY_WE_FIRST_MET"			'처음 만난날
										session("firstMeetDay") = Left(obj2.get(i).date, 10)

									Case "WEDDING_ANNIVERSARY"		'결혼기념일
										session("weddingDay") = Left(obj2.get(i).date, 10)
								End Select
							Next
						set obj2 = nothing
					set obj1 = Nothing
				Set jsResult = Nothing
			End If
		Set objXML = Nothing
		On Error Goto 0
	End Sub
'############################################################################################
Dim regtoken, reguserid

regtoken	= trim(Request.form("regtoken"))
reguserid	= trim(Request.form("reguserid"))
If trim(regtoken) <> "" AND Trim(reguserid) <> "" Then
	Call getBetweenUserInfo(regtoken,reguserid)
	rw "<hr>★ 내정보"
	rw "- 아이디 : " & fnGetUserInfo("id")
	rw "- 이름 : " & fnGetUserInfo("name")
	rw "- 성별 : " & fnGetUserInfo("sex")
	rw "- 생일 : " & fnGetUserInfo("birth")
	rw "- 텐바이텐 userid : " & fnGetUserInfo("tenId")
	rw "- 텐바이텐 회원등급 : " & fnGetUserInfo("tenLv")
	rw "- 텐바이텐 userSn : " & fnGetUserInfo("tenSn")
	
	rw "<hr>☆ 파트너"
	rw "- 아이디 : " & fnGetPartnerInfo("id")
	rw "- 이름 : " & fnGetPartnerInfo("name")
	rw "- 성별 : " & fnGetPartnerInfo("sex")
	rw "- 생일 : " & fnGetPartnerInfo("birth")
	
	rw "<hr>♥ 기념일"
	rw "- 첫만남 : " & fnGetAnniversary("first")
	rw "- 결혼 : " & fnGetAnniversary("wedding")
Else
	rw "오류"
End If
%>
<form name="tfrm" method="POST" action="TokenTest.asp">
TOKEN : <input type="text" name="regtoken" value="<%= regtoken %>"><br>
UserID : <input type="text" name="reguserid" value="<%= reguserid %>"><br>
<input type="button" value="서밋" onclick="document.tfrm.submit();">
</form>