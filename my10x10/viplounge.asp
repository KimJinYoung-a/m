<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%Response.Addheader "P3P","policyref='/w3c/p3p.xml', CP='NOI DSP LAW NID PSA ADM OUR IND NAV COM'"%>
<%
Response.Charset ="UTF-8"
'####################################################
' Description : 마이텐바이텐 - VIP LOUNGE
' History : 2016-07-22 허진원
'####################################################
%>
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual ="/lib/classes/membercls/specialcornerCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "VIP LOUNGE"

'####### 회원등급 재조정 #######
Call getDBUserLevel2Cookie()
'####### 회원등급 재조정 #######

dim userid: userid = getEncLoginUserID ''GetLoginUserID
Dim userlevel, iCurrpage, iPageSize, iPerCnt, cSpchance, arrList, iTotCnt, iTotalPage, intLoop


	userlevel = GetLoginUserLevel
	'VIP 등급이 아니면 안내문 출력 후 홈으로 이동
	If not(userlevel="3" or userlevel="4" or userlevel="6" or userlevel="7") Then
		Call Alert_Move("죄송합니다. VIP회원님을 위한 전용공간입니다.","/")
		dbget.Close(): response.End
	End If

	'파라미터값 받기 & 기본 변수 값 세팅
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	IF iCurrpage = "" THEN	iCurrpage = 1

	iPageSize = 10		'한 페이지의 보여지는 열의 수
	iPerCnt = 4			'보여지는 페이지 간격

	'// 우수회원 전용코너 목록 불러오기
	set cSpchance = new CVip
	cSpchance.FCurrPage 		= iCurrpage		'현재페이지
	cSpchance.FPageSize 		= iPageSize		'페이지 사이즈
	cSpchance.GetVipCornerList					'리스트 가져오기
	iTotCnt = cSpchance.FTotalCount 			'배너리스트 총 갯수
	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: VIP LOUNGE</title>
<script type="text/javascript">
function goPage(iP){
		document.frmLounge.iC.value = iP;
		document.frmLounge.submit();
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container" style="background-color:#e7eaea;">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="evtIndexV16a">
					<h2 class="hidden">VIP LOUNGE</h2>
					<% IF iTotalPage > 0 THEN %>
					<section class="listCardV16">
						<ul>
						<% For intLoop=0 To (cSpchance.FTotalCount-1) %>
							<li>
								<a href="/event/eventmain.asp?eventid=<%=cSpchance.FItemList(intLoop).FevtCode%>">
									<div class="thumbnail"><img src="<%=webImgUrl&"/vipcorner/"&cSpchance.FItemList(intLoop).Fpcimg%>" alt="<%=cSpchance.FItemList(intLoop).FevtName%>" /></div>
									<div class="desc">
										<p>
											<strong><%=cSpchance.FItemList(intLoop).FevtName%></strong>
											<span><%=cSpchance.FItemList(intLoop).FevtSubCopy%></span>
										</p>
									</div>
								</a>
							</li>
						<% Next %>
						</ul>
					</section>

					<div class="paging">
						<%=fnDisplayPaging_New(iCurrpage,iTotCnt,iPageSize,4,"goPage")%>
					</div>
					<form name="frmLounge" method="post" action="viplounge.asp">
					<input type="hidden" name="iC" value="<%=iCurrpage%>">
					</form>
					<% Else %>
					<div class="emptyMsgV16a emptyExhtV16a">
						<div>
							<p>시크릿 이벤트가 곧 오픈될 예정입니다.<br />곧 오픈될 이벤트들도 기대해 주세요!</p>
						</div>
					</div>
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
<%
	set cSpchance = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->