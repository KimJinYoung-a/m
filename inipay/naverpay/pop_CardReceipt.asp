<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.CharSet="UTF-8"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/inipay/naverpay/incNaverpayCommon.asp"-->
<%
Dim sqlStr
Dim NPay_paymentId, retUrl

'// 바로 접속시엔 오류 표시
If InStr(request.ServerVariables("HTTP_REFERER"), "10x10.co.kr") < 1 Then
	Call Alert_Close("잘못된 접속입니다.")
	Response.End
End If

'// 2021년 5월 6일 더이상 하단 네이버페이 카드 명세서는 사용하지 않음
Call Alert_Close("[네이버페이 > 결제내역]에서 확인 하실 수 있습니다.")
Response.End

NPay_paymentId = request("tid")		'결제ID

''### 1. 네이버페이 신용카드 매출전표 조회 호출
retUrl = fnCallNaverPayReceipt(NPay_paymentId)

if left(retUrl,4)="ERR:" then
	response.write "<script>alert('처리중 오류가 발생했습니다.\n(" & right(retUrl,len(retUrl)-4) & ")');self.close();</script>"
	response.end
end if

''### 2. 조회 화면 호출
Response.Redirect URLDecodeUTF8(retUrl)



'-----------------------------------------------------
'// URL Decoding
Public Function URLDecodeUTF8(byVal pURL)
Dim i, s1, s2, s3, u1, u2, result
pURL = Replace(pURL,"+"," ")

For i = 1 to Len(pURL)
	if Mid(pURL, i, 1) = "%" then
		s1 = CLng("&H" & Mid(pURL, i + 1, 2))

        '1바이트일 경우
        If CInt("&H" & Mid(pURL, i + 1, 2)) < 128 Then
            result = result & Chr(CInt("&H" & Mid(pURL, i + 1, 2)))
            i = i + 2 ' 잘라낸 만큼 뒤로 이동

		'2바이트일 경우
		elseif ((s1 AND &HC0) = &HC0) AND ((s1 AND &HE0) <> &HE0) then
			s2 = CLng("&H" & Mid(pURL, i + 4, 2))

			u1 = (s1 AND &H1C) / &H04
			u2 = ((s1 AND &H03) * &H04 + ((s2 AND &H30) / &H10)) * &H10
			u2 = u2 + (s2 AND &H0F)
			result = result & ChrW((u1 * &H100) + u2)
			i = i + 5

		'3바이트일 경우
		elseif (s1 AND &HE0 = &HE0) then
			s2 = CLng("&H" & Mid(pURL, i + 4, 2))
			s3 = CLng("&H" & Mid(pURL, i + 7, 2))

			u1 = ((s1 AND &H0F) * &H10)
			u1 = u1 + ((s2 AND &H3C) / &H04)
			u2 = ((s2 AND &H03) * &H04 +  (s3 AND &H30) / &H10) * &H10
			u2 = u2 + (s3 AND &H0F)
			result = result & ChrW((u1 * &H100) + u2)
			i = i + 8
		end if
	else
		result = result & Mid(pURL, i, 1)
	end if
Next
URLDecodeUTF8 = result
End Function
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->