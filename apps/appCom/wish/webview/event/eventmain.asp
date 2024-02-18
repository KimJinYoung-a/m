<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL, DateViewYN
dim itemid : itemid = ""
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt
Dim j

Dim upin '카카오 이벤트 key값 parameter
	upin = requestCheckVar(Request("upin"),200)

IF eCode = "" THEN
	'response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
	Call Alert_Return("이벤트번호가 없습니다.")
	dbget.close()	:	response.End
elseif Not(isNumeric(eCode)) then
	Call Alert_Return("잘못된 이벤트번호입니다.")
	dbget.close()	:	response.End
END IF

egCode = requestCheckVar(Request("eGC"),10)	'이벤트 그룹코드
IF egCode = "" THEN egCode = 0

	itemlimitcnt = 105	'상품최대갯수
	'이벤트 개요 가져오기
	set cEvent = new ClsEvtCont
		cEvent.FECode = eCode

		cEvent.fnGetEvent

		eCode		= cEvent.FECode
		ekind		= cEvent.FEKind
		emanager	= cEvent.FEManager
		escope		= cEvent.FEScope
		eName		= cEvent.FEName
		esdate		= cEvent.FESDate
		eedate		= cEvent.FEEDate
		estate		= cEvent.FEState
		eregdate	= cEvent.FERegdate
		epdate		= cEvent.FEPDate
		ecategory	= cEvent.FECategory
		ecateMid	= cEvent.FECateMid
		blnsale		= cEvent.FSale
		blngift		= cEvent.FGift
		blncoupon	= cEvent.FCoupon
		blncomment	= cEvent.FComment
		blnbbs		= cEvent.FBBS
		blnitemps	= cEvent.FItemeps
		blnapply	= cEvent.FApply
		etemplate	= cEvent.FTemplate
		emimg		= cEvent.FEMimg
		ehtml		= cEvent.FEHtml
		eitemsort	= cEvent.FItemsort
		ebrand		= cEvent.FBrand
		gimg		= cEvent.FGimg
		blnFull		= cEvent.FFullYN
		blnItemifno = cEvent.FIteminfoYN
		blnitempriceyn = cEvent.FItempriceYN
		LinkEvtCode = cEvent.FLinkEvtCode
		blnBlogURL	= cEvent.FblnBlogURL
		DateViewYN	= cEvent.FDateViewYN

		IF etemplate = "3" THEN	'그룹형(etemplate = "3")일때만 그룹내용 가져오기
		cEvent.FEGCode = 	egCode
		arrGroup =  cEvent.fnGetEventGroup
		END IF

		cEvent.FECategory  = ecategory
		arrRecent = cEvent.fnGetRecentEvt
	set cEvent = nothing
		cdl_e = ecategory
		cdm_e = ecateMid

		IF cdl_e = "" THEN blnFull= True	'카테고리가 없을경우 전체페이지로
		IF eCode = "" THEN
		Alert_return("유효하지 않은 이벤트 입니다.")
		dbget.close()	:	response.End
		END IF

	'// 이벤트 링크 보정
	if Not(ehtml="" or isNull(ehtml)) then
		ehtml = replace(ehtml,"href=""/event/eventmain.asp","href=""/apps/appCom/wish/webview/event/eventmain.asp")
	end if
	
strPageTitle = "생활감성채널, 텐바이텐 > 이벤트 > " & eName
%>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<script>
	var ecode = "<%=eCode%>";
	function jsEventLoginCheck(){
	<% If IsUserLoginOK() Then %>
		return "True";
	<% Else %>
		return "False";
	<% End If %>
	}
	$(function(){
		seltopmenu('event');
	});
	</script>
<style type="text/css">
.ellipsis1{
 overflow: hidden;
 text-overflow: ellipsis;
 white-space:nowrap;
}
.ellipsis2{
 overflow: hidden;
 text-overflow: ellipsis;
 display: -webkit-box;
 -webkit-line-clamp: 2;
 -webkit-box-orient: vertical;
 word-wrap:break-word;
}
</style>
</head>
<body class="event">
    <!-- wrapper -->
    <div class="wrapper">    
        
        <!-- #header -->
        <header id="header">
            <h1 class="event-title"><%=eName%></h1>
            <span class="event-date"><% if Not(DateViewYN) then %><%=Replace(esdate,"-",".")%> ~ <%=Replace(eedate,"-",".")%><% end if %></span>
        </header>
        <!-- #content -->
        <div id="content">
			<%
			  SELECT CASE etemplate
				CASE "3" '그룹형
			%>
			<div class="inner">
			<%
				IF isArray(arrGroup) THEN
				   If arrGroup(0,0) <> "" Then	
					   if arrGroup(3,0) <> "" then
			%>
					<img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" class="fluid-width" usemap="#mapGroup<%=egCode%>" width="100%" />
			<%
					   End If 
			%>
					<map name="mapGroup<%=egCode%>"><%=replace(db2html(arrGroup(4,0)),"href=""/event/eventmain.asp","href=""/apps/appCom/wish/webview/event/eventmain.asp")%></map>
				<% if arrGroup(5,0)<>"0" then %>
					<div class="main-title">
						<h1 class="title"><span class="label"><%=arrGroup(1,0)%></span></h1>
					</div>
				<% end if %>
				<% egCode = arrGroup(0,0) %>
				<% sbEvtItemList_Apps %>
			<%
					j = 1
					End If 

					For intG = j To UBound(arrGroup,2)
					egCode = arrGroup(0,intG)
			%>
					<%if arrGroup(3,intG) <> "" then%>
					<img src="<%=arrGroup(3,intG)%>" class="fluid-width" usemap="#mapGroup<%=egCode%>" alt="<%=egCode%>" width="100%"/>
					<%end if%>
					<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,intG))%></map>
					<a name="event_namelink<%=intG%>"></a>
					<% if arrGroup(5,intG)<>"0" then %>
					<div class="main-title">
						<h1 class="title"><span class="label"><%=arrGroup(1,intG)%></span></h1>
					</div>
					<% end if %>
					<% sbEvtItemList_Apps %>
			<%
					Next
				END IF
			%>
			</div>
			<% 	CASE "5" '수작업%>
				<% If eCode = 21264 Then %>
				<div><iframe id="21264" src="/apps/appCom/wish/webview/event/etc/kakao_invite/iframe_54106.asp?upin=<%=upin%>" width="100%" height="100%" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
				<% ElseIf eCode = 54106 Then %>
				<div><iframe id="54106" src="/apps/appCom/wish/webview/event/etc/kakao_invite/iframe_54106.asp?upin=<%=upin%>" width="100%" height="100%" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>			
				<% else %>
				<%=ehtml%>
				<% end if %>
			<% 	CASE "6" '수작업+상품목록%>
			<div class="inner">
				<%=ehtml%>
				<ul class="product-list list-type-2">
					<% sbEvtItemView_Apps %>
				</ul>
				<div class="diff clear"></div>
			</div>
			<% 	CASE ELSE '기본:메인이미지+상품목록%>
			<div class="inner">
				<% if Not(emimg="" or isNull(emimg)) then %><img src="<%=emimg%>" class="fluid-width" usemap="#Mainmap" alt="<%=emimgAlt%>"/><% end if %><%=ehtml%>
				<ul class="product-list list-type-2">
					<% sbEvtItemView_Apps %>
				</ul>
				<div class="diff"></div>
			</div>
			<% END SELECT %>
			<!--/템플릿에 따른 화면 구성-->
			<%
				if blncomment then

					dim cEComment, iCTotCnt, arrCList

					'코멘트 데이터 가져오기
					set cEComment = new ClsEvtComment

					if LinkEvtCode>0 then
						cEComment.FECode 		= LinkEvtCode	'관련코드 = 온라인 코드
					else
						cEComment.FECode 		= eCode
					end if
					cEComment.FComGroupCode	= com_egCode
					cEComment.FEBidx    	= bidx
					cEComment.FCPage 		= 1	'현재페이지
					cEComment.FPSize 		= 1	'페이지 사이즈
					cEComment.FTotCnt 		= -1  '전체 레코드 수
					arrCList = cEComment.fnGetComment
					iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
					set cEComment = nothing
			%>
	            <div class="comment-info t-c">
	                총 <span class="red"><%=iCTotCnt%></span>개의 코멘트가 있습니다.
	            </div>
	            <div class="form-actions">               
	                <div class="two-btns">
	                    <div class="col"><a href="event_write.asp?eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>" class="btn type-b">쓰기</a></div>
	                    <div class="col"><a href="event_comment.asp?eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>" class="btn type-a">전체보기</a></div>
	                </div>
	            </div>
			<% end if %>
			<div class="clear"></div>
        </div><!-- #content -->
		<script>
		<!--
			function jsDownCoupon(stype,idx){
			<% IF IsUserLoginOK THEN %>
			var frm;
				frm = document.frmC;
				//frm.target = "iframecoupon";
				frm.action = "/shoppingtoday/couponshop_process.asp";
				frm.stype.value = stype;
				frm.idx.value = idx;
				frm.submit();
			<%ELSE%>
				if(confirm("로그인하시겠습니까?")) {
					self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
				}
			<%END IF%>
			}

		//-->
		</script>
		<form name="frmC" method="post">
		<input type="hidden" name="stype" value="">
		<input type="hidden" name="idx" value="">
		</form>
		<iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
		<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js?v=1.9"></script>
        <!-- #footer -->
        <footer id="footer">
            <% if flgDevice="I" then %><a href="#" class="btn-back">back</a><% end if %>
            <a href="#" class="btn-top">top</a>
        </footer><!-- #footer -->
    </div><!-- wrapper -->
    <!-- #include virtual="/apps/appCom/wish/webview/lib/incFooter.asp" -->
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->