<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	Description : CS Center
'#######################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/cscenter/boardfaqcls.asp" -->
<%
dim i, vSearchTxt
vSearchTxt = RequestCheckVar(request("searchtxt"),16)

if checkNotValidHTML(vSearchTxt) then
	dbget.close()
	response.redirect "/cscenter/"
	response.End
end if

dim boardfaq
set boardfaq = New CBoardFAQ
If vSearchTxt = "" Then
	boardfaq.FPageSize = 10
	boardfaq.getFaqTopList "HIT"
Else
	boardfaq.FPageSize = 200
	boardfaq.FRectSearchString = vSearchTxt
End If
	boardfaq.getFaqTopList "HIT"
%>

<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
function fnCallCsTel() {
	var dtNow = new Date();
	// 요일검사
	if(dtNow.getDay()==0||dtNow.getDay()==6) {
		alert("주말,공휴일은 휴무입니다.");
		return;
	}
	// 시간검사
	if(dtNow.getHours()>=9&&dtNow.getHours()<18) {
		if(dtNow.getHours()>=12&&dtNow.getHours()<=13) {
			alert("점심시간은 PM 12:00 ~ PM 01:00 입니다.");
			return;
		} else {
			self.location="tel:1644-6030";
		}
	} else {
		alert("고객행복센터 운영시간은 AM 09:00 ~ PM 06:00입니다.");
		return;
	}
}

function jsSearchFaq(){
	frmFaq.submit();
}

function jsTxtSelect(t){
	$("#searchtxt").val(t);
	jsSearchFaq();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<!--<h2 class="tit01 tMar20 lMar10">고객행복센터</h2>-->
				<div class="csguide">
					<div>
						<a href="/my10x10/qna/myqnalist.asp">
							<h2>1:1 상담</h2>
							<p>1:1 상담은 로그인이 필요한<br /> 서비스입니다.</p>
						</a>
					</div>

					<div>
						<a href="" onclick="fnCallCsTel(); return false;">
							<h2>1644-6030</h2>
							<p><em>AM 09:00~PM 06:00</em> 점심 PM 12:00~01:00<br /> (주말, 공휴일 휴무)</p>
						</a>
					</div>
				</div>
				<div class="bnr-thank-wrap"><div class="bnr-thank"><a href="thanks10x10.asp"><span>고마워, 텐바이텐!</span><em>텐바이텐을 칭찬해주세요 〉</em></a></div></div>
				<div class="faq">
					<h2>FAQ 검색</h2>
					<div class="finder">
						<fieldset>
						<legend>FAQ 검색</legend>
						<form name="frmFaq" method="get">
							<input type="search" name="searchtxt" id="searchtxt" value="<%=vSearchTxt%>" title="검색어를 입력하세요" placeholder="마일리지" onKeyPress="if (event.keyCode == 13){ jsSearchFaq(); }" />
							<button type="button" onClick="jsSearchFaq();">검색</button>
						</form>
						</fieldset>
						<ul class="ex">
							<li onClick="jsTxtSelect('반품');">반품</li>
							<li onClick="jsTxtSelect('교환');">교환</li>
							<li onClick="jsTxtSelect('배송비');">배송비</li>
							<li onClick="jsTxtSelect('마일리지');">마일리지</li>
							<li onClick="jsTxtSelect('쿠폰');">쿠폰</li>
						</ul>
					</div>
				</div>

				<% If vSearchTxt = "" Then %>
				<div class="faqbest faqlist">
					<h2>자주하는 질문 BEST 10</h2>
				<% Else %>
				<div class="faqsearch faqlist">
					<h2><strong>[<%=vSearchTxt%>]</strong> 검색결과 <strong><%=boardfaq.FResultCount%></strong>건</h2>
				<% End If %>
					<% If boardfaq.FResultCount < 1 Then %>
						<p class="noData"><strong>검색된 FAQ 내용이 없습니다.</strong></p>
					<% Else %>
					<ul>
						<% For i = 0 to (boardfaq.FResultCount - 1) %>
							<li>
								<a href="/cscenter/faq_view.asp?idx=<%= boardfaq.FItemList(i).FfaqId %>">
								<%= left(boardfaq.FItemList(i).Ftitle, 38) %></a>
							</li>
						<% Next %>
					</ul>
					<% End If %>
				</div>
			</div>
			<!-- //content area -->
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% set boardfaq = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->