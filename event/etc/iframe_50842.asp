<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<%
'#### 2014-03-14 이종화 작성 play_sub ###################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21139
Else
	eCode   =  51113
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt

	'파라미터값 받기 & 기본 변수 값 세팅
	iCCurrpage = requestCheckVar(Request("iCC"),10)	'현재 페이지 번호
	com_egCode = requestCheckVar(Request("eGC"),1)	

	IF iCCurrpage = "" THEN iCCurrpage = 1
	IF iCTotCnt = "" THEN iCTotCnt = -1

	'// 그룹번호 랜덤으로 지정

	iCPageSize = 3		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격

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

	iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
	IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<script src="/lib/js/swiper-1.8.min.js"></script>
<script type="text/javascript">
	function goPage(page){
		scrollToAnchor('rank');
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

	function scrollToAnchor(where){
		scrollY=document.getElementById(where).offsetTop;
		scrollTo(0,scrollY);
	}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>
		
	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("텐트를 선택 해주세요");
	    return false;
	   }

	    if(!frm.txtcomm.value){
	    alert("100자 이내로 입력해주세요.");
		document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }

	   	if(GetByteLength(frm.txtcomm.value)>100){
			alert('100자 까지 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}

	   frm.action = "doEventSubscript50842.asp";
	   return true;
	}

	function jsDelComment(cidx)	{
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
	   		document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value == "100자 이내로 입력해주세요." ){
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
			document.frmcom.txtcomm.value = "100자 이내로 입력해주세요."
		}
	}

	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 100자 이내로 제한됩니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}
</script>
<title>생활감성채널, 텐바이텐 > 이벤트 > CAMPING FESTIVAL</title>
<style type="text/css">
	.mEvt50842 {}
	.mEvt50842 p {max-width:100%;}
	.mEvt50842 img {vertical-align:top; width:100%;}
	.mEvt50842 .applyCamping {background:url(http://webimage.10x10.co.kr/eventIMG/2014/50842/around_bg01.png) left top no-repeat; background-size:100% auto;}
	.mEvt50842 .applyCamping ul {overflow:hidden; padding:0 9px 18px; }
	.mEvt50842 .applyCamping li {float:left; width:21%; padding:0 2%; text-align:center;}
	.mEvt50842 .applyCamping li label {display:block; margin-bottom:6px;}
	.writeCmt textarea {display:block; width:90%; height:80px; padding:8px; margin:0 auto; color:#888; font-size:11px; border:3px solid #ffc000; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box; }
	.btnApply {padding:4.5% 15% 0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/50842/around_bg02.png) left top no-repeat; background-size:100% 100%;}
	.btnApply input {width:100%;}
	.tentList li {position:relative; overflow:hidden; margin-bottom:7px;}
	.tentList li.tent01 {border:8px solid #ffe1c9; background:#fff6ed;}
	.tentList li.tent02 {border:8px solid #c6faf7; background:#eafaf9 ;}
	.tentList li.tent03 {border:8px solid #d5f0bb; background:#f0fae6;}
	.tentList li.tent04 {border:8px solid #f7daed; background:#f8f2f6;}
	.tentList li .tentImg {float:left; width:33%;}
	.tentList li .cmtCont {float:left; width:67%; color:#888;}
	.tentList li .num {position:absolute; right:17px; top:12px; text-align:right; font-weight:bold; font-size:10px; }
	.tentList li .txt {height:70%; line-height:14px; font-size:11px; margin-top:38px; padding-right:17px;}
	.tentList li .writer {position:absolute; right:17px; bottom:15px;  text-align:right; font-size:10px;}
	.tentList li .btn {position:absolute; left:9%; bottom:7%;}
</style>
<script type="text/javascript">
$(function(){
	$('.tentList .tent01 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent01.png" alt="" />');
	$('.tentList .tent02 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent02.png" alt="" />');
	$('.tentList .tent03 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent03.png" alt="" />');
	$('.tentList .tent04 .tentImg').append('<img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/cmt_tent04.png" alt="" />');
});
</script>
</head>
<body>
<div class="mEvt50842">
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/around_head.png" alt="CAMPING FESTIVAL" /></div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/around_img01.png" alt="감성캠핑, 가볍게 떠나자!" /></div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/around_img03.png" alt="캠핑혜택" /></div>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/around_img02.png" alt="당신이 꿈꾸는 텐트를 선택하고, 함께 가고 싶은 사람과 그 이유를 적어 응모해주세요." /></div>
	<!-- 캠핑 응모 -->
	<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
	<input type="hidden" name="iCTot" value="">
	<input type="hidden" name="mode" value="add">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	<div class="applyCamping">
		<ul>
			<li>
				<label for="tent01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/select_tent01.png" alt="" /></label>
				<input type="radio" id="tent01" name="spoint" value="1"/>
			</li>
			<li>
				<label for="tent02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/select_tent02.png" alt="" /></label>
				<input type="radio" id="tent02" name="spoint" value="2" />
			</li>
			<li>
				<label for="tent03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/select_tent03.png" alt="" /></label>
				<input type="radio" id="tent03" name="spoint" value="3" />
			</li>
			<li>
				<label for="tent04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/select_tent04.png" alt="" /></label>
				<input type="radio" id="tent04" name="spoint" value="4 " />
			</li>
		</ul>
		<div class="writeCmt">
			<textarea title="캠핑 가고 싶은 사람과 이유 입력" cols="50" rows="10" id="writearea" name="txtcomm" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%> autocomplete="off" maxlength="100">100자 이내로 입력해주세요.</textarea>
			<p class="btnApply"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/50842/btn_apply.png" alt="감성캠핑 응모하기" /></p>
		</div>
	</div>
	</form>
	<form name="frmdelcom" method="post" action="doEventSubscript50842.asp" style="margin:0px;">
	<input type="hidden" name="eventid" value="<%=eCode%>">
	<input type="hidden" name="bidx" value="<%=bidx%>">
	<input type="hidden" name="Cidx" value="">
	<input type="hidden" name="mode" value="del">
	<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
	</form>
	<div><img src="http://webimage.10x10.co.kr/eventIMG/2014/50842/around_cmt_notice.png" alt="ID당 1개의 코멘트를 남길 수 있습니다./통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." /></div>
	<!--// 캠핑 응모 -->

	<!-- 코멘트 리스트 -->
	<% IF isArray(arrCList) THEN %>
	<div class="tentList">
		<ul>
			<% For intCLoop = 0 To UBound(arrCList,2)%>
			<li class="tent0<%=arrCList(3,intCLoop)%>">
				<p class="tentImg"></p>
				<div class="cmtCont">
					<p class="num"><% If arrCList(8,intCLoop) = "M"  then%><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" style="width:9px;" /><% End If %> no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
					<p class="txt"><%=nl2br(arrCList(1,intCLoop))%></p>
					<p class="writer"><strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong> | <%=formatdate(arrCList(4,intCLoop),"0000.00.00")%></p>
				</div>
				<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
				<span class="btn btn5 gryB w40B"><a href="#" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span>
				<% end if %>
			</li>
			<% Next %>
		</ul>
		<div class="paging tMar20">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
		</div>
	</div>
	<% End If %>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->