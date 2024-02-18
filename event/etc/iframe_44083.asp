<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<!-- #include virtual="/lib/classes/award/newawardcls.asp" -->
<%
Dim eCode , itemid
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20933
	itemid   =  374431 'test 한정
Else
	eCode   =  44083
	itemid   =  902273
End If

dim oItem, ItemContent
set oItem = new CatePrdCls
oItem.GetItemData itemid '상품상세

dim com_egCode, bidx
	Dim cEComment
	Dim cEComment1
	Dim iCTotCnt, arrCList,arrClist1,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, FCpage

	'파라미터값 받기 & 기본 변수 값 세팅
	FCpage =requestCheckVar(Request("FCpage"),10)
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 4  	'한 페이지의 보여지는 열의 수
	iCPerCnt = 5		'보여지는 페이지 간격

	'선택범위 리플개수 접수
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iSelTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

	'코멘트 데이터 가져오기
	set cEComment = new ClsEvtComment

	cEComment.FECode 		= eCode
	'cEComment.FComGroupCode	= com_egCode
	cEComment.FEBidx    	= bidx
	cEComment.FCPage 		= iCCurrpage	'현재페이지
	cEComment.FPSize 		= iCPageSize	'페이지 사이즈
	cEComment.FTotCnt 		= iCTotCnt  '전체 레코드 수

	arrCList = cEComment.fnGetComment		'리스트 가져오기
	iCTotCnt = cEComment.FTotCnt '리스트 총 갯수
	set cEComment = nothing

function selchg()
		dim	aa
		aa	= arrCList(3,intCLoop)
	select case aa
		case 1
			response.write "A"
		case 2
			response.write "B"
		case 3
			response.write "C"
		case 4
			response.write "D"
	End select
End function
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 오늘 봉잡았네</title>
	<style type="text/css">
	.mEvt44083 {background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_bg01.png') left top no-repeat; background-size:100% auto;}
	.mEvt44083 img,
	.mEvt44083 input {vertical-align:top;}
	.mEvt44083 .emoticon {overflow:hidden;}
	.mEvt44083 .emoticon li {position:relative; float:left; width:50%;}
	.mEvt44083 .emoticon li .sEmo {position:absolute; left:50%; top:68%; margin-left:-10px;}
	.mEvt44083 .boastWrite .wCont {padding:10px 15px 5px; background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_bg02.png') left top no-repeat; background-size:100% auto;}
	.mEvt44083 .boastWrite .wCont textarea {width:98%; height:80px; border:0; font-size:12px;}
	.mEvt44083 .boastList li {overflow:hidden; padding:10px; margin-bottom:15px;}
	.mEvt44083 .boastList li .bg {float:left; width:30%; height:190px;}
	.mEvt44083 .boastList li.typeA {background:#ffffb7;}
	.mEvt44083 .boastList li.typeA .bg {background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_select01.png') center center no-repeat; background-size:90% auto;}
	.mEvt44083 .boastList li.typeB {background:#d8f8fe;}
	.mEvt44083 .boastList li.typeB .bg {background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_select02.png') center center no-repeat; background-size:90% auto;}
	.mEvt44083 .boastList li.typeC {background:#ffdbd6;}
	.mEvt44083 .boastList li.typeC .bg {background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_select03.png') center center no-repeat; background-size:90% auto;}
	.mEvt44083 .boastList li.typeD {background:#daf8e0;}
	.mEvt44083 .boastList li.typeD .bg {background:url('http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_select04.png') center center no-repeat; background-size:90% auto;}
	.mEvt44083 .boastList li .cont {float:right; width:68%; height:190px; position:relative;  background:#fff; color:#888;}
	.mEvt44083 .boastList li .cont .num {border-bottom:1px solid #a4a4a4; padding-bottom:4px; margin:10px 8px 0; font-size:11px; font-weight:bold; text-align:right;}
	.mEvt44083 .boastList li .cont .txt {border-top:1px solid #e8e8e8; font-size:12px; line-height:16px; margin:0 8px; padding-top:10px;}
	.mEvt44083 .boastList li .cont .bt {position:absolute; left:8px; bottom:27px}
	.mEvt44083 .boastList li .cont .info {position:absolute; left:0; bottom:10px; font-size:11px; margin:0 8px;}
	.mEvt44083 .boastList li .cont .info span {padding:0 4px;}
	.mEvt44083 .boastList li .cont .info img {vertical-align:middle; margin-top:-3px;}
</style>
<script type="text/javascript">
<!--
	//top.window.scrollTo(0,0);
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_44083.asp?iCC="+iP;
	}
	function goPage(page)
	{
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
		//location.href="#rank";
	}
	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("이미지를 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="내 애인을 자랑해주세요! (최대 100자 이내)"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>200){
			alert('최대 한글 100자 까지 입력 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "/event/etc/doEventSubscript44083.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsupdateComment(cidx)	{
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return;
		<% end if %>

			document.frmupdatecom.Cidx.value = cidx;
	   		document.frmupdatecom.submit();
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value =="내 애인을 자랑해주세요! (최대 100자 이내)"){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur()
	{

		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value="내 애인을 자랑해주세요! (최대 100자 이내)";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 100자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
</head>
<body>
<!-- content area -->
<div class="content" id="contentArea">
	<div class="mEvt44083">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_head.png" alt="오늘 봉잡았네" style="width:100%;" /></p>

		<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) Then %>
		<div>
			<p><a href="/category/category_itemPrd.asp?itemid=<%=itemid%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_btn01.png" alt="1+1 시계 구매하기" style="width:100%;" /></a></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img01.png" alt="" style="width:100%;" /></p>
			<p><a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_btn02.png" alt="지금 회원 가입 하러 가기" style="width:100%;" /></a></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img02.png" alt="당신의 애인을 마음껏 자랑하세요!" style="width:100%;" /></p>
		</div>
		<% Else %>
		<div>
			<p><a href="/member/join.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_btn04.png" alt="지금 회원 가입 하러 가기" style="width:100%;" /></a></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img06.png" alt="당신의 애인을 마음껏 자랑하세요!" style="width:100%;" /></p>
		</div>
		<% End If %>

		<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<ul class="emoticon">
			<li>
				<label for="emo01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_emo01.png" alt="외모종결 자체발광" style="width:100%;" /></label>
				<p class="sEmo"><input type="radio" id="emo01"  name="spoint" value="1" /></p>
			</li>
			<li>
				<label for="emo02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_emo02.png" alt="외모종결 자체발광" style="width:100%;" /></label>
				<p class="sEmo"><input type="radio" id="emo02"  name="spoint" value="2" /></p>
			</li>
			<li>
				<label for="emo03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_emo03.png" alt="외모종결 자체발광" style="width:100%;" /></label>
				<p class="sEmo"><input type="radio" id="emo03"  name="spoint" value="3" /></p>
			</li>
			<li>
				<label for="emo04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_emo04.png" alt="외모종결 자체발광" style="width:100%;" /></label>
				<p class="sEmo"><input type="radio" id="emo04"  name="spoint" value="4" /></p>
			</li>
		</ul>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img03.png" alt="" style="width:100%;" /></p>
		<div class="boastWrite">
			<div class="wCont">
				<textarea name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> value="내 애인을 자랑해주세요! (최대 100자 이내)" autocomplete="off">내 애인을 자랑해주세요! (최대 100자 이내)</textarea>
			</div>
			<p><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_btn03.png" alt="자랑하기" style="width:100%;" /></p>
		</div>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img04.png" alt="" style="width:100%;" /></p>
		</form>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript44083.asp" style="margin:0px;">
			<input type="hidden" name="eventid" value="<%=eCode%>">
			<input type="hidden" name="bidx" value="<%=bidx%>">
			<input type="hidden" name="Cidx" value="">
			<input type="hidden" name="mode" value="del">
			<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<% IF isArray(arrCList) THEN %>
		<ul class="boastList">
			<% For intCLoop = 0 To UBound(arrCList,2)%>
			<li class="type<% selchg() %>">
				<p class="bg"></p>
				<div class="cont">
					<p class="num">no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
					<p class="txt"><%=db2html(arrCList(1,intCLoop))%></p>
					<p class="bt">
						<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<span class="btn btn4 gryB w50B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>');">삭제</a></span>
						<% end if %>
					</p>
					<p class="info">
						<% If arrCList(8,intCLoop)="M" Then %>
						<img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" width="9px" alt="모바일 작성" />
						<% End If %>
						<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
						<span>|</span>
						<%=Left(arrCList(4,intCLoop),10)%>
					</p>
				</div>
			</li>
			<% next %>
		</ul>
		<% End If %>
		<div style="margin-bottom:15px;margin-top:15px;">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
		</div>
		<!-- 솔드아웃일 경우 이미지 추가 -->
		<% IF (oItem.Prd.isLimitItem) and (not (oItem.Prd.isSoldout or oItem.Prd.isTempSoldOut)) Then %>
		<% Else %>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img07.png" alt="SOLD OUT" style="width:100%;" /></p>
		<% End If %>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44083/44083_img05.png" alt="이벤트 안내" style="width:100%;" /></p>
	</div>
</div>
<%
	Set oItem = Nothing
%>
<!-- //content area -->
<!-- #include virtual="/lib/db/dbclose.asp" -->
</body>
</html>