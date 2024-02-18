<%@ language=vbscript %>
<% option explicit %>
<%
'History : 2014.03.28 김진영 생성
'Description :  토큰 및 정보 호출..10분 유예기간이나 혹시나 해서 9분으로 설정
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp"-->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
Public MBGender					'내 성별
Public PBGender					'파트너 성별
Public MBName 					'내 이름
Public PBName					'파트너 이름
Public MBId						'내 ID
Public PBId						'파트너 ID
Public MBBirthday				'내 생일
Public PBBirthday				'파트너 생일
Public WeFirstMETDay			'처음 만난날
Public WeddingDay				'결혼 기념일
'########################### 토큰 받기 ####################################################
Public Sub getToken()
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
						response.Cookies("between").domain = "10x10.co.kr"
						response.Cookies("between")("gift_token")	= jsResult.data.gift_token
						response.Cookies("between")("user_id")		= jsResult.data.user_id
						response.Cookies("between").Expires = DateAdd("n",0,now())
					Set jsResult = Nothing
				End If
			Set objXML = Nothing
		On Error Goto 0
End Sub

'########################## 나와 사용자 정보 받기 ###########################################
Public Sub getBetweenUserInfo(weentoken, weenid)
	Dim betweenAPIURL, objXML, iRbody, jsResult
	Dim obj1, i, obj2, obj3, Errmsg
	betweenAPIURL = "https://between-gift-dummy.vcnc.co.kr/api/users/"
	on Error Resume Next
	Set objXML= CreateObject("MSXML2.ServerXMLHTTP.3.0")
	    objXML.Open "GET", betweenAPIURL&weenid , False
		objXML.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		objXML.SetRequestHeader "Authorization","between-gift=" & weentoken
		objXML.Send()
		iRbody = BinaryToText(objXML.ResponseBody,"euc-kr")

		Select Case objXML.Status
			Case "401"		Errmsg = "발급한 token의 유효시간이 지났습니다."
			Case "400"		Errmsg = "token 혹은 user_id가 잘못된 값이거나 오염된 값입니다."
			Case "500"		Errmsg = "서버에 문제가 발생하였습니다."
			Case "404"		Errmsg = "존재하지 않는 endpoint입니다."
			Case "405"		Errmsg = "허용되지 않는 method입니다."
		End Select

		If Errmsg <> "" Then
			rw Errmsg
			Call getToken()
			Call getBetweenUserInfo(request.Cookies("between")("gift_token"), request.Cookies("between")("user_id"))
			Exit Sub
		End If
		
		If objXML.Status = "200" Then
			Set jsResult = JSON.parse(iRbody)
				set obj1 = jsResult.data
					response.Cookies("between").domain = "10x10.co.kr"
					response.Cookies("between")("PBGender")	= obj1.partner.gender
					response.Cookies("between")("PBId")		= obj1.partner.id
					response.Cookies("between")("PBName")	= obj1.partner.name

					response.Cookies("between")("MBGender")	= obj1.user.gender
					response.Cookies("between")("MBId")		= obj1.user.id
					response.Cookies("between")("MBName")	= obj1.user.name
					'기념일 JSON 파싱
					set obj2 = obj1.anniversaries
						For i=0 to obj2.length-1
							If obj2.get(i).type = "USER_BIRTHDAY" Then				'생일 얻기
								If obj2.get(i).birthday_user_id = PBId Then			'파트너
									response.Cookies("between")("PBBirthday") = Left(obj2.get(i).date, 10)
								ElseIf obj2.get(i).birthday_user_id = MBId Then		'나
									response.Cookies("between")("MBBirthday") = Left(obj2.get(i).date, 10)
								End If
							End If	

							If obj2.get(i).type = "DAY_WE_FIRST_MET" Then			'처음 만난 날 얻기
								response.Cookies("between")("WeFirstMETDay") = Left(obj2.get(i).date, 10)
							End If
							If obj2.get(i).type = "WEDDING_ANNIVERSARY" Then		'결혼 기념일 얻기
								response.Cookies("between")("WeddingDay")	 = Left(obj2.get(i).date, 10)
							End If
						Next
					set obj2 = nothing
					response.Cookies("between").Expires = date() + 1
				set obj1 = Nothing
			Set jsResult = Nothing
		End If
	Set objXML = Nothing
	On Error Goto 0
End Sub
'############################################################################################
Call getBetweenUserInfo(request.Cookies("between")("gift_token"), request.Cookies("between")("user_id"))
'Call getBetweenUserInfo(1,2)

PBGender		= request.Cookies("between")("PBGender")
PBId			= request.Cookies("between")("PBId")
PBName			= request.Cookies("between")("PBName")

MBGender		= request.Cookies("between")("MBGender")
MBId			= request.Cookies("between")("MBId")
MBName			= request.Cookies("between")("MBName")

PBBirthday		= request.Cookies("between")("PBBirthday")
MBBirthday		= request.Cookies("between")("MBBirthday")
WeFirstMETDay	= request.Cookies("between")("WeFirstMETDay")
WeddingDay		= request.Cookies("between")("WeddingDay")

rw "############################################################"
rw "파트너성별 : "&PBGender
rw "파트너ID : "&PBId
rw "파트너이름 : "&PBName
rw "파트너생일 : "&PBBirthday
rw "############################################################"
rw "내 성별 : "&MBGender
rw "내 ID : "&MBId
rw "내 이름 : "&MBName
rw "내 생일 : "&MBBirthday
rw "############################################################"
rw "처음만난날 : "&WeFirstMETDay
rw "결혼기념일 : "&WeddingDay
rw "############################################################"
%>
