<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.charset = "utf-8" %>
<%
'####################################################
' Description : (APP)다이어리스토리2016 이벤트페이지
' History : 2016-09-21 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/diarystory2017/lib/worker_only_view.asp" -->
<%' #include virtual="/apps/appCom/wish/web2014/diarystory2017/lib/classes/diary_class.asp" %>
<!-- #include virtual="/diarystory2017/lib/classes/diary_class_B.asp" -->
<!-- #include virtual="/lib/classes/search/searchcls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->

<%
dim odibest, i, selOp , scType, CurrPage, PageSize
	selOp		= requestCheckVar(Request("sop"),1) '정렬
	scType 		= requestCheckVar(Request("scT"),4) '쇼핑찬스 분류
	CurrPage 	= requestCheckVar(request("cpg"),9)
	
	IF CurrPage = "" then CurrPage = 1
	If selOp = "" then selOp = "0"

	PageSize = 10

	set odibest = new cdiary_list
		odibest.FPageSize = PageSize
		odibest.FCurrPage = CurrPage
		odibest.FselOp	 	= selOp			'이벤트정렬
		odibest.FSCType 	= scType    	'이벤트구분(전체,세일,사은품,상품후기, 신규,마감임박)
		odibest.FEScope = 2
		odibest.FEvttype = "1"
'		odibest.FEvttype = "19,26"
		odibest.Fisweb	 	= "0"
		odibest.Fismobile	= "1"
		odibest.Fisapp	 	= "1"
		odibest.fnGetdievent
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<link rel="stylesheet" type="text/css" href="/lib/css/diary2017.css" />
<script type="text/javascript">
$(function(){
	// event title control
	$('.listCardV16 ul li').each(function(){
		if ($(this).find('.label').children("b").length == 2) {
			$(this).find('.desc').children('p').children('strong').css('width','74%');
		} else if ($(this).find('.label').children("b").length == 1) {
			$(this).find('.desc').children('p').children('strong').css('width','86%');
		} else {
			$(this).find('.desc').children('p').children('strong').css('width','100%');
		}
	});
});

function jsGoUrl(sop){
	document.sFrm.sop.value = sop;
	document.sFrm.cpg.value = 1;
	document.sFrm.submit();
}

function jsGoPage(iP){
	document.sFrm.cpg.value = iP;
	document.sFrm.submit();
}

// 이벤트 이동
function goEventLink(evt) {
	<% if isApp then %>
//		fnAPPpopupEvent(evt);
		fnAPPpopupBrowserURL('다이어리 이벤트','http://m.10x10.co.kr/apps/appCom/wish/web2014/event/eventmain.asp?eventid='+evt);
	<% else %>
		parent.location.href='/event/eventmain.asp?eventid='+evt;
	<% end if %>
	return false;
}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry diarystory2017 diaryEvtMain">
			<!-- content area -->
			<form name="sFrm" method="get" action="/apps/appCom/wish/web2014/diarystory2017/event.asp">
			<input type="hidden" name="cpg" value="<%= odibest.FCurrPage %>"/>
			<input type="hidden" name="sop" value="<%= sElop %>"/>
			<div class="content" id="contentArea">
				<div><a href="" onclick="fnAPPpopupBrowserURL('사은품','http://m.10x10.co.kr/apps/appCom/wish/web2014/diarystory2017/gift.asp'); return false;"><img src="http://fiximage.10x10.co.kr/m/2016/diarystory2017/bnr_gift.jpg" alt="2017 다이어리 구매금액별 사은품" /></a></div>
				<section class="diaryEvent">
					<div class="sorting">
						<%' for dev msg : 선택시 클래스 current 넣어주세요 %>
						<button type="button" class="<%=chkIIF(sElop="0","selected","")%>" onclick="jsGoUrl('0'); return false;" >신규순</button>
						<button type="button" class="<%=chkIIF(sElop="2","selected","")%>" onclick="jsGoUrl('2'); return false;" >인기순</button>
						<!--<button type="button" class="<%'=chkIIF(sElop="1","selected","")%>" onclick="jsGoUrl('1'); return false;" >마감임박순</button>-->
					</div>

					<% If odibest.FResultCount > 0 Then %>
						<div class="listCardV16">
							<ul>
							<% FOR i = 0 to odibest.FResultCount -1 %>
								<li>
									<a href="" onclick="goEventLink('<%=odibest.FItemList(i).fevt_code %>'); return false;" >
										<div class="thumbnail"><img src="<%=odibest.FItemList(i).fevt_mo_listbanner %>" alt="<%=odibest.FItemList(i).FEvt_name %>" /></div>
										<div class="desc">
										<%
										Dim tmpevtname, tmpevtnamesale
										if ubound(Split(odibest.FItemList(i).FEvt_name,"|"))> 0 Then
											tmpevtname = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(0))
											tmpevtnamesale = cStr(Split(odibest.FItemList(i).FEvt_name,"|")(1))
										else
											tmpevtname = odibest.FItemList(i).FEvt_name
											tmpevtnamesale	= ""
										end if
											
										%>
											<p>
												<strong><%=db2html(tmpevtname) %></strong>
												<span><%=db2html(odibest.FItemList(i).FEvt_subname) %></span>
											</p>
											<% if tmpevtnamesale <> "" then %>
												<div class="label">
													<%' for dev msg : 할인율 표기 %>
													<b class="red"><span><i><%=db2html(tmpevtnamesale)%></i></span></b>
												</div>
											<% end if %>
										</div>
									</a>
								</li>
							<% next %>
							</ul>
						</div>
						<div class="paging">
							<%= fnDisplayPaging_New(CurrPage,odibest.FTotalCount,PageSize,10,"jsGoPage") %>
						</div>
					<% end if %>
				</section>
			</div>
			</form>
			<!-- //content area -->
			<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
		</div>
	</div>
</div>
</body>
</html>
<% set odibest = Nothing %>
<!-- #include virtual="/lib/db/dbclose.asp" -->