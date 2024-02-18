<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_TTT.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate, emimg, ehtml, eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
Dim evtFile : evtFIle = ""
dim egCode, itemlimitcnt,iTotCnt, vDateView
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt
Dim j
Dim evtmolistbanner

Dim upin '카카오 이벤트 key값 parameter
	upin = requestCheckVar(Request("upin"),200)

Dim vScope '// 별에서 온 운세 값(58021)
	vScope = requestCheckVar(Request("vScope"),200)

IF eCode = "" THEN 
	'response.redirect("/shoppingtoday/shoppingchance_allevent.asp")
	Call Alert_Return("이벤트번호가 없습니다.11")
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
		edispcate	= cEvent.FEDispCate
		eItemListType = cEvent.FEItemListType
		evtmolistbanner = cEvent.FEmolistbanner
		evtFile = cEvent.FevtFile

		vDateView	= cEvent.FDateViewYN

		If Not(cEvent.FEItemImg="" or isNull(cEvent.FEItemImg)) then
			bimg		= cEvent.FEItemImg
		ElseIf cEvent.FEItemID<>"0" Then
			If cEvent.Fbasicimg600 <> "" Then
				bimg		= "http://webimage.10x10.co.kr/image/basic600/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg600 & ""
			Else
				bimg		= "http://webimage.10x10.co.kr/image/basic/" & GetImageSubFolderByItemid(cEvent.FEItemID) & "/" & cEvent.Fbasicimg & ""
			End IF
		Else
			bimg		= ""
		End If
		
		If IsNull(evtFile) Then
			evtFile = ""
		End If		
		
		IF etemplate = "3" THEN	'그룹형(etemplate = "3")일때만 그룹내용 가져오기		
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup					
		END IF
		
		cEvent.FECategory  = ecategory
		'arrRecent = cEvent.fnGetRecentEvt
	set cEvent = nothing
		cdl_e = ecategory	
		cdm_e = ecateMid
		
		IF cdl_e = "" THEN blnFull= True	'카테고리가 없을경우 전체페이지로		
		IF eCode = "" THEN 
		Alert_return("유효하지 않은 이벤트 입니다.")
		dbget.close()	:	response.End
		END IF
		
	'// 내 관심 이벤트 확인
	if IsUserLoginOK then
		set clsEvt = new CMyFavoriteEvent
			clsEvt.FUserId = getEncLoginUserID
			clsEvt.FevtCode = eCode
			isMyFavEvent = clsEvt.fnIsMyFavEvent
		set clsEvt = nothing
	end If
	
	'// 쇼셜서비스로 글보내기 (2014-09-24 이종화)
	dim snpTitle, snpLink, snpPre, snpImg
	snpTitle = Server.URLEncode(eName)
	snpLink = Server.URLEncode(wwwUrl&"/event/eventmain.asp?eventid="&eCode)
	snpPre = Server.URLEncode("10x10 이벤트")
	If evtmolistbanner <> "" Then 
	snpImg = Server.URLEncode(evtmolistbanner)
	End If 
	
	strPageTitle = "생활감성채널, 텐바이텐 > 이벤트 > " & eName
%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type='text/javascript' src='/lib/js/jquery.lazyload.min.js'></script>
<script>
function fnMyEvent() {
<% If IsUserLoginOK Then %>
	$.ajax({
		url: "/my10x10/myfavorite_eventProc.asp?hidM=U&eventid=<%=eCode%>",
		cache: false,
		async: false,
		success: function(message) {
			if($("#myfavoriteevent").attr("class") == "circleBox wishView wishActive"){
				$("#myfavoriteevent").removeClass("wishActive");
				alert("선택하신 이벤트가 삭제 되었습니다.");
			}else{
				$("#myfavoriteevent").addClass("wishActive");
				alert("관심 이벤트로 등록되었습니다.");
			}
		}
	});
<% Else %>
	calllogin();
	return false;
<% End If %>
}

function DelComments(v){
	if (confirm('삭제 하시겠습니까?')){
		document.frmact.mode.value= "del";
		document.frmact.Cidx.value = v;
		document.frmact.submit();
	}
}

function goGroupSelect(v,a){
	$('html, body').animate({
	    scrollTop: $("#group"+v+"").offset().top
	}, 300)
	
	$("#group"+a+" > option[value="+a+"]").attr("selected", "true");
}

// SNS 공유 팝업
function fnAPPRCVpopSNS(){
	fnAPPpopupBrowserURL("공유","<%=wwwUrl%>/apps/appcom/wish/web2014/common/popShare.asp?sTit=<%=snpTitle%>&sLnk=<%=snpLink%>&sPre=<%=snpPre%>&sImg=<%=snpImg%>");
	return false;
}

$(function(){
	/* 코멘트 남기러 가기 버튼 추가 */
	$(".btnComment .button a").click(function(event){
		event.preventDefault();
		$('html,body').animate({scrollTop:$(this.hash).offset().top}, 500);
	});

	// 순차 로딩
	$("img.lazy").lazyload().removeClass("lazy");
	
});

function parent_kakaolink(label , imageurl , width , height , linkurl ){
	//카카오 SNS 공유
	Kakao.init('c967f6e67b0492478080bcf386390fdd');

	Kakao.Link.sendTalkLink({
	  label: label,
		image: {
		src: imageurl,
		width: width,
		height: height
		},
	appButton: {
		text: '10X10 앱으로 이동',
		execParams :{
			android: { url: linkurl},
			iphone: { url: linkurl}
		}
	  },
	installTalk : Boolean
  });
}
</script>
</head>
<body>
<div class="heightGrid">

	<div class="container bgGry">
		<!-- content area -->
		<div class="content evtView" id="contentArea">
			<% If eCode <> "60432" And eCode <> "61319" Then '//웨딩 기획전 제외 임시 %>
			<div class="evtViewHead">
				<h2><%=eName%></h2>
				<p class="date"><%=chkIIF(vDateView,"&nbsp;",Replace(esdate,"-",".") & " ~ " & Replace(eedate,"-","."))%></p>
				<div class="btnWrap">
					<% If evtmolistbanner <> "" Then %><p id="myfavoriteevent" class="circleBox wishView<%=chkIIF(isMyFavEvent," wishActive","")%>" onclick="fnMyEvent()"><span>찜하기</span></p><% End If %>
				</div>
			</div>
			<% End If %>
			<% SELECT CASE etemplate
				CASE "3" '그룹형
			%>
					<div class="evtCont">
						<%
							IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
								Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
							END IF
							
							If arrGroup(0,0) <> "" Then	
								if arrGroup(3,0) <> "" then
						%>
								<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
						<%
								End If
						%>
								<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
						<%
							End If
						%>
						</div>
						<% egCode = arrGroup(0,0) %>
						<% if blncomment then %>
						<div class="btnComment">
							<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
						</div>
						<% end if %>
						<% sbEvtItemView_app %>
		
						<%
						Dim vGroupOption
						If isArray(arrGroup) THEN
							For intG = 1 To UBound(arrGroup,2)
								vGroupOption = vGroupOption & "<option value="""&arrGroup(0,intG)&""">" & db2html(arrGroup(1,intG)) & "</option>"
							Next
							
							For intG = 1 To UBound(arrGroup,2)
								egCode = arrGroup(0,intG)
						%>
								<div class="inner10">
								<select class="groupBar" id="group<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
									<%=vGroupOption%>
								</select>
								</div>
								<% sbEvtItemView_app %>
								<script>$("#group<%=arrGroup(0,intG)%> > option[value=<%=arrGroup(0,intG)%>]").attr("selected", "true");</script>
						<%
							Next
						Else
							Call sbEvtItemView_app
						End If
				CASE "5" '수작업
			%>
					<% If eCode = 56927 Then %>
						<div><iframe id="56927" src="/event/etc/iframe_56927.asp?upin=<%=upin%>" width="100%" height="1000" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
					<% ElseIf eCode="58131" Then %>
						<div><iframe id="58131" src="/apps/appCom/wish/web2014/event/etc/iframe_58131.asp?vScope=<%=vScope%>" width="100%" height="500" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
					<% Else %>
						<% If Trim(evtFile)="" Then %>
							<div><%=ehtml%></div>
						<% Else %>
							<% If checkFilePath(server.mappath(evtFile)) Then %>
								<div><% server.execute(evtFile)%></div>
							<% Else %>
								<div><%=ehtml%></div>
							<% End If %>
						<% End If %>								
					<% End If %>
			<%	CASE "6" '수작업+상품목록 %>
						<div><%=ehtml%></div>
						<% if blncomment then %>
						<div class="btnComment">
							<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
						</div>
						<% end if %>
						<% sbEvtItemView_app %>
			<%	CASE ELSE '기본:메인이미지+상품목록 %>
					<div class="evtCont">
					<%
						IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
							Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
						END IF
					%>
						<% If emimg <> "" Then %><div><img src="<%=emimg%>" alt="<%=eName%>" /></div><% End If %>
					</div>
					<% if blncomment then %>
					<div class="btnComment">
						<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
					</div>
					<% end if %>
					<% sbEvtItemView_app %>
			<%	End SELECT %>

			<% if blncomment then
				dim cEComment, iCTotCnt, arrCList, intCLoop

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
				cEComment.FPSize 		= 3	'페이지 사이즈
				cEComment.FTotCnt 		= -1  '전체 레코드 수
				arrCList = cEComment.fnGetComment
				iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
				set cEComment = nothing
			%>
			<div class="inner5">
				<div id="replyList" class="replyList box1">
					<p class="total">총 <em class="cRd1"><%=iCTotCnt%></em>개의 댓글이 있습니다.</p>
					<%IF isArray(arrCList) THEN
						dim arrUserid, bdgUid, bdgBno
						'사용자 아이디 모음 생성(for Badge)
						for intCLoop = 0 to UBound(arrCList,2)
							arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
						next
	
						'뱃지 목록 접수(순서 랜덤)
						Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
					%>
							<ul>
								<%For intCLoop = 0 To UBound(arrCList,2)%>
								<li>
									<p class="num"><%=iCTotCnt-intCLoop-(Int(iCTotCnt/3)*(1-1))%><% If arrCList(8,intCLoop) <> "W" Then %><span class="mob"><img src="http://fiximage.10x10.co.kr/m/2014/common/ico_mobile.png" alt="모바일에서 작성" /></span><% End If %></p>
									<div class="replyCont">
										<p><%=striphtml(db2html(arrCList(1,intCLoop)))%></p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<p class="tPad05">
											<span class="button btS1 btWht cBk1"><a href="" onClick="DelComments('<% = arrCList(0,intCLoop) %>'); return false;">삭제</a></span>
										</p>
										<% end if %>
										<div class="writerInfo">
											<p><%=FormatDate(arrCList(4,intCLoop),"0000.00.00")%> <span class="bar">/</span> <% if arrCList(2,intCLoop)<>"10x10" then %><%=printUserId(arrCList(2,intCLoop),2,"*")%><% End If %></p>
											<p class="badge">
												<%=getUserBadgeIcon(arrCList(2,intCLoop),bdgUid,bdgBno,3)%>
											</p>
										</div>
									</div>
								</li>
								<% Next %>
							</ul>
					<% ELSE %>
						<p class="no-data ct">해당 게시물이 없습니다.</p>
					<% END IF %>
					<div class="btnWrap ct tPad15">
						<span class="button btM2 btRed cWh1 w30p"><a href="#" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;">쓰기</a></span>
						<span class="button btM2 btRedBdr cRd1 w30p"><a href="#" onClick="fnAPPpopupBrowserURL('코멘트','<%=wwwUrl%>/apps/appCom/wish/web2014/event/event_comment.asp?view=l&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;">전체보기</a></span>
					</div>
				</div>
			</div>
			<% end if %>
			<form name="frmact" method="post" action="/apps/appCom/wish/web2014/event/lib/doEventComment.asp" target="iframeDB" style="margin:0px;">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="returnurl" value="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=<%= eCode %>&comm=o">
			<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
			<input type="hidden" name="eventid" value="<%= eCode %>">
			<input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
			</form>
			<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
			<%
				Dim vArrIssue, vLink
				set cEvent = new ClsEvtCont
					cEvent.FECode = eCode
					cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
					cEvent.FBrand = ebrand
					cEvent.FEDispCate = edispcate
					vArrIssue = cEvent.fnEventISSUEList
				set cEvent = nothing
			%>
			<% If eCode <> "60432" And eCode <> "61319" Then '//웨딩 기획전 제외 임시 %>
			<% If isArray(vArrIssue) THEN %>
			<div class="inner5">
				<div class="evtnIsu box1">
					<h2><span>EVENT &amp; ISSUE</span></h2>
					<ul class="list01">
					<% For intCLoop = 0 To UBound(vArrIssue,2)
						IF vArrIssue(2,intCLoop)="I" and vArrIssue(3,intCLoop)<>"" THEN '링크타입 체크
							''vLink = "fnAPPpopupEvent_URL('" & vArrIssue(3,intCLoop) & "');"
							vLink=vArrIssue(3,intCLoop)
						ELSE
							''vLink = "fnAPPpopupEvent('" & vArrIssue(0,intCLoop) & "'); return false;"
							vLink="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=" & vArrIssue(0,intCLoop)
						END IF
					%>
						<li><a href="<%=vLink%>"><%=db2html(vArrIssue(1,intCLoop))%></a></li>
					<% Next %>
					</ul>
				</div>
			</div>
			<% End If %>
			<% End If %>
		</div>
		<!-- //content area -->
	</div>
	<!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</div>
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->