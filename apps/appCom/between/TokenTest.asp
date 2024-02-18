<%@ language=vbscript %>
<% option explicit %>
<%
'History : 2014.03.28 ������ ����
'Description :  ��ū �� ���� ȣ��..10�� �����Ⱓ�̳� Ȥ�ó� �ؼ� 9������ ����
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/htmllib.asp"-->
<!-- #include virtual="/lib/util/JSON_2.0.4.asp"-->
<script language="jscript" runat="server" src="/lib/util/JSON_PARSER_JS.asp"></script>
<%
'response.Charset="UTF-8"
	'ȸ�� ���� ����
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
				fnGetUserInfo = session("tenUserid")		'�ٹ����� ȸ��ID
			Case "TENSN"
				fnGetUserInfo = session("tenUserSn")		'��Ʈ�� ��Ī ȸ���Ϸù�ȣ(�ֹ��� �ۼ���)
			Case "TENLV"
				fnGetUserInfo = session("tenUserLv")		'�ٹ����� ȸ�� ��� (�ֹ��� �ۼ���)
		End Select
	End Function

	'��Ʈ�� ���� ����
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

	'����� ���� ����
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
						'// ���� ����
						session("MyGender")			= left(obj1.user.gender,1)
						session("MyUserid")			= obj1.user.id
						session("MyName")			= obj1.user.name

						'// ��Ʈ�� ����
						session("partnerGender")	= left(obj1.partner.gender,1)
						session("partnerUserid")	= obj1.partner.id
						session("partnerName")		= obj1.partner.name
	
						'//����� JSON �Ľ�
						set obj2 = obj1.anniversaries
							For i=0 to obj2.length-1
								Select Case obj2.get(i).type
									Case "USER_BIRTHDAY"			'���� ��Ʈ���� ����
										If obj2.get(i).birthday_user_id = session("MyUserid") Then
											'���� ����
											session("MyBirthday") = Left(obj2.get(i).date, 10)
										ElseIf obj2.get(i).birthday_user_id = session("partnerUserid") Then
											'��Ʈ�� ����
											session("partnerBirthday") = Left(obj2.get(i).date, 10)
											rw Left(obj2.get(i).date, 10)
										End If

									Case "DAY_WE_FIRST_MET"			'ó�� ������
										session("firstMeetDay") = Left(obj2.get(i).date, 10)

									Case "WEDDING_ANNIVERSARY"		'��ȥ�����
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
	rw "<hr>�� ������"
	rw "- ���̵� : " & fnGetUserInfo("id")
	rw "- �̸� : " & fnGetUserInfo("name")
	rw "- ���� : " & fnGetUserInfo("sex")
	rw "- ���� : " & fnGetUserInfo("birth")
	rw "- �ٹ����� userid : " & fnGetUserInfo("tenId")
	rw "- �ٹ����� ȸ����� : " & fnGetUserInfo("tenLv")
	rw "- �ٹ����� userSn : " & fnGetUserInfo("tenSn")
	
	rw "<hr>�� ��Ʈ��"
	rw "- ���̵� : " & fnGetPartnerInfo("id")
	rw "- �̸� : " & fnGetPartnerInfo("name")
	rw "- ���� : " & fnGetPartnerInfo("sex")
	rw "- ���� : " & fnGetPartnerInfo("birth")
	
	rw "<hr>�� �����"
	rw "- ù���� : " & fnGetAnniversary("first")
	rw "- ��ȥ : " & fnGetAnniversary("wedding")
Else
	rw "����"
End If
%>
<form name="tfrm" method="POST" action="TokenTest.asp">
TOKEN : <input type="text" name="regtoken" value="<%= regtoken %>"><br>
UserID : <input type="text" name="reguserid" value="<%= reguserid %>"><br>
<input type="button" value="����" onclick="document.tfrm.submit();">
</form>