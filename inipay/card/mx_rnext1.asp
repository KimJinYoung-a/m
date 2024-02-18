
<%
	' 수정해야 할 부분
	' 443포트 outbound가 열려 있어야 한다. 대상:mobile.inicis.com
	' 1.위변조 검증 루틴을 추가하는게 좋을 듯...
	' 2.로그를 남기도록 만들면 더욱 좋을 듯...
	' 3.DB처리 실패시 예외처리(TX를 이용한 결제취소라든가..) 기타 통신오류 등도 예외처리하면 좋을 듯


	'/////////////////////////////////////////////////////////////////////////////
	'///// 1. 변수 초기화 및 POST 인증값 받음                                 ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_STATUS, P_RMESG1, P_TID, P_REQ_URL, P_NOTI , vPTID
	P_STATUS = Request("P_STATUS")			'// 인증 상태
	P_RMESG1 = Request("P_RMESG1")			'// 인증 결과 메시지
	P_TID = Request("P_TID")				'// 인증 거래번호
	P_REQ_URL = Request("P_REQ_URL")		'// 결제요청 URL
	P_NOTI = Request("P_NOTI")				'// 기타주문정보
vPTID = P_TID

	'/////////////////////////////////////////////////////////////////////////////
	'///// 2. 상점 아이디 설정 :                                              ////
	'/////    결제요청 페이지에서 사용한 MID값과 동일하게 세팅해야 함...      ////
	'/////////////////////////////////////////////////////////////////////////////
	Dim P_MID
	P_MID = "INIpayTest"					'// 상점아이디




If P_STATUS = "01" Then '인증결과가 실패일 경우
	Response.write "Auth Fail"
	Response.write P_RMESG1 
	Response.write "<br>" 
	Response.End
End If




'인증결과가 성공일 경우
'	Response.write "[인증 결과값]<br>" 
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
'	Response.write "[승인결과값]<br>"
	'/////////////////////////////////////////////////////////////////////////////
	'///// 3. 승인요청 :                                                      ////
	'/////    인증값을 가지고 P_REQ_URL로 승인요청을 함...                    ////
	'/////  - 참조 : http://doevents.egloos.com/296023
	'/////////////////////////////////////////////////////////////////////////////





	url = P_REQ_URL ' 가지고올 url
	dim xmlHttp,  postdata
	'On Error Resume Next
''url = "http://m.10x10.co.kr/test/a/aaa.asp"

''url = "http://www3.10x10.co.kr/test/test2.asp"

url = "http://www.daum.net"
postdata = "a=1"

	Set xmlHttp = CreateObject("Msxml2.ServerXMLHTTP.3.0")

	'postdata = "P_TID=" & P_TID & "&P_MID=" & P_MID '보낼 데이터

			'response.write "DEBUG : postdata=" & postdata & "<br />"
response.write url
	''xmlHttp.open "Post",url, False ' 동기 방식 적용 : 비동기방식은 다음과 같이 xmlRequest.open "Get",url, True
	xmlHttp.open "Post",url, False
    xmlHttp.setRequestHeader "Connection", "close"
    xmlHttp.setRequestHeader "Content-Length", Len(postdata)
    xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.SetTimeouts  2000, 2000, 5000, 25000
	
	xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlHttp.Send   postdata	'post data send
    
    response.write "xmlHttp.Status="&xmlHttp.Status
    
	''''''' 비 동기 방식 ''''''''''''''''				
	'On Error Resume Next '비동기 방식
	'	xmlHttp.Send   postdata	'post data send
						
	'Do while xmlHttp.readyState <> 4 '비동기 방식
				
	'	xmlHttp.waitForResponse 25000	'25초 응답 대기 '비동기 방식
								  
	'if Err.Number <> 0 then 
										
		'time out 예외처리 구문 삽입
	'	Response.Write "Timeout"
	'	Err.Clear
	'	Exit do
	'	END IF 				
	'Loop

	 '''''''''''''''' ''''''''''''''''''''''''''''''''''''''''''''''''
	 
	'Response.Write "Result==>"& Cstr( xmlHttp.responseText ) '이건 한글이 깨짐
	'Response.write "이니시스로부터 받은 값 <br>"
	'밑에서 문자열을 자르므로 이건 출력하지 말자 Response.binaryWrite Cstr( xmlHttp.responseBody ) '한글깨짐은 바이너리로 받으면 된다고 하는데.... 


	' text, binary 변환하기 http://www.devpia.com/Maeul/Contents/Detail.aspx?BoardID=8&MAEULNO=5&no=42&page=22
	' split 사용하기 http://levin01.tistory.com/1791 
	' split 갯수 확인 http://www.happyjung.com/gnuboard/bbs/board.php?bo_table=lecture&wr_id=313&sca=ASP

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
'		' asp 연관배열 http://www.shop-wiz.com/board/main/view/root/asp2/60
'	next


	Set xmlHttp = nothing


'//바이너리 데이터 TEXT형태로 변환
Function  BinaryToText(BinaryData, CharSet)
	 Const adTypeText = 2
	 Const adTypeBinary = 1

	 Dim BinaryStream
	 Set BinaryStream = CreateObject("ADODB.Stream")

	'원본 데이터 타입
	 BinaryStream.Type = adTypeBinary

	 BinaryStream.Open
	 BinaryStream.Write BinaryData
	 ' binary -> text
	 BinaryStream.Position = 0
	 BinaryStream.Type = adTypeText

	' 변환할 데이터 캐릭터셋
	 BinaryStream.CharSet = CharSet 

	'변환한 데이터 반환
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
