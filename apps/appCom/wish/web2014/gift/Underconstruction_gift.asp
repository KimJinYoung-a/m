<%
'###########################################################
' Description :  기프트
' History : 2015.02.02 한용민 생성
'###########################################################

''// 공사중일때 회사IP외에는 지정페이지로 이동
Sub Underconstruction_gift()
	Dim conIp, arrIp, tmpIp
	conIp = Request.ServerVariables("REMOTE_ADDR")
	arrIp = split(conIp,".")
	tmpIp = Num2Str(arrIp(0),3,"0","R") & Num2Str(arrIp(1),3,"0","R") & Num2Str(arrIp(2),3,"0","R") & Num2Str(arrIp(3),3,"0","R")
	'response.write tmpIp
	'//공사중
	if Not(tmpIp>="115094163042" and tmpIp<="115094163045") and Not(tmpIp>="192168006042" and tmpIp<="192168006051") and Not(tmpIp>="061252133001" and tmpIp<="061252133127") and Not(tmpIp>="061252143070" and tmpIp<="061252143078") and not(tmpIp>="192168001001" and tmpIp<="192168001256") and tmpIp<>"211206236117" then
		If Response.Buffer Then
			Response.Clear
			Response.Expires = 0
		End If

		Response.write "<html>"
		Response.write "<head><title>텐바이텐-기프트 서비스 점검중입니다</title></head>"
		Response.write "<meta http-equiv='Content-Type' content='text/html;charset=utf-8' />"
		Response.write "<script type='text/javascript' src='/apps/appCom/wish/web2014/lib/js/customapp.js?v=2.27'></script>"
		Response.write "<script language='javascript'>"
		Response.write "	alert('더 좋은 기프트 서비스를 위해 점검중입니다.\n\n 메인페이지로 이동 합니다.');"
		Response.write "	callgotoday();"
		Response.write "</script>"
		Response.write "<body>"
'		Response.write "<table width='100%' height='100%' cellpadding='0' cellspacing='0' border='0'>"
'		Response.write "<tr>"
'		Response.write "	<td align='center' valign='middle'><img src='http://fiximage.10x10.co.kr/web2013/common/open_ready_2014.jpg' width='1140' height='910' border='0' alt='coming soon'></td>"
'		Response.write "</tr>"
'		Response.write "</table>"
		Response.write "</body>"
		Response.write "</html>"
		response.End
	end if
End Sub

'call Underconstruction_gift()
%>