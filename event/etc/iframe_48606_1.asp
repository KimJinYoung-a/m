<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
dim cEComment ,eCode ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt

	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	eCode		= requestCheckVar(Request("eventid"),10) '이벤트 코드번호
	cdl			= requestCheckVar(Request("cdl"),3)
	blnFull		= requestCheckVar(Request("blnF"),10)
	blnBlogURL	= requestCheckVar(Request("blnB"),10)
	isMyComm	= requestCheckVar(request("isMC"),1)
	iCPerCnt = 10		'보여지는 페이지 간격
	iCPageSize = 15		'한 페이지의 보여지는 열의 수

	IF blnFull = "" THEN blnFull = True
	IF blnBlogURL = "" THEN blnBlogURL = False
	IF iCCurrpage = "" THEN	iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21053"
	Else
		eCode = "48606"
	End If

	'데이터 가져오기
	set cEComment = new ClsEvtComment
	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	if isMyComm="Y" then cEComment.FUserID = GetLoginUserID
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
		
	'---------------------------------------------------------------------------------
	Dim vQuery, i, vUserID, vIsAllChk1, vMyCnt1, vIsAllChk2, vMyCnt2, vMyOrderCnt, vRemainCnt, vArr, vArr2, vOrderSR(4), vImage
	vUserID = GetLoginUserID
	vIsAllChk1 = "x"
	vIsAllChk2 = "x"
	vMyCnt1 = 0
	vMyCnt2 = 0
	vMyOrderCnt = 0
	vRemainCnt = 0
	
	If vUserID <> "" Then
		'######### 당근 gubun = 1
		vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_comment] WHERE userid = '" & vUserID & "' AND evtcom_point = '1' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
		rsget.Open vQuery,dbget,1
		IF rsget(0) > 0 Then
			vIsAllChk1 = "o"
			vMyCnt1 = "3"
		End IF
		rsget.close
		
		If vIsAllChk1 = "x" Then
			vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_comment] WHERE userid = '" & vUserID & "' AND evtcom_point = '0' AND evt_code = '" & eCode & "' AND evtcom_using = 'Y'"
			rsget.Open vQuery,dbget,1
			vMyCnt1 = rsget(0)
			rsget.close
		End IF
		
	End IF
	
	Function fnIsChecked(arr,a)
		Dim gg, i
		gg = "x"
		If IsArray(arr) Then
			For i=0 To UBound(arr,2)
				If CStr(arr(0,i)) = CStr(a) Then
					gg = "o"
					Exit For
				End IF
			Next
		End IF
		fnIsChecked = gg
	End Function
%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 말이야 당근이야</title>
<style type="text/css">
.mEvt48651 img {vertical-align:top;}
.mEvt48651 legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.carrotEvt .carrotMsg {position:relative;}
.carrotEvt .carrotMsg .textInput {position:absolute; left:0; top:7%; width:76%; padding:0 12%;}
.carrotEvt .carrotMsg .textInput textarea {width:100%; height:auto; border:0; background-color:transparent; color:#555; font-size:11px; line-height:1.375em;}
.carrotEvt .layerCarrot {position:relative;}
.carrotEvt .layerCarrot .carrotQ {position:absolute; left:0; top:25%; width:100%; color:#666; text-align:center;}
.carrotEvt .layerCarrot .carrotQ span {display:block; padding-bottom:12px; font-size:11px;}
.carrotEvt .layerCarrot .carrotQ strong {display:block; padding:0 9%; font-size:11px; line-height:1.25em;}
.carrotEvt .layerCarrot .btnClose {position:absolute; left:50%; bottom:10%; width:140px; height:46px; margin-left:-70px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48651/btn_close.gif) left top no-repeat; background-size:100% 100%; text-indent:-999em; cursor:pointer;}
@media all and (max-width:480px){
	.carrotEvt .layerCarrot .btnClose {width:93px; height:30px; margin-left:-46px;}
}
.countCarrot {position:relative;}
.countCarrot .myCarrot {position:absolute; left:0; top:52%; width:100%; text-align:center;}
.countCarrot .myCarrot p {padding-bottom:5px;}
.countCarrot .myCarrot img {vertical-align:middle;}
.countCarrot .myCarrot strong {color:#ff7022; font-size:12px;}
.countCarrot .myCarrot strong span {border-bottom:2px solid #ff7022;}
.countCarrot .onlyOne {position:absolute; left:0; bottom:15%; width:100%; text-align:center;}
.rankup .rankupKList {padding:0 7.083333% 26px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_bottom.gif) left top no-repeat; background-size:100% 100%;}
.rankup .rankupKList ul {min-height:200px; border:1px solid #dfd2c0; border-top:0; background:#fff url(http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_line.gif) left top repeat-x;}
.rankup .rankupKList ul li {padding:0 4.89583% 7px; color:#555; font-size:11px; line-height:1.25em;}
.rankup .rankupKList ul li:first-child {padding-top:14px;}
.rankup .rankupKList ul li:last-child {padding-bottom:14px;}
</style>
<script type="text/javascript">
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

function jsSubmitComment(){
	var frm = document.frmcom;
	if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	}
	<% If vUserID = "" Then %>
	jsChklogin('<%=IsUserLoginOK%>');
	return;
	<% End If %>
<% If vIsAllChk1 = "o" Then %>
	alert("이미 이벤트 응모가 완료되었습니다.");
	return;
<% Else %>
	<% If vUserID <> "" Then %>
		if(frm.txtcomm.value == "텍스트를 30자 이내로 입력해주세요. 예) 텐바이텐은 즐겁고 신나는 곳인가요?"){
			frm.txtcomm.value = ""
		    alert("코멘트를 입력해주세요");
		    frm.txtcomm.focus();
		    return;
		}
		
	   if(!frm.txtcomm.value){
	    alert("코멘트를 입력해주세요");
	    frm.txtcomm.focus();
	    return;
	   }
	
	   frm.action = "doEventSubscript48606.asp";
	   frm.submit();
	<% End If %>
<% End If %>
}

function jsDelComment(cidx)	{
	if(confirm("삭제하시겠습니까?")){
		document.frmdelcom.Cidx.value = cidx;
   		document.frmdelcom.submit();
	}
}

function jsCheckLimit() {
	var frm = document.frmcom;
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
	}else{
		if(frm.txtcomm.value == "텍스트를 30자 이내로 입력해주세요. 예) 텐바이텐은 즐겁고 신나는 곳인가요?"){
			frm.txtcomm.value = ""
		}
	}
}

//내코멘트 보기
function fnMyComment() {
	document.frmcom.isMC.value="<%=chkIIF(isMyComm="Y","N","Y")%>";
	document.frmcom.iCC.value=1;
	document.frmcom.submit();
}

function layershowhide(g){
	if(g == "s"){
		$(".layerCarrot").show();
	}else{
		$(".layerCarrot").hide();
		location.reload();
	}
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt48651">
		<div class="carrotEvt">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_new_year.gif" alt="2014년 새해맞이" style="width:100%;" /></p>
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/tit_horse_carrot.gif" alt="2014년에 만나는 新당연하지! 말이야 당근이야" style="width:100%;" /></h2>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_carrot_01.gif" alt="무엇이든 한 가지씩 물어볼 때 마다 당근 한 개씩! 당근 세 개를 모으신 분 중 10분을 추첨해 당근케이크를 만들어 드립니다. ( 질문은 YES or NO로 답변할 수 있는 것만 해주세요! ) 기간 : 2014. 01. 20 ~ 01. 26 | 발표 : 01.28(화)" style="width:100%;" /></p>

			<form name="frmcom" method="post" target="prociframe" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="com_egC" value="<%=com_egCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<input type="hidden" name="iCTot" value="">
			<input type="hidden" name="mode" value="add">
			<input type="hidden" name="spoint" value="0">
			<input type="hidden" name="gubun" value="1">
			<input type="hidden" name="isMC" value="<%=isMyComm%>">
			<fieldset>
			<legend>말이야 당근이야 질문 입력하기</legend>
				<div class="carrotMsg">
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_input.gif" alt="" style="width:100%;" />
					<div class="textInput">
						<textarea title="질문 입력" cols="50" rows="3" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%>>텍스트를 30자 이내로 입력해주세요. 예) 텐바이텐은 즐겁고 신나는 곳인가요?</textarea>
					</div>
					<img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/btn_inquiry.gif" alt="물어보기" style="cursor:pointer;width:100%;" onClick="jsSubmitComment();" />
				</div>
			</fieldset>
			</form>

			<!-- Layer Popup -->
			<div class="layerCarrot" style="display:none;">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_layer_top.gif" alt="" style="width:100%;" />
				<p class="carrotQ">
					<span>(질문)</span>
					<strong><span id="questionn"></span></strong>
				</p>
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_sure.gif" alt="당근이지" style="width:100%;" /></p>
				<button type="button" class="btnClose" onClick="layershowhide('h');">닫기</button>
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_layer_bottom.gif" alt="" style="width:100%;" />
			</div>
			<!-- //Layer Popup -->

			<div class="countCarrot">
				<img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/bg_carrot_0<%=vMyCnt1%>.gif" alt="당근" style="width:100%;" />
				<div class="myCarrot">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_carrot_count.png" alt="내가 받은 당근은 총 몇 개일까?" style="width:20.10416%;" /></p>
					<strong><span><%=vMyCnt1%></span> <img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_number.png" alt="개" style="width:2.70833%;" /></strong>
				</div>
				<p class="onlyOne"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/txt_carrot_02.gif" alt="당근은 하루에 한 개만 받을 수 있어요." style="width:20.10416%;" /></p>
			</div>

			<div class="rankup">
				<h4><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/tit_mal_mal_mal.gif" alt="실시간 말말말" style="width:100%;" /></h4>
				<div class="rankupKList">
					<ul>
					<%
						IF isArray(arrCList) THEN
							dim arrUserid, bdgUid, bdgBno
							'사용자 아이디 모음 생성(for Badge)
							for intCLoop = 0 to UBound(arrCList,2)
								arrUserid = arrUserid & chkIIF(arrUserid<>"",",","") & "''" & trim(arrCList(2,intCLoop)) & "''"
							next
		
							'뱃지 목록 접수(순서 랜덤)
							'Call getUserBadgeList(arrUserid,bdgUid,bdgBno,"Y")
		
							For intCLoop = 0 To UBound(arrCList,2)
					%>
							<li><%=TwoNumber(intCLoop+1)%>. <%=ReplaceBracket(db2html(arrCList(1,intCLoop)))%> (<%=printUserId(arrCList(2,intCLoop),2,"*")%>)</li>
					<%
							Next
						Else
					%>
						<li>등록된 질문이 없습니다.</li>
					<% end if %>
					</ul>
				</div>
			</div>

			<div class="btnGoEvent">
				<a href="/event/eventmain.asp?eventid=<%=CHKIIF(application("Svr_Info")="Dev","21054","48607")%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/48651/btn_go_other_event.gif" alt="텐바이텐의 선물 선물이 막걸립니다! 이벤트 보러가기" style="width:100%;" /></a>
			</div>
		</div>
	</div>
	<iframe name="prociframe" id="prociframe" frameborder="0" width="0px" height="0px"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->