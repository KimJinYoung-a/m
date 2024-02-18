<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<%
'###########################################################
' Description :  mobile 우편번호 찾기 상세화면(카카오 API)
' History : 2020.01.06 원승현 생성
'###########################################################
%>
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<%
	Dim strTarget
	Dim strMode, protocolAddr
	Dim gubun	
    Dim tzip, taddr1, taddr2, extraAddr
	strTarget	= requestCheckVar(Request("target"),32)
	strMode     = requestCheckVar(Request("strMode"),32)
	gubun		= requestCheckVar(Request("gb"),10)
    tzip        = requestCheckVar(Request("tzip"),10)
    taddr1      = requestCheckVar(Request("taddr1"),256)
    taddr2      = requestCheckVar(Request("taddr2"),256)
    extraAddr   = requestCheckVar(Request("extraAddr"),256)
%>
<script>

	$(function(){
        setTimeout(function() {
			$("#extraAddr2").focus();
        }, 200);
	});

	<%'// 모창에 값 던져줌 %>
	function CopyZipAPI()	{
		var frm = eval("document.<%=strTarget%>");
		var basicAddr;
		var basicAddr2;
		basicAddr = "";
		basicAddr2 = "";

		basicAddr = "<%=taddr1&taddr2&extraAddr%>";
		basicAddr2 = $("#extraAddr2").val();

		// copy
		<%
			Select Case strTarget
				Case "frmWrite"		'나의 주소록 Form
		%>
			//frm.zip1.value			= post1;
			//frm.zip2.value			= post2;
			opener.frm.zip.value		= "<%=tzip%>";
			opener.frm.reqZipaddr.value	= basicAddr;
			opener.frm.reqAddress.value	= basicAddr2;
			opener.frm.reqAddress.focus();
		<%		Case "buyer" %>
			opener.frm.buyZip.value		= "<%=tzip%>";
			opener.frm.buyAddr1.value		= basicAddr;
			opener.frm.buyAddr2.value		= basicAddr2;
			opener.frm.buyAddr2.focus();
		<%		Case "userinfo" %>
			opener.frm.txZip.value		= "<%=tzip%>";
			opener.frm.txAddr1.value		= basicAddr;
			opener.frm.txAddr2.value		= basicAddr2;
			opener.frm.txAddr2.focus();
		<%		Case Else %>
			opener.frm.txZip.value		= "<%=tzip%>";
			opener.frm.txAddr1.value		= basicAddr;
			opener.frm.txAddr2.value		= basicAddr2;
			opener.frm.txAddr2.focus();
		<%	End Select %>
		window.close();
    }
</script>

<body class="default-font body-popup">
    <header class="tenten-header header-popup">
        <div class="title-wrap">
            <h1>우편번호 찾기</h1>
            <button type="button" class="btn-close" onclick="window.close();">닫기</button>
        </div>
    </header>
	<%' contents %>
	<div id="content" class="content addr-detail">
        <p class="comment">나머지 주소를<br />입력해주세요</p>
        <a href="/lib/pop_searchzip_ka.asp?target=<%=strTarget%>&strMode=<%=strMode%>&gb=<%=gubun%>" class="btn-search">주소 다시 검색</a>
        <div class="form-group">
            <input type="text" value="<%=taddr1&taddr2&extraAddr%>" readonly />
            <input type="text" name="extraAddr2" id="extraAddr2" placeholder="상세주소 입력" />
        </div>
        <div class="floatingBar">
            <button type="button" class="btn btn-xlarge btn-red btn-block" onclick="CopyZipAPI();">입력하기</button>
        </div>
    </div>
	<%' //contents %>
</body>
</html>