<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
	'// 유효 접근 주소 검사 //
	dim refer, refip, recentqcount
	refer = request.ServerVariables("HTTP_REFERER")
	if InStr(refer,"10x10.co.kr")<1 then
		response.write "<script type='text/javascript'>alert('유효하지 못한 접근입니다.');self.close();</script>"	'--유효하지 못한 접근
		response.End
	end if
	
	Dim sUid : sUid = getEncLoginUserId()

	randomize(time())     
	Dim strOrderNo : strOrderNo = Replace(date, "-", "")  & round(rnd*(999999999999-100000000000)+100000000000)
	
	'// 해킹방지를 위해 요청정보를 세션에 저장
	session("niceOrderNo") = strOrderNo
	dim protocol : protocol = "HTTPS"
	if request.ServerVariables("HTTPS") = "off" then protocol = "http" end if

	'#######################################################################################
	'#####	휴대폰본인인증 서비스								한국모바일인증(주)
	'#######################################################################################
	Dim tr_cert											' tr_cert
    Dim cpId		: cpId		= "TENM1001"			' 회원사ID
    Dim urlCode		: urlCode	= chkIIF(application("Svr_Info")<>"staging","019001","020001")	'007004	 			' URL 코드
    Dim certNum		: certNum	= strOrderNo			' 요청번호(Unique Value)
    Dim dDate		: dDate		= year(now) & right("0" & Month(now),2) & right("0" & day(now),2) & right("0" & hour(now),2) & right("0" & minute(now),2) & right("0" & second(now),2)	' 요청일시
    Dim certMet		: certMet	= "M"					' 본인인증방법
    Dim tr_url		: tr_url	= protocol + "://" + request.ServerVariables("HTTP_HOST") +"/member/popCheckWhoAmICallBack.asp"		' 본인인증 결과수신 POPUP URL
	Dim enc												' 암호화 객체
	Dim hash											' 위변조 검증 객체
    Dim enc_tr_cert_hash								' enc_tr_cert의 위변조 Hash 값
	Dim plainStr										' 2차암호화를 위한 임시 데이터
    Dim enc_tr_cert										' 암호화한 tr_cert
    Dim extendVar	: extendVar	= "0000000000000000"	' 확장변수

	'01. tr_cert 데이터변수 조합 (서버로 전송할 데이터 "/"로 조합)
	tr_cert	= cpId & "/"+ urlCode & "/"+ certNum & "/"+ dDate & "/"+ certMet & "///////" + sUid & "/"+ extendVar

    '02. tr_cert 데이터 암호화 ----------------------------------------------------------------------------------
		'02-01. tr_cert 1차 암호화
		Set enc = Server.CreateObject("ICERTSecurity.SEED")
		    enc_tr_cert = enc.IcertSeedEncript(tr_cert, "")
		Set enc = Nothing

		'02-02. tr_cert 1차 암호화한 데이터의 위변조검증값 생성
		Set hash = Server.CreateObject("ICERTSecurity.AES")
			enc_tr_cert_hash = hash.IcertHMacEncript(enc_tr_cert)
		Set hash = Nothing

		'02-03. tr_cert 2차 암호화
		Set enc = Server.CreateObject("ICERTSecurity.SEED")
			plainStr  = enc_tr_cert & "/" & enc_tr_cert_hash & "/" & "0000000000000000"
			enc_tr_cert = enc.IcertSeedEncript(plainStr, "")
		Set enc = Nothing
	' End - 02. tr_cert 데이터 암호화 ----------------------------------------------------------------------------------
%>
<script type="text/javascript">
<!--
	window.onload = function() {
		document.reqKMCISForm.action = 'https://www.kmcert.com/kmcis/web/kmcisReq.jsp';
		document.reqKMCISForm.submit();
	}
//-->
</script>
<!-- 본인인증서비스 요청 form --------------------------->
<form name="reqKMCISForm" method="post" action="#">
    <input type="hidden" name="tr_cert" value="<%=enc_tr_cert%>">
    <input type="hidden" name="tr_url" value="<%=tr_url%>">
</form>
<!--End 본인인증서비스 요청 form ----------------------->