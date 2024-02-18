<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
session.codePage = 65001
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Access-Control-Allow-Origin","*"
Response.AddHeader "Access-Control-Allow-Methods","POST"
Response.AddHeader "Access-Control-Allow-Headers","X-Requested-With"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/tenEncUtil.asp"-->
<!-- #include virtual="/lib/util/base64unicode.asp"-->
<%

1

dim sqlStr, i
dim orderserial, enc_orderserial, validdate, link, asid

response.write "333"
''dbget.close : response.end

validdate = Left(DateAdd("d", 8, Now()), 10)
for i = 0 to 1000
    sqlStr = "select top 1 orderserial, asid from [db_temp].dbo.tbl_recall_target where link is NULL "
    rsget.CursorLocation = adUseClient
    rsget.CursorType = adOpenStatic
    rsget.LockType = adLockOptimistic
    rsget.Open sqlStr,dbget,1

    orderserial = ""
    if  not rsget.EOF  then
        orderserial = rsget("orderserial")
        asid = rsget("asid")
    end if
    rsget.close

    if orderserial = "" then
        exit for
    end if

    ''orderserial = orderserial & "," & validdate
    enc_orderserial = TBTEncryptUrl("01," & asid & "," & orderserial & "," & validdate)

    sqlStr = "update [db_temp].dbo.tbl_recall_target " & vbCrLf
    sqlStr = sqlStr & " set link = '" & vbCrLf
    sqlStr = sqlStr & "안녕하세요 고객님 " & vbCrLf
    sqlStr = sqlStr & "텐바이텐 입니다." & vbCrLf
    sqlStr = sqlStr & "" & vbCrLf
    sqlStr = sqlStr & "11월 18일 목요일 저녁 8시에 진행된 네이버 라이브 방송과 관련하여" & vbCrLf
    sqlStr = sqlStr & "시스템 오류로 초과 결제 된 배송비 환불 안내드립니다." & vbCrLf
    sqlStr = sqlStr & "" & vbCrLf
    sqlStr = sqlStr & "아래 링크로 접속하시어 환불정보(계좌번호,예금주, 은행명) 입력 부탁드립니다." & vbCrLf
    sqlStr = sqlStr & "입력해 주신 계좌로 환불 예정이며, 환불은 평일기준 1~2일 이내 진행될 예정입니다" & vbCrLf
    sqlStr = sqlStr & "" & vbCrLf
    sqlStr = sqlStr & "http://m.10x10.co.kr/my10x10/login.asp?k=" & enc_orderserial & vbCrLf
    sqlStr = sqlStr & "" & vbCrLf
    sqlStr = sqlStr & "다시한번, 쇼핑에 불편드리게 되어 너무 죄송합니다." & vbCrLf
    sqlStr = sqlStr & "" & vbCrLf
    sqlStr = sqlStr & "※링크 유효기간은 1주일입니다." & vbCrLf
    sqlStr = sqlStr & "' " & vbCrLf
    sqlStr = sqlStr & "where orderserial = '" & orderserial & "' "
    dbget.Execute sqlStr
    ''response.write sqlStr & "<br />"
next


'' '// 주문번호
'' orderserial = "21033034893"
'' '// 유효기간(1주일)
'' validdate = Left(DateAdd("d", 7, Now()), 10)
''
'' orderserial = orderserial & "," & validdate
'' response.write "주문번호 : " & orderserial & "<br />"
''
'' '// ========================================================
'' '// 암호화
'' enc_orderserial = TBTEncryptUrl(orderserial)
'' response.write "암호화 : " & enc_orderserial & "<br />"
''
'' '// ========================================================
'' '// 복호화
'' orderserial = TBTDecryptUrl(enc_orderserial)
'' response.write "복호화 : " & orderserial & "<br />"

%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
