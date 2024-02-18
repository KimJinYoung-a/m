<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/base64.asp" -->
<!-- #INCLUDE Virtual="/lib/util/tenEncUtil.asp" -->
<%
	Response.AddHeader "Cache-Control","no-cache"
	Response.AddHeader "Expires","0"
	Response.AddHeader "Pragma","no-cache"

	Dim sName, sCell, sEmail

	sName = session("findIDName")
	sCell = session("findIDCell")
	sEmail = session("findIDMail")

	if sName="" or (sCell="" and sEmail="") then
		Call Alert_Move("유효기간이 만료되었습니다.\n다시 시도해주세요.","/member/find_idpw.asp?t=id")
		dbget.Close: Response.End
	end if

	'유효값 확인
	if sCell<>"" then
		if ubound(split(sCell,"-"))<2 then
			Call Alert_Return("잘못된 휴대폰 번호입니다.\n확인 후 다시 시도해주세요.")
			dbget.Close: Response.End
		end if
	end if

	if sEmail<>"" then
		if ubound(split(sEmail,"@"))<1 then
			Call Alert_Return("잘못된 이메일입니다.\n확인 후 다시 시도해주세요.")
			dbget.Close: Response.End
		end if
	end if

	'// 아이디 암호화 함수
	function encTenUID(uid)
		encTenUID = Base64encode(tenEnc(uid))
	end function
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: 아이디 뒷자리 확인</title>
<script type="text/javascript">
$(function(){
	//아이디 기본 선택
	$(".history input[name='selID']").first().prop("checked",true);
});

function fnSendFullId(mtd) {
	if($(".history input[name='selID']:checked").length<=0) {
		alert("아이디를 선택해주세요.");
		return;
	}

	var sId = $(".history input[name='selID']:checked").val();

	var rstStr = $.ajax({
		type: "POST",
		url: "pop_findFullId_proc.asp",
		data: "sid="+encodeURIComponent(sId)+"&mtd="+mtd,
		dataType: "text",
		async: false
	}).responseText;

	switch(rstStr) {
		case "E1":
			alert("유효기간이 만료되었습니다.(E01)\n다시 시도해주세요.");
			location.replace("/member/find_idpw.asp?t=id");
			break;
		case "E2":
			alert("처리중 오류가 발생했습니다.(E02)\n다시 시도해주세요.");
			break;
		case "E3":
			alert("처리중 오류가 발생했습니다.(E03)\n다시 시도해주세요.");
			break;
		case "10":
			alert("회원정보에 등록된 휴대폰 번호로 아이디가 전송되었습니다.");
			location.replace("/member/find_idpw.asp?t=id");
			break;
		case "20":
			alert("회원정보에 등록된 이메일 주소로 아이디가 전송되었습니다.");
			location.replace("/member/find_idpw.asp?t=id");
			break;
		default:
			alert("처리중 오류가 발생했습니다.(E99)");
	}
}
</script>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container popWin">
		<div class="header">
			<h1>아이디 뒷자리 확인</h1>
			<p class="btnPopClose"><button class="pButton" onclick="goBack('/member/find_idpw.asp?t=id'); return false;">닫기</button></p>
		</div>
		<!-- content area -->
		<div class="content bgGry" id="contentArea">
			<!-- 아이디 뒷자리 확인 -->
			<div class="viewWholeId">
				<div class="findResult tPad0">
					<div class="history">
						<ul>
						<%
							'// 대상 아이디 찾기
							dim sqlStr
							sqlStr = "EXEC [db_user_Hold].[dbo].[usp_WWW_FindUserid_Get] '" & sName & "','" & sEmail & "','" & sCell & "'"
							rsget.CursorLocation = adUseClient
							rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly

							if Not rsget.Eof then
								Do Until rsget.EOF
						%>
							<li><input type="radio" name="selID" value="<%=encTenUID(rsget("userid"))%>" /> <strong><%=printUserId(rsget("userid"),2,"*")%></strong> (<%=left(FormatDateTime(rsget("regdate"),1),len(FormatDateTime(rsget("regdate"),1))-4)%>)</li>
						<%
								rsget.MoveNext
								Loop
							else
								Call Alert_Move("검색 대상이 없습니다.\n확인 후 다시 시도해주세요.","/member/find_idpw.asp?t=id")
								rsget.Close: dbget.Close: Response.End
							end if

							rsget.Close
						%>
						</ul>
					</div>
				</div>
				<div class="sendId">
					<!--
					<p class="tip">뒷자리가 모두 표기된 아이디 확인 방법을 선택해주세요</p>
					<ul class="tabNav tNum2 noMove">
						<li class="phone <%=chkIIF(sCell<>"","current","")%>"><a href="#sendPhone" onclick="<%=chkIIF(sCell="","alert('휴대폰 번호로 아이디 찾기 후 보내실 수 있습니다.');","")%>return false;"><em class="ico"></em><strong>등록 휴대폰</strong><p>회원정보에 등록된<br />휴대폰 번호로 아이디 받기</p></a></li>
						<li class="mail <%=chkIIF(sEmail<>"","current","")%>"><a href="#sendMail" onclick="<%=chkIIF(sEmail="","alert('이메일로 아이디 찾기 후 보내실 수 있습니다.');","")%>return false;"><em class="ico"></em><strong>등록 이메일</strong><p>회원정보에 등록된<br />이메일 주소로 아이디 받기</p></a></li>
					</ul>
					-->
					<div class="tabContainer">
					<%
						if sCell<>"" then
					%>
						<div id="sendPhone">
							<div>
								<strong><%=split(sCell,"-")(0) & "-" & split(sCell,"-")(1) %>-****</strong>
								<p class="tPad10 bMar20">회원정보에 등록된 휴대폰 번호로<br />아이디를 보내드립니다.</p>
								<span class="button btB1 btRed cWh1 w100p"><a href="#" onclick="fnSendFullId('HP');return false;">확인</a></span>
							</div>
						</div>
					<%
						ElseIf sEmail<>"" then
					%>
						<div id="sendMail">
							<div>
								<strong><%=printUserId(split(sEmail,"@")(0),2,"*") & "@" & split(sEmail,"@")(1) %></strong>
								<p class="tPad10 bMar20">회원정보에 등록된 이메일 주소로<br />아이디를 보내드립니다.</p>
								<span class="button btB1 btRed cWh1 w100p"><a href="#" onclick="fnSendFullId('EM');return false;">확인</a></span>
							</div>
						</div>
					<%
						end if
					%>
					</div>
				</div>
			</div>
			<!--// 아이디 뒷자리 확인 -->
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->