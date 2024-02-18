<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/classes/enjoy/shoppingchanceCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<%
	Dim scType, sCategory, sCateMid, vIsMine
	Dim cShopchance
	Dim iTotCnt, arrList,intLoop
	Dim iPageSize, iCurrpage ,iDelCnt
	Dim iStartPage, iEndPage, iTotalPage, ix,iPerCnt, k
	Dim atype, selOp
	atype = RequestCheckVar(request("atype"),1)
	if atype="" then atype="b"

	selOp		=  requestCheckVar(Request("selOP"),1) '정렬
	vIsMine		= requestCheckVar(Request("ismine"),1)
	
	If vIsMine = "o" Then
		selOp = ""
		sCategory = ""
	End If

	'파라미터값 받기 & 기본 변수 값 세팅
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	sCategory 	= requestCheckVar(Request("disp"),3) '카테고리 대분류
	iCurrpage 	= requestCheckVar(Request("iC"),10)	'현재 페이지 번호

	If scType ="end" then
		selOp = "1"
	ElseIf selOp = "" Then
		selOp = "0"
	End if

	IF iCurrpage = "" THEN	iCurrpage = 1


	iPageSize = 12
	iPerCnt = 4		'보여지는 페이지 간격


	'데이터 가져오기
	set cShopchance = new ClsShoppingChance
	cShopchance.FCPage 			= iCurrpage		'현재페이지
	cShopchance.FPSize 			= iPageSize		'페이지 사이즈
	cShopchance.FSCType 		= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
	cShopchance.FSCategory 		= sCategory 	'제품 카테고리 대분류
	cShopchance.FSCateMid 		= sCateMid		'제품 카테고리 중분류
	cShopchance.FEScope 		= 2				'view범위: 10x10
	cShopchance.FselOp	 		= selOp			'이벤트정렬
	cShopchance.FUserID			= CHKIIF(vIsMine="o",GetLoginUserID(),"")
	cShopchance.Fis2014renew	= "o"			'2014리뉴얼구분
	arrList = cShopchance.fnGetAppBannerList	'배너리스트 가져오기
	iTotCnt = cShopchance.FTotCnt 				'배너리스트 총 갯수
	set cShopchance = nothing

	iTotalPage =   int((iTotCnt-1)/iPageSize) +1  '전체 페이지 수
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script type="text/javascript">
function jsGoPage(iP){
	document.frmSC.iC.value = iP;
	document.frmSC.action = "/apps/appcom/wish/webview/event/eventlist.asp";
	document.frmSC.submit();
}

function jsIsMine(a){
<% If IsUserLoginOK() Then %>
	document.frmSC.iC.value = 1;
	document.frmSC.ismine.value = a;
	document.frmSC.action = "/apps/appcom/wish/webview/event/eventlist.asp";
	document.frmSC.submit();
<% Else %>
	calllogin();
	return false;
<% End If %>
}

function jsSelOp(a){ //이벤트정렬
	document.frmSC.iC.value = 1;
	document.frmSC.selOP.value = a;
	document.frmSC.action = "/apps/appcom/wish/webview/event/eventlist.asp";
	document.frmSC.submit();
}

//카테고리 변경
function jsGoUrl(scT, disp){
	document.frmSC.disp.value = disp;
	document.frmSC.scT.value = scT;
	document.frmSC.submit();
}

function jsGoEvent(ecd) { //이벤트 상세 이동
	location.href="eventmain.asp?eventid=" + ecd;
}

var vPg=1, vScrl=true;
$(function(){
	// 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "act_eventlist.asp?&scT=<%=scType%>&disp=<%=sCategory%>&selOP=<%=selOp%>&ismine=<%=vIsMine%>&iC="+vPg,
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#lyrEvtList").append(message);
							vScrl=true;
						} else {
							$(window).unbind("scroll");
						}
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$(document).ajaxStart(function(){
		$("#lyLoading").show();
	}).ajaxStop(function(){
		$("#lyLoading").hide();
	});
});
</script>
<style>
a {text-decoration:none; color:inherit;}
img {width:100%;}
* {box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.bgGry {background-color:#f4f7f7;}
.cBl2 {color:#18b1d7 !important;}
.cGr2 {color:#1fbcb6 !important;}
.inner5 {padding-left:5px; padding-top:5px; padding-right:5px; padding-bottom:5px; overflow:hidden;}.sorting {padding:5px 0 15px; display:table; width:100%;}
.evtList li {margin-top:20px; border-bottom:1px solid #d0d2d2;}
.evtList li:first-child {padding-top:0; border-top:0;}
.evtList li img {vertical-align:top; display:inline;}
.evtList li dl {text-align:center; padding:14px 0 16px; border-top:0; background:#fff; margin:0;}
.evtList li dt {font-weight:bold; font-size:14px; color:#000;}
.evtList li dd {padding-top:5px; font-size:12px; color:#888; margin:0;}

@media all and (min-width:480px){
	.inner5 {padding-left:7px; padding-top:7px; padding-right:7px; padding-bottom:7px;}
	.evtList li {margin-top:30px;}
	.evtList li dl {padding:21px 0 24px;}
	.evtList li dt {font-size:21px;}
	.evtList li dd {padding-top:7px; font-size:18px;}
}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content evtMain" id="contentArea">
				<div class="inner5">
					<div class="two-inputs" style="padding:10px 0 30px 0;">
						<div class="col">
							<select id="category1" class="form red" onchange="jsGoUrl('<%=scType%>',this.value);">
								<option <%=CHKIIF(sCategory="","selected","")%> value="">카테고리 보기</option>
								<option <%=CHKIIF(sCategory="101","selected","")%> value="101">디자인문구</option>
								<option <%=CHKIIF(sCategory="102","selected","")%> value="102">디지털/핸드폰</option>
								<option <%=CHKIIF(sCategory="104","selected","")%> value="104">토이/취미</option>
								<option <%=CHKIIF(sCategory="105","selected","")%> value="114">가구</option>
								<option <%=CHKIIF(sCategory="106","selected","")%> value="106">홈인테리어</option>
								<option <%=CHKIIF(sCategory="107","selected","")%> value="112">키친/푸드</option>
								<option <%=CHKIIF(sCategory="108","selected","")%> value="113">패션/뷰티</option>
								<option <%=CHKIIF(sCategory="109","selected","")%> value="115">베이비</option>
								<option <%=CHKIIF(sCategory="110","selected","")%> value="110">CAT&amp;DOG</option>
							</select>
						</div>
						<div class="col">
							<select id="category2" class="form red" onchange="jsGoUrl(this.value,'');">
								<option <%=CHKIIF(scType="","selected","")%> value="">전체이벤트</a></li>
								<option <%=CHKIIF(scType="ten","selected","")%> value="ten">단독이벤트</a></li>
								<option <%=CHKIIF(scType="sale","selected","")%> value="sale">할인이벤트</a></li>
								<option <%=CHKIIF(scType="gift","selected","")%> value="gift">사은이벤트</a></li>
								<option <%=CHKIIF(scType="ips","selected","")%> value="ips">참여이벤트</a></li>
								<option <%=CHKIIF(scType="test","selected","")%> value="test">테스터후기</a></li>
								<option <%=CHKIIF(scType="end","selected","")%> value="end">마감임박</a></li>
							</select>
						</div>
					</div>

					<%	
						'### 배열번호
						' 0 ~ 7  : A.evt_code, B.evt_bannerimg, A.evt_startdate, A.evt_enddate, A.evt_kind, B.brand,B.evt_LinkType ,B.evt_bannerlink '
						' 8		 : ,(Case When A.evt_kind=13 Then (Select top 1 itemid from [db_event].[dbo].[tbl_eventitem] where evt_code=A.evt_code order by itemid desc) else 0 end) as itemid '
						' 9 ~ 20 : , B.evt_bannerimg_mo, A.evt_name, B.issale, B.isgift, B.iscoupon, B.isOnlyTen, B.isoneplusone, B.isfreedelivery, B.isbookingsell, B.iscomment, B.etc_itemid, A.evt_subcopyK '
						'21		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select isNull(basicimage600,'''') from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage600 '
						'22		 : , case when isNull(B.etc_itemimg,'''') = '''' then (select basicimage from db_item.dbo.tbl_item where itemid = B.etc_itemid) end as basicimage '
						'23	~ 24 : , A.evt_subname, B.evt_mo_listbanner '

						Dim vLink, vIcon
						
						IF isArray(arrList) THEN %>
						<ul class="evtList" id="lyrEvtList">
							<%
							For intLoop =0 To UBound(arrList,2)
								IF arrList(6,intLoop)="I" and arrList(7,intLoop)<>"" THEN '링크타입 체크
									vLink = "location.href='" & arrList(7,intLoop) & "';"
								ELSE
									vLink = "jsGoEvent(" & arrList(0,intLoop) & ");return false;"
								END IF

								If arrList(12,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">GIFT</span>" End IF
								If arrList(18,intLoop) AND vIcon = "" Then vIcon = " <span class=""cBl2"">참여</span>" End IF
								If arrList(15,intLoop) AND vIcon = "" Then vIcon = " <span class=""cGr2"">1+1</span>" End IF
								
								'If arrList(11,intLoop) Then vIcon = "" End IF
								'If arrList(13,intLoop) Then vIcon = "" End IF
								'If datediff("d",arrList(2,intLoop),date)<=3 Then vIcon = "" End IF
							%>
								<li onclick="<%=vLink%>">
									<div class="pic"><img src="<%=chkiif(arrList(24,intLoop)="",arrList(25,intLoop),arrList(24,intLoop))%>" alt="<%=db2html(arrList(10,intLoop))%>" /></div>
									<dl>
										<dt><%=db2html(arrList(10,intLoop))%><%=vIcon%></dt>
										<dd><%=db2html(arrList(23,intLoop))%></dd>
									</dl>
								</li>
							<%
								vLink = ""
								vIcon = ""
								Next %>
						</ul>
					 <% Else %>
					<div class="tMar20">
						<div class="noData">
						<%=chkIIF(vIsMine="o","<p>등록된 관심 이벤트가 없습니다.</p>","<p>진행중인 이벤트가 없습니다.</p>")%>
						</div>
					</div>
					<% End If %>
					<div id="lyLoading" style="display:none;position:relative;text-align:center; padding:20px 0;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
					<form name="frmSC" method="get" action="/apps/appcom/wish/webview/event/eventlist.asp" style="margin:0px;">
					<input type="hidden" name="iC" >
					<input type="hidden" name="scT" value="<%=scType%>">
					<input type="hidden" name="disp" value="<%=sCategory%>">
					<input type="hidden" name="selOP" value="<%=selOP%>">
					<input type="hidden" name="ismine" value="<%=vIsMine%>">
					</form>
				</div>
			</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</div>
</body>
</html>