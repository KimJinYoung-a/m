<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'#######################################################
'	History	: 2014.09.17 한용민 생성
'	History	: 2015-04-28 이종화 디자인 수정
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

<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
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
	<div class="container popWin">
		<!-- content area -->
		<div class="content cs-main" id="contentArea">
			<div class="csguide">						
					<div class="customs-center type03">
                        <div class="info-open">
                            <div class="img"><img src="http://fiximage.10x10.co.kr/web2021/cscenter/m/icon_cscenter02.png" alt="cscenter"></div>
                            <div class="info-time">
                                <div class="time">
                                    <p class="txt">운영시간</p>
                                    <p class="num">10:00 ~ 17:00</p>
                                </div>
                                <div class="time type02">
                                    <p class="txt">점심시간</p>
                                    <p class="num02">12:30 ~ 13:30<br/><span class="sub-txt">(주말, 공휴일 휴무)</span></p>
                                </div>
                            </div>
                        </div>
                    </div>
					<div class="cs_request" style="width:100%">
						<a href="" onclick="fnAPPpopupBrowserURL('<%=CHKIIF(IsVIPUser()=True,"VIP ","")%>1:1 상담','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/qna/myqnalist.asp'); return false;">
							<h2>1:1 상담신청</h2>
						</a>
					</div>
					<div class="kakao">
						<a href="http://pf.kakao.com/_xiAFPs/chat" target="_blank">
							<h2>카카오 상담하기</h2>
						</a>
					</div>
			</div>
			<div class="bnr-wrap">
				<div class="bnr bnr-thank"><a href="" onclick="fnAPPpopupBrowserURL('고마워, 텐바이텐','<%=M_SSLUrl%>/apps/appcom/wish/web2014/cscenter/thanks10x10.asp','right','','sc'); return false;">고마워, 텐바이텐</a></div>
				<div class="bnr bnr-gifticon app_gifticon"><a href="" onclick="fnAPPpopupBrowserURL('기프티콘 상품교환','<%=wwwUrl%>/apps/appcom/wish/web2014/gift/gifticon/','right','','sc'); return false;">기프티콘 상품 교환<span class="icon"></span></a></div>
			</div>
			<div class="cs_float app_float">텐바이텐을 칭찬해주세요!</div>
			<div class="faq">
				<h2>FAQ 검색</h2>
				<div class="finder">
					<form name="frmFaq" method="get">
						<fieldset>
						<legend>FAQ 검색</legend>
							<input type="search" name="searchtxt" id="searchtxt" value="<%=vSearchTxt%>" title="검색어를 입력하세요" placeholder="마일리지" onKeyPress="if (event.keyCode == 13){ jsSearchFaq(); }" />
							<button type="button" onClick="jsSearchFaq();">검색</button>
						</fieldset>
					</form>

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
						<a href="/apps/appcom/wish/web2014/cscenter/faq_view.asp?idx=<%= boardfaq.FItemList(i).FfaqId %>">
							<%= left(boardfaq.FItemList(i).Ftitle, 38) %></a>
					</li>
					<% Next %>
				</ul>
				<% End If %>
			</div>
		</div>
		<!-- //content area -->
	</div>
</div>
</body>
</html>
<% set boardfaq = nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->