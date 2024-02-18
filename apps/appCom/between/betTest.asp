<%@ language=vbscript %>
<% option explicit %>
<%
'History : 2014.03.28 ������ ����
'Description :  ��ū �� ���� ȣ��..10�� �����Ⱓ�̳� Ȥ�ó� �ؼ� 9������ ����
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp"-->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
Public MBGender					'�� ����
Public PBGender					'��Ʈ�� ����
Public MBName 					'�� �̸�
Public PBName					'��Ʈ�� �̸�
Public MBId						'�� ID
Public PBId						'��Ʈ�� ID
Public MBBirthday				'�� ����
Public PBBirthday				'��Ʈ�� ����
Public WeFirstMETDay			'ó�� ������
Public WeddingDay				'��ȥ �����
'########################### ��ū �ޱ� ####################################################
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

'########################## ���� ����� ���� �ޱ� ###########################################
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
			Case "401"		Errmsg = "�߱��� token�� ��ȿ�ð��� �������ϴ�."
			Case "400"		Errmsg = "token Ȥ�� user_id�� �߸��� ���̰ų� ������ ���Դϴ�."
			Case "500"		Errmsg = "������ ������ �߻��Ͽ����ϴ�."
			Case "404"		Errmsg = "�������� �ʴ� endpoint�Դϴ�."
			Case "405"		Errmsg = "������ �ʴ� method�Դϴ�."
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
					'����� JSON �Ľ�
					set obj2 = obj1.anniversaries
						For i=0 to obj2.length-1
							If obj2.get(i).type = "USER_BIRTHDAY" Then				'���� ���
								If obj2.get(i).birthday_user_id = PBId Then			'��Ʈ��
									response.Cookies("between")("PBBirthday") = Left(obj2.get(i).date, 10)
								ElseIf obj2.get(i).birthday_user_id = MBId Then		'��
									response.Cookies("between")("MBBirthday") = Left(obj2.get(i).date, 10)
								End If
							End If	

							If obj2.get(i).type = "DAY_WE_FIRST_MET" Then			'ó�� ���� �� ���
								response.Cookies("between")("WeFirstMETDay") = Left(obj2.get(i).date, 10)
							End If
							If obj2.get(i).type = "WEDDING_ANNIVERSARY" Then		'��ȥ ����� ���
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
rw "��Ʈ�ʼ��� : "&PBGender
rw "��Ʈ��ID : "&PBId
rw "��Ʈ���̸� : "&PBName
rw "��Ʈ�ʻ��� : "&PBBirthday
rw "############################################################"
rw "�� ���� : "&MBGender
rw "�� ID : "&MBId
rw "�� �̸� : "&MBName
rw "�� ���� : "&MBBirthday
rw "############################################################"
rw "ó�������� : "&WeFirstMETDay
rw "��ȥ����� : "&WeddingDay
rw "############################################################"
%>
