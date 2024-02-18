<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
response.charset = "utf-8"
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<%

' -------------------------------------
' 회원의 주소를 찾는 Popup Window 화면
' -------------------------------------
Dim strTarget, strQuery, stype, gubun, protocolAddr

strTarget	= requestCheckVar(Request("target"),32)
strQuery	= requestCheckVar(Request("query"),32)
stype		= requestCheckVar(Request("stype"),4)
gubun		= requestCheckVar(Request("gb"),10)
if stype="" then stype="addr"
%>
<script type="text/javascript">
function CopyZip() {
	var post1 = document.tranFrm.zip1.value;
	var post2 = document.tranFrm.zip2.value;
	var add = document.tranFrm.addr1.value;
	var dong = document.tranFrm.addr2.value;
	var detail = $("input[name='detail']").val();

	if (detail=="") {
		alert("상세주소를 입력해주세요.");
		return;
	}
	dong = dong +' '+ detail;

	// 부모창에 스크립트 전달 후 APP창 닫기
	fnAPPopenerJsCallClose("FnInputZipAddr('<%=strTarget%>','"+post1+"','"+post2+"','"+add+"','"+dong+"','<%=gubun%>')");
}

// 2nd 상세정보 입력폼 표시
function DetailPost(elm,post1,post2,add,dong) {
	document.tranFrm.zip1.value=post1;
	document.tranFrm.zip2.value=post2;
	document.tranFrm.addr1.value=add;
	document.tranFrm.addr2.value=dong;
	$(".zipcodeList li").removeClass("on");
	$(".addDetail").remove();
	$(elm).parent().addClass("on").append('<div class="box2 addDetail"><p class="ftLt w80p"><input type="text" name="detail" class="w100p" placeholder="상세주소를 입력해주세요" /></p><p class="ftLt w20p lPad05"><span class="button btM1 btGry3 cWh1 w100p"><input type="button" onclick="CopyZip();" value="입력" /></span></p></div>');
}

function SubmitForm(frm) {
		if (frm.query.value.length < 2) { alert("동 이름을 두글자 이상 입력하세요."); return; }
		var sUrl = "/lib/act_searchzip.asp?stype="+$("#stype").val()+"&query="+encodeURIComponent($("#txtKwd").val()) + "&target=<%=strTarget%>";

		$.ajax({
			url: sUrl,
			cache: false,
			success: function(rst) {
				$("#code_result").empty().html(rst);
			}
			,error: function(err) {
				alert(err.responseText);
			}
		});
}

function chgTab(dv) {
	$(".tabNav li").removeClass("current");
	if(dv=="addr") {
		$(".tabNav li").eq(0).addClass("current");
		$("#lyrDesc").html("찾고 싶은 동(읍,리,면,가)를 입력해주세요.");
		$("#txtKwd").attr("placeholder","예) 대치동,곡성읍,오곡면");
		$("#stype").val("addr");
	} else {
		$(".tabNav li").eq(1).addClass("current");
		$("#lyrDesc").html("찾고 싶은 주소의 도로명을 입력하세요.");
		$("#txtKwd").attr("placeholder","예) 동숭1길, 세종대로");
		$("#stype").val("road");
	}
}
</SCRIPT>
</head>
<body>
<div class="heightGrid bgGry">
	<div class="container">
		<!-- content area -->
		<div class="content" id="contentArea">
		<form method="get" name="gil" onsubmit="SubmitForm(document.gil); return false;" action="">
		<input type="hidden" name="target"	value="<%=strTarget%>">
		<input type="hidden" name="stype" id="stype" value="<%=stype%>" >
			<!-- 우편번호 찾기 -->
			<div class="inner5 tPad15 bMar20">
				<div class="tab01">
					<ul class="tabNav tNum2">
						<li class="<%=chkIIF(stype="addr","current","")%>"><a href="" onclick="chgTab('addr'); return false;">지번검색<span></span></a></li>
						<li class="<%=chkIIF(stype="road","current","")%>"><a href="" onclick="chgTab('road'); return false;">도로명검색<span></span></a></li>
					</ul>
					<div class="tabContainer box1">
						<div class="tabContent">
							<div class="zipcodeFind">
								<p class="lpad05"><strong id="lyrDesc"><%=chkIIF(stype="addr","찾고 싶은 동(읍,리,면,가)를 입력해주세요.","찾고 싶은 주소의 도로명을 입력하세요.")%></strong></p>
								<div class="overHidden tMar15">
									<p class="ftLt w70p"><input type="text" name="query" id="txtKwd" class="w100p" placeholder="예) <%=chkIIF(stype="addr","대치동,곡성읍,오곡면","동숭1길, 세종대로")%>" /></p>
									<p class="ftLt w30p lPad05"><span class="button btB2 btRed cWh1 w100p"><input type="button" value="검색" onclick="SubmitForm(document.gil);" class="btRed" /></span></p>
								</div>
							</div>
							<ul class="zipcodeList" id="code_result">
								<li align="center" style="padding:20px 0; text-align:center;">지역명을 입력해 주세요.</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
			<!--// 우편번호 찾기 -->
		</form>
		<form name="tranFrm" style="margin:0px;">
		<input type="hidden" name="zip1" value="">
		<input type="hidden" name="zip2" value="">
		<input type="hidden" name="addr1" value="">
		<input type="hidden" name="addr2" value="">
		</form>
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->