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
'#### 2014-04-08 이종화 작성 play_sub ###################
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21113
Else
	eCode   =  51113
End If

dim com_egCode, bidx
	Dim cEComment
	Dim iCTotCnt, arrCList,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, FCpage, vPaging

	'파라미터값 받기 & 기본 변수 값 세팅
	vPaging = requestCheckVar(Request("paging"),1)
	FCpage =requestCheckVar(Request("FCpage"),10)
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

		if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked)){
			alert("선택 수치");
			return false;
		}

		if(!frm.txtcomm.value||frm.txtcomm.value=="여러분의 생각을 입력해보세요. (최대100자)"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }

		frm.action = "doEventSubscript51113.asp";
		return true;
	}

	function jsDelComment(cidx) {
		if(confirm("삭제하시겠습니까?")){
			document.frmdelcom.Cidx.value = cidx;
			document.frmdelcom.submit();
		}
	}

	function jsChklogin11(blnLogin)
	{
		if (blnLogin == "True"){
			if(document.frmcom.txtcomm.value =="여러분의 생각을 입력해보세요. (최대100자)"){
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
			document.frmcom.txtcomm.value="여러분의 생각을 입력해보세요. (최대100자)";
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

</script>
<title>생활감성채널, 텐바이텐 > 이벤트 > 야근수당! 야근 야금 까먹자~</title>
<style type="text/css">
	.mEvt51113 img {vertical-align:top; width:100%;background-size:3px 3px;}
	.mEvt51113 p {max-width:100%;}
	.mEvt51113 .evtNotice {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49974/bg_notice.png) left top repeat; background-size:10px 10px;}
	.mEvt51113 .approval {padding-bottom:20px; background:#f9efcb;}
	.mEvt51113 .approval dl {position:relative; overflow:hidden;}
	.mEvt51113 .approval dd {position:absolute; left:9%; top:28%; width:82%;}
	.mEvt51113 .approval li {float:left; width:20%; text-align:center;}
	.mEvt51113 .approval li label {display:block; margin-bottom:8px;}
	.mEvt51113 .approval .fBtn {width:50%; margin-left:25%;}
	.mEvt51113 .approval .fBtn input {width:100%;}
	.mEvt51113 .approvalList {}
	.mEvt51113 .approvalList ul {padding:20px 0 25px; background:#f0f0f0;}
	.mEvt51113 .approvalList li {position:relative; margin-bottom:20px; }
	.mEvt51113 .approvalList li:last-child {margin-bottom:0;}
	.mEvt51113 .approvalList li div {position:absolute; width:45%; left:45%; top:0; padding-top:8%;}
	.mEvt51113 .approvalList li .energy {position:absolute; left:0; top:0; display:inline-block; width:50%; height:100%; background-position:left top; background-repeat:no-repeat; background-size:100% auto;}
	.mEvt51113 .approvalList li.e01 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/ico_energy04.png);}
	.mEvt51113 .approvalList li.e02 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/ico_energy03.png);}
	.mEvt51113 .approvalList li.e03 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/ico_energy02.png);}
	.mEvt51113 .approvalList li.e04 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/ico_energy01.png);}
	.mEvt51113 .approvalList li.e05 .energy {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/ico_energy00.png);}
	.mEvt51113 .approvalList li .delete {position:absolute; right:4.5%; top:0; width:3%; cursor:pointer; padding:5px;}
	.mEvt51113 .approvalList li .docNum {display:block; color:#777; font-size:10px; padding-bottom:8%;}
	.mEvt51113 .approvalList li .getOff {display:inline-block; border-bottom:2px solid #181818; font-size:19px; line-height:20px; color:#222;}
	.mEvt51113 .approvalList li .txt {color:#333; font-size:11px; line-height:15px; padding-top:6%;}
	.mEvt51113 .memo03Head {position:relative;}
	.mEvt51113 .memo03Head .goMemo {position:absolute; left:22%; bottom:10%; width:56%; }
	.mEvt51113 .tentenBaemin .slash {background:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/bg_slash.png) left top repeat; background-size:10px 10px;}
	.mEvt51113 .kitWrap {padding:0 10px 25px; width:300px; margin:0 auto;}
	.mEvt51113 .kit {width:300px; padding-top:10px; position:relative; overflow:hidden;}
	.mEvt51113 .kit .swiper-container {width:300px; height:246px; overflow:hidden; margin:0 auto; position:relative;}
	.mEvt51113 .kit .swiper-wrapper {position:relative; overflow:hidden;}
	.mEvt51113 .kit .swiper-slide {width:300px; height:216px; float:left; overflow:hidden;}
	.mEvt51113 .kit .pagination {text-align:center; padding-top:10px; position:absolute; bottom:0; left:0; text-align:center; width:100%;}
	.mEvt51113 .kit .pagination span {width:14px; height:14px; display:inline-block; text-align:center; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/blt_pagination_off.png); background-size:14px 14px; margin:0 5px;}
	.mEvt51113 .kit .pagination span.swiper-active-switch {background-image:url(http://webimage.10x10.co.kr/eventIMG/2014/51113/blt_pagination_on.png)}
	.mEvt51113 .baeminIntro {position:relative;}
	.mEvt51113 .baeminIntro ul {overflow:hidden; position:absolute; left:14%; top:65%; width:80%;}
	.mEvt51113 .baeminIntro ul li {float:left; width:26%; padding:0 2%;}

@media all and (min-width:480px){
	.mEvt51113 .kitWrap {padding:0 15px 25px; width:450px;}
	.mEvt51113 .kit {width:450px;}
	.mEvt51113 .kit .swiper-container {width:450px; height:354px;}
	.mEvt51113 .kit .swiper-slide {width:450px; height:324px;}
}
</style>
</head>
<body>
	<div class="mEvt51113">
		<!-- 이벤트 참여하기 -->
		<div class="applyEvtWrap" id="writeMemo">
			<div class="applyEvt">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/txt_approval.png" alt="" /></p>
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="paging" value="">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				<div class="approval">
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/tit_energy.png" alt="현재 당 수치" /></dt>
						<dd colspan="3">
							<ul class="selectEnergy">
								<li class="energy01">
									<label for="energy01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/img_energy04.png" alt="" /></label>
									<input type="radio" id="energy01" name="spoint" value="1" />
								</li>
								<li class="energy02">
									<label for="energy02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/img_energy03.png" alt="" /></label>
									<input type="radio" id="energy02" name="spoint" value="2" />
								</li>
								<li class="energy03">
									<label for="energy03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/img_energy02.png" alt="" /></label>
									<input type="radio" id="energy03" name="spoint" value="3" />
								</li>
								<li class="energy04">
									<label for="energy04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/img_energy01.png" alt="" /></label>
									<input type="radio" id="energy04" name="spoint" value="4" />
								</li>
								<li class="energy05">
									<label for="energy05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/img_energy00.png" alt="" /></label>
									<input type="radio" id="energy05" name="spoint" value="5" />
								</li>
							</ul>
						</dd>
					</dl>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/tit_time.png" alt="예상 퇴근시간" /></dt>
						<dd colspan="3">
							<ul class="selectTime">
								<li>
									<textarea cols="50" rows="3" name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="여러분의 생각을 입력해보세요. (최대100자)" autocomplete="off">여러분의 생각을 입력해보세요. (최대100자)</textarea>
								</li>
							</ul>
						</dd>
					</dl>
					<p class="fBtn"><span><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/51113/btn_finish.png" alt="작성완료" /></span></p>
				</div>
				</form>
				<form name="frmdelcom" method="post" action="doEventSubscript51113.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
				<% IF isArray(arrCList) THEN %>
				<div class="approvalList">
					<ul>
						<% For intCLoop = 0 To UBound(arrCList,2)%>
						<li class="t0<%=nl2br(arrCList(1,intCLoop))%> e0<%=arrCList(3,intCLoop)%>">
							<span class="energy"></span>
							<div>
								<span class="docNum">문서코드 <em>no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></em></span>
								<p class="getOff">나오늘 <strong></strong></p>
								<p class="txt"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님의<br />결재 요청서가 접수되었습니다.</p>
							</div>
							<p class="docBg"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/bg_doc.png" alt="" /></p>
							<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
							<span class="delete" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>')"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51113/btn_delete.png" alt="삭제" /></span>
							<% End If %>
						</li>
						<% Next %>
					</ul>
					<div class="paging tMar10">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
					</div>
				</div>
				<% End If %>
			</div>
		</div>
		<!--// 이벤트 참여하기 -->
	</div>
	<script>
	<% If vPaging = "o" Then %>
	var offset = $("#rank").offset();
	window.parent.$("html, body").animate({scrollTop: offset.top},500);
	<% End If %>
	</script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->