
<%
	' �����ؾ� �� �κ�
	' 443��Ʈ outbound�� ���� �־�� �Ѵ�. ���:mobile.inicis.com
	' 1.������ ���� ��ƾ�� �߰��ϴ°� ���� ��...
	' 2.�α׸� ���⵵�� ����� ���� ���� ��...
	' 3.DBó�� ���н� ����ó��(TX�� �̿��� ������Ҷ�簡..) ��Ÿ ��ſ��� � ����ó���ϸ� ���� ��


	'/////////////////////////////////////////////////////////////////////////////
	'///// 1. ���� �ʱ�ȭ �� POST ������ ����                                 ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_STATUS, P_RMESG1, P_TID, P_REQ_URL, P_NOTI , vPTID
	P_STATUS = Request("P_STATUS")			'// ���� ����
	P_RMESG1 = Request("P_RMESG1")			'// ���� ��� �޽���
	P_TID = Request("P_TID")				'// ���� �ŷ���ȣ
	P_REQ_URL = Request("P_REQ_URL")		'// ������û URL
	P_NOTI = Request("P_NOTI")				'// ��Ÿ�ֹ�����
vPTID = P_TID

	'/////////////////////////////////////////////////////////////////////////////
	'///// 2. ���� ���̵� ���� :                                              ////
	'/////    ������û ���������� ����� MID���� �����ϰ� �����ؾ� ��...      ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_MID
	P_MID = "INIpayTest"					'// �������̵�




If P_STATUS = "01" Then '��������� ������ ���
	Response.write "Auth Fail"
	Response.write P_RMESG1 
	Response.write "<br>" 
	Response.End
End If




'��������� ������ ���
'	Response.write "[���� �����]<br>" 
'	Response.write "P_STATUS="
'	Response.write P_STATUS
'	Response.write "<br>"
'
'	Response.write "P_TID="
'	Response.write P_TID
'	Response.write "<br>"
'
'	Response.write "P_REQ_URL="
'	Response.write P_REQ_URL
'	Response.write "<hr>"
'
'
'
'	Response.write "[���ΰ����]<br>"
	'/////////////////////////////////////////////////////////////////////////////
	'///// 3. ���ο�û :                                                      ////
	'/////    �������� ������ P_REQ_URL�� ���ο�û�� ��...                    ////
	'/////  - ���� : http://doevents.egloos.com/296023
	'/////////////////////////////////////////////////////////////////////////////





	url = P_REQ_URL ' ������� url
	dim xmlHttp,  postdata
	'On Error Resume Next
''url = "http://m.10x10.co.kr/test/a/aaa.asp"

''url = "http://www3.10x10.co.kr/test/test2.asp"

url = "http://www.daum.net"
postdata = "a=1"

	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	'postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '���� ������

			'response.write "DEBUG : postdata=" & postdata & "<br />"
response.write url
	''xmlHttp.open "Post",url, False ' ���� ��� ���� : �񵿱����� ������ ���� xmlRequest.open "Get",url, True
	xmlHttp.open "Post",url, False
    xmlHttp.setRequestHeader "Connection", "close"
    xmlHttp.setRequestHeader "Content-Length", Len(postdata)
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.SetTimeouts  2000, 2000, 5000, 25000
	
	xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send   postdata	'post data send
    
    response.write "xmlHttp.Status="&xmlHttp.Status
    
	''''''' �� ���� ��� ''''''''''''''''				
	'On Error Resume Next '�񵿱� ���
	'	xmlHttp.Send   postdata	'post data send
						
	'Do while xmlHttp.readyState <> 4 '�񵿱� ���
				
	'	xmlHttp.waitForResponse 25000	'25�� ���� ��� '�񵿱� ���
								  
	'if Err.Number <> 0 then 
										
		'time out ����ó�� ���� ����
	'	Response.Write "Timeout"
	'	Err.Clear
	'	Exit do
	'	END IF 				
	'Loop

	 '''''''''''''''' ''''''''''''''''''''''''''''''''''''''''''''''''
	 
	'Response.Write "Result==>"& Cstr( xmlHttp.responseText ) '�̰� �ѱ��� ����
	'Response.write "�̴Ͻý��κ��� ���� �� <br>"
	'�ؿ��� ���ڿ��� �ڸ��Ƿ� �̰� ������� ���� Response.binaryWrite Cstr( xmlHttp.responseBody ) '�ѱ۱����� ���̳ʸ��� ������ �ȴٰ� �ϴµ�.... 


	' text, binary ��ȯ�ϱ� http://www.devpia.com/Maeul/Contents/Detail.aspx?BoardID=8&MAEULNO=5&no=42&page=22
	' split ����ϱ� http://levin01.tistory.com/1791 
	' split ���� Ȯ�� http://www.happyjung.com/gnuboard/bbs/board.php?bo_table=lecture&wr_id=313&sca=ASP

	IF Err.Number <> 0 then
		Response.write "aa"
		Response.write "<br>" 
		Response.End
	End If

''response.write xmlHttp.ResponseBody
response.write  BinaryToText(xmlHttp.ResponseBody, "euc-kr")
response.end
 
	vntPostedData = xmlHttp.responseBody
''response.write "vntPostedData="&Len(vntPostedData)
	strData = BinaryToString(vntPostedData)
response.write "strData="&strData

'	arr = Split(strData , "&")
'	k = 0
'	for i = 0 to UBound(arr)
'	k = k +1
'	next
'
'	for i = 0 to k-1
'	response.write arr(i)
'	response.write "<br>"
'		' asp �����迭 http://www.shop-wiz.com/board/main/view/root/asp2/60
'	next


	Set xmlHttp = nothing


'//���̳ʸ� ������ TEXT���·� ��ȯ
Function  BinaryToText(BinaryData, CharSet)
	 Const adTypeText = 2
	 Const adTypeBinary = 1

	 Dim BinaryStream
	 Set BinaryStream = CreateObject("ADODB.Stream")

	'���� ������ Ÿ��
	 BinaryStream.Type = adTypeBinary

	 BinaryStream.Open
	 BinaryStream.Write BinaryData
	 ' binary -> text
	 BinaryStream.Position = 0
	 BinaryStream.Type = adTypeText

	' ��ȯ�� ������ ĳ���ͼ�
	 BinaryStream.CharSet = CharSet 

	'��ȯ�� ������ ��ȯ
	 BinaryToText = BinaryStream.ReadText

	 Set BinaryStream = Nothing
End Function 

	Function StringToBinary(S)
		Dim i, ByteArray
		For i=1 to Len(S)
		ByteArray = ByteArray & ChrB(Asc(Mid(S,i,1)))
		Next
		StringToBinary = ByteArray
	End Function
	
	Function BinaryToString(Binary)
		Dim I, S
		For I = 1 To LenB(Binary)
		S = S & Chr(AscB(MidB(Binary, I, 1)))
		Next
		BinaryToString = S
	End Function

'	If Trim(arr(0)) <> "P_STATUS=00" Then
''		Response.write "bb" & " " & Trim(arr(0)) & " " & Trim(arr(3)) & "!" & Trim(arr(5))
''		Response.write "<br>" 
''		Response.write "<br>" 
''		Response.write "<br>" 
''		Response.WRite "TID=" & vPTID
''		Response.write "<br>" 
''		Response.End
'	End IF
'	
'	'Response.Redirect "" & wwwUrl & "/inipay/displayorder.asp"
'	Response.End
%>
