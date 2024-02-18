<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/functions.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls_B.asp" -->
<!-- #include virtual="/lib/classes/event/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoriteEventCls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/DBcacheLib.asp" -->
<%'쇼핑찬스 이벤트 내용보기
dim eCode : eCode   = requestCheckVar(Request("eventid"),10) '이벤트 코드번호
dim cEvent, cEventItem, arrItem, arrGroup, intI, intG , intT
dim arrRecent, intR
dim bidx
dim ekind, emanager, escope, eName, esdate, eedate, estate, eregdate, epdate, bimg, eItemListType
dim ecategory, ecateMid, blnsale, blngift, blncoupon, blncomment, blnbbs, blnitemps, blnapply, edispcate
dim etemplate_mo, emimg , emimg_mo , eitemsort, ebrand,gimg,blnFull,blnItemifno,blnitempriceyn, LinkEvtCode, blnBlogURL
dim itemid : itemid = ""
Dim evtFile_mo,  evtFileyn_mo
dim egCode, itemlimitcnt,iTotCnt
dim cdl_e, cdm_e, cds_e
dim com_egCode : com_egCode = 0
Dim emimgAlt , bimgAlt, isMyFavEvent, clsEvt, vDateView
Dim j
'//2015이벤트
Dim evt_bannerimg_mo , evt_mo_listbanner , evt_html_mo , vIsweb , vIsmobile , vIsapp , evt_subname , blnbookingsell 
Dim arrTextTitle

Dim upin '카카오 이벤트 key값 parameter
	upin = requestCheckVar(Request("upin"),200)

Dim vScope '// 별에서 온 운세 값(58021)
	vScope = requestCheckVar(Request("vScope"),200)

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
		etemplate_mo= cEvent.FTemplate_mo
		emimg		= cEvent.FEMimg
		emimg_mo	= cEvent.FEMimg_mo
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
		evtFileyn_mo	= cEvent.FevtFileyn_mo
		evtFile_mo		= cEvent.FevtFile_mo

		vDateView			= cEvent.FDateViewYN
		'//2015추가
		evt_mo_listbanner	= cEvent.FEmolistbanner
		evt_html_mo			= cEvent.Fevt_html_mo
		vIsweb				= cEvent.Fisweb
		vIsmobile			= cEvent.Fismobile
		vIsapp				= cEvent.Fisapp
		evt_subname			= cEvent.Fevt_subname
		blnbookingsell		= cEvent.Fisbookingsell
		evt_bannerimg_mo	= cEvent.Fevt_bannerimg_mo

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
		End IF

		'그룹형(etemplate_mo = "3")일때만 그룹내용 가져오기
		IF etemplate_mo = "3" THEN	
		cEvent.FEGCode = 	egCode		
		arrGroup =  cEvent.fnGetEventGroup_mo					
		END If
		
		'//2015추가 코멘트(테스터) or 상품후기 or 사은품 or 예약판매 체크가 되어 있을때만 가저오기
		If blncomment Or blnitemps Or blngift Or blnbookingsell Then
			cEvent.FEGCode	=	egCode		
			arrTextTitle	=	cEvent.fnGetEventTextTitle
		End If
				
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

	'//이벤트 명 할인이나 쿠폰시
	If blnsale Or blncoupon Then
		if ubound(Split(eName,"|"))> 0 Then
			If blnsale Or (blnsale And blncoupon) then
				eName	= cStr(Split(eName,"|")(0)) &" <span style=color:red>"&cStr(Split(eName,"|")(1))&"</span>"
			ElseIf blncoupon Then
				eName	= cStr(Split(eName,"|")(0)) &" <span style=color:green>"&cStr(Split(eName,"|")(1))&"</span>"
			End If 			
		end if
	End If 

	'head.asp에서 출력
	strOGMeta = strOGMeta & "<meta property=""og:title"" content=""" & eName & """>" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:type"" content=""website"" />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:url"" content=""http://m.10x10.co.kr/event/eventmain.asp?eventid=" & eCode & """ />" & vbCrLf
	strOGMeta = strOGMeta & "<meta property=""og:image"" content=""" & evt_mo_listbanner & """>" & vbCrLf
	if trim(evt_subname)<>"" then
		strOGMeta = strOGMeta & "<meta property=""og:description"" content=""" & "[텐바이텐] 이벤트 - " & evt_subname & """>" & vbCrLf
	end if
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>10x10: <%=eName%></title>
<link rel="stylesheet" type="text/css" href="/lib/css/newV15a.css" />
<script type="application/x-javascript" src="/lib/js/itemPrdDetail.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
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
	if(confirm("로그인 하시겠습니까?") == true) {
		top.location.href = "/login/login.asp?backpath=<%=fnBackPathURLChange(CurrURLQ())%>";
	 }
		return  ;
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
	    scrollTop: $("#groupBar"+v+"").offset().top
	}, 300)
	
	$("#groupBar"+a+" > option[value="+a+"]").attr("selected", "true");
}

//앵커이동
function goToByScroll(valtop){
	$('html,body').animate({scrollTop: valtop},'fast');
}

$(function(){
	//' ver2.0 추가
	$(".btnCmtV15 .button a, .evtShareV15 a").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
});

function jsMobAppUrlChange(e,g,m){
		var ecode = e;
		var gcode = g;
		var mcode=m;
		<% if isapp = "1" then %>
				<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/apps/appcom/wish/web2014/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% else %>
			<% if instr(Request.ServerVariables("url"),"/gnbeventmain.asp") > 0 then '// gnb %>
				jsGNBEventlink(ecode,gcode);
			<% else %>
				location.href = '/event/eventmain.asp?eventid='+ecode+'&eGc='+gcode+"&mid="+mcode;
			<% end if %>
		<% end if %>
		return false;
	}
</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content evtDetailV15" id="contentArea">
				<% SELECT CASE etemplate_mo
					CASE "3" '그룹형
				%>
						<div class="evtContV15">
						<%
						If isArray(arrGroup) Then
							IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
								Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
							END IF
							
							If arrGroup(0,0) <> "" Then	
								if arrGroup(3,0) <> "" then
						%>
								<div><img src="<%=arrGroup(3,0)%>" alt="<%=egCode%>" /></div>
						<%		End If %>
								<map name="mapGroup<%=egCode%>"><%=db2html(arrGroup(4,0))%></map>
						<%	End If %>
						</div>
						<% egCode = arrGroup(0,0) %>
						<% if blncomment then %>
						<!-- <div class="btnCmtV15">
							<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
						</div> -->
						<% end if %>
						<% If isArray(arrTextTitle) Then %>
						<!-- 코멘트 타이틀 영역 -->
						<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
						<!-- 코멘트 타이틀 영역 -->
						<% End If %>
						<div class="evtPdtListWrapV15">
						<div class="evtPdtListV15" id="topitem">
						<% sbEvtItemView_2015 %>
						</div>
						<% 
							'// 최상위 그룹 아이템이 없을경우 마크업 제거
							If itotcnt < 0 Then
						%>
						<script>$("#topitem").remove();</script>
						<% 
							End If
						End If ''isarray
						%>
						<%
						Dim vGroupOption , vTmpgcode '//아이템없는 그룹코드
						Dim intS
						Dim tempi

						If isArray(arrGroup) Then
							For intG = 1 To UBound(arrGroup,2)
								intS = 0
								'//그룹 중복일경우 중복 그룹은 제외 상품만 가저오기
								if intG < UBound(arrGroup,2) then 
									for tempi = 1 to (UBound(arrGroup,2))
										if arrGroup(9,intG) = arrGroup(9,intG+tempi) Then
											intS = intS + 1 
										Else
											Exit For
										End If 
									next
								End If

								vGroupOption = vGroupOption & "<option class=""g"&arrGroup(0,intG)&""" value="""&arrGroup(0,intG)&""">" & db2html(arrGroup(1,intG)) & "</option>"

								intG = intG+intS
							Next
							
							For intG = 1 To UBound(arrGroup,2)
								intS = 0
								egCode = arrGroup(9,intG)

								if intG < UBound(arrGroup,2) then 
									for tempi = 1 to (UBound(arrGroup,2))
										if arrGroup(9,intG) = arrGroup(9,intG+tempi) Then
											intS = intS + 1 
										Else
											Exit For
										End If 
									next
								End If
						%>
								<div class="evtPdtListV15" id="group<%=arrGroup(0,intG)%>">
									<div class="groupBarV15">
										<select id="groupBar<%=arrGroup(0,intG)%>" onChange="goGroupSelect(this.value,'<%=arrGroup(0,intG)%>');">
											<%=vGroupOption%>
										</select>
									</div>
									<%'//상품도 묶인 그룹으로 노출%>
									<% sbEvtItemView_2015 %>
								</div>
								<script>$("#groupBar<%=arrGroup(0,intG)%> > option[value=<%=arrGroup(0,intG)%>]").attr("selected", "true");</script>
								<% If itotcnt < 0 Then vTmpgcode = arrGroup(0,intG) %>
								<%
									'//상품이 없을때 select 박스 숨김 options 삭제 
									If vTmpgcode <> "" then
								%>
									<script>
										$("#group<%=vTmpgcode%>").remove();
										$(".groupBarV15").find(".g<%=vTmpgcode%>").remove();
									</script>
								<%
									End If

								intG = intG+intS
							Next
						Else
							%>
							<div class="evtPdtListV15">
							<%=sbEvtItemView_2015%>
							</div>
							<%
						End If
						Response.write "</div>"
					CASE "5" '수작업
				%>
					<% Select Case Trim(eCode) %>
						<% Case "56927" %>
							<div><iframe id="56927" src="/event/etc/iframe_56927.asp?upin=<%=upin%>" width="100%" height="1000" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
						<% Case "57476" %>
							<div><iframe id="57476" src="/event/etc/iframe_57476.asp?upin=<%=upin%>" width="100%" height="1000" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
						<% Case "58021" %>
							<div><iframe id="58021" src="/event/etc/iframe_58021.asp?vScope=<%=vScope%>" width="100%" height="500" frameborder="0" scrolling="no" onload="resizeIfr(this, 10)"></iframe></div>
						<% Case Else %>
							<% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
								<div><%=evt_html_mo%></div>
							<% Else %>
								<% If checkFilePath(server.mappath(evtFile_mo)) Then %>
									<div width="100%"><% server.execute(evtFile_mo)%></div>
								<% Else %>
									<div><%=evt_html_mo%></div>
								<% End If %>
							<% End If %>								
					<% End Select %>
					<% If isArray(arrTextTitle) Then %>
					<!-- 코멘트 타이틀 영역 -->
					<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
					<!-- 코멘트 타이틀 영역 -->
					<% End If %>
				<%	CASE "6" '수작업+상품목록 %>
						<% If Trim(evtFileyn_mo)="" Or evtFileyn_mo = "0" Or isnull(evtFileyn_mo) Or evtFileyn_mo = "False" Then %>
							<div><%=evt_html_mo%></div>
						<% Else %>
							<% If checkFilePath(server.mappath(evtFile_mo)) Then %>
								<div width="100%"><% server.execute(evtFile_mo)%></div>
							<% Else %>
								<div><%=evt_html_mo%></div>
							<% End If %>
						<% End If %>	
						<% if blncomment then %>
						<!-- <div class="btnCmtV15">
							<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
						</div> -->
						<% end if %>
						<% If isArray(arrTextTitle) Then %>
						<!-- 코멘트 타이틀 영역 -->
						<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
						<!-- 코멘트 타이틀 영역 -->
						<% End If %>
						<div class="evtPdtListWrapV15">
						<div class="evtPdtListV15">
						<% sbEvtItemView_2015 %>
						</div>
						</div>
				<%	CASE ELSE '기본:메인이미지+상품목록 %>
						<div class="evtContV15">
						<%
							IF (datediff("d",eedate,date()) >0) OR (estate =9) THEN
								Response.Write "<div class=""finishEvt""><p>죄송합니다.<br />종료된 이벤트 입니다.</p></div>"
							END IF
						%>
							<% If emimg_mo <> "" Then %><div><img src="<%=emimg_mo%>" alt="<%=eName%>" /></div><% End If %>
						</div>
						<% if blncomment then %>
						<!-- <div class="btnCmtV15">
							<span class="button btB1 btRed cWh1 w100p"><a href="#replyList"><em>코멘트 남기러 가기</em></a></span>
						</div> -->
						<% end if %>
						<% If isArray(arrTextTitle) Then %>
						<!-- 코멘트 타이틀 영역 -->
						<!-- #include virtual="/event/lib/inc_evtcmt.asp" -->
						<!-- 코멘트 타이틀 영역 -->
						<% End If %>
						<div class="evtPdtListWrapV15">
						<div class="evtPdtListV15">
						<% sbEvtItemView_2015 %>
						</div>
						</div>
				<%	End SELECT %>
				
				<% If blnitemps Then %>
				<div class="inner5 tMar25" id="replyPrdList">
					<!-- #include virtual="/event/lib/evaluate_lib.asp" -->
				</div>
				<% End If %>

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
					cEComment.FPSize 		= 5	'페이지 사이즈
					cEComment.FTotCnt 		= -1  '전체 레코드 수
					arrCList = cEComment.fnGetComment
					iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
					set cEComment = nothing
				%>
				<div class="inner5 tMar25">
					<div id="replyList" class="replyList box1 evtReplyV15">
						<p class="total">총 <%=iCTotCnt%>개의 댓글이 있습니다.</p>
						<a href="" onClick="fnOpenModal('/event/event_comment.asp?view=w&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;" class="goWriteBtn"><em>댓글쓰기</em></a>
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
						<% If isArray(arrCList) Then %>
						<div class="btnWrap tPad15">
							<span class="button btM1 btBckBdr cBk1 w100p"><a href="" onClick="fnOpenModal('/event/event_comment.asp?view=l&eventid=<%=eCode%>&linkevt=<%=LinkEvtCode%>&blnB=<%=blnBlogURL%>'); return false;"><em>전체보기</em></a></span>
						</div>
						<% End If %>
					</div>
				</div>
				<% end if %>
				<form name="frmact" method="post" action="/event/lib/doEventComment.asp" target="iframeDB" style="margin:0px;">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="returnurl" value="/event/eventmain.asp?eventid=<%= eCode %>&comm=o">
				<input type="hidden" name="userid" value="<%= GetLoginUserID %>">
				<input type="hidden" name="eventid" value="<%= eCode %>">
				<input type="hidden" name="linkevt" value="<%= LinkEvtCode %>">
				</form>
				<%
					Dim vArrIssue, vLink
					set cEvent = new ClsEvtCont
						cEvent.FECode = eCode
						cEvent.FEKind = "19,26"	'모바일전용,모바일+APP공용
						cEvent.FBrand = ebrand
						cEvent.FDevice = "M" 'device
						cEvent.FEDispCate = edispcate
						vArrIssue = cEvent.fnEventISSUEList
					set cEvent = nothing
				%>
			</div>
			<!-- //content area -->
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

				function jsevtlogin(){
					if(confirm("로그인 후에 응모하실 수 있습니다.")) {
						self.location="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
					}
				}

				//'
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
						webButton: {
							text: '10x10 바로가기',
							url: linkurl
						}
					});
				}
			//-->
			</script>
			<form name="frmC" method="post">
			<input type="hidden" name="stype" value="">
			<input type="hidden" name="idx" value="">
			</form>
			<iframe src="about:blank" name="iframecoupon" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0"></iframe>
			<iframe src="about:blank" name="iframeDB" frameborder="0" width="0" height="0"></iframe>
			<!-- #include virtual="/lib/inc/incFooter.asp" -->
		</div>
	</div>
</div>
<% If requestCheckVar(Request("comm"),1) = "o" Then %>
<script>$('html, body').animate({ scrollTop: $(".replyList").offset().top }, 0)</script>
<% End If %>
<script type="text/javascript" src="/lib/js/jquery.iframe-auto-height.js"></script>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->