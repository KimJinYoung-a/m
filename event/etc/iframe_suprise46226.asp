<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/event46226Cls.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20990
Else
	eCode   =  46224
End If

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

	iCPageSize = 6		'한 페이지의 보여지는 열의 수
	iCPerCnt = 10		'보여지는 페이지 간격

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
	<title>생활감성채널, 텐바이텐 > 이벤트 > 어느 날 당신에게 생긴 서프라이즈~!</title>
	<style type="text/css">
	.mEvt46226 {}
	.mEvt46226 img {vertical-align:top; display:inline;}
	.mEvt46226 .research {padding:0 10px; text-align:center; background:#fffae8;}
	.mEvt46226 .research ul {overflow:hidden; _zoom:1;}
	.mEvt46226 .research ul li {float:left; width:25%;}
	.mEvt46226 .research ul li p {display:block; padding:0 6px; margin-bottom:10px;}
	.mEvt46226 .research .myCollab {border:5px solid #ff767c; padding:10px; background:#fff; margin:10px 0;}
	.mEvt46226 .research .myCollab textarea {overflow:hidden; width:100%; height:50px; color:#888; border:0;}
	.mEvt46226 .research .enroll {border-radius:0;}
	.mEvt46226 .total {text-align:right; color:#888; font-size:11px; padding:0 8px 5px 0; border-bottom:1px solid #ededed;}
	.mEvt46226 .story {overflow:hidden; border-top:1px solid #ddd;}
	.mEvt46226 .story ul {padding:0 8px 25px;}
	.mEvt46226 .story li {padding-top:20px;}
	.mEvt46226 .story li .txt {overflow:hidden; padding:15px 15px 15px 22%; font-size:11px; line-height:1.2; color:#777;}
	.mEvt46226 .story li .txt strong {color:#000; padding-right:3px;}
	.mEvt46226 .story li .txt img {vertical-align:middle; padding-right:5px;}
	.mEvt46226 .story li .txt .cmt {margin-top:5px; line-height:1.4;}
	.mEvt46226 .story li .txt .writer {color:#2c2c2c;}
	.mEvt46226 .story li .txt .writer .btn {margin:-3px 0 0 5px;}
	.mEvt46226 .story li .typeA,
	.mEvt46226 .story li .typeB,
	.mEvt46226 .story li .typeC,
	.mEvt46226 .story li .typeD {width:100%; height:117px; background-position:left top; background-repeat:repeat; background-size:100% 100%;}
	.mEvt46226 .story li .typeA {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_bg_cmt01.png'); *background:#9ce6d7; *background-image:none;}
	.mEvt46226 .story li .typeB {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_bg_cmt02.png'); *background:#ff9f9f; *background-image:none;}
	.mEvt46226 .story li .typeC {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_bg_cmt03.png'); *background:#8cbefa; *background-image:none;}
	.mEvt46226 .story li .typeD {background-image:url('http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_bg_cmt04.png'); *background:#b395d4; *background-image:none;}
	@media \0screen {
	.mEvt46226 .story li .typeA {background:#9ce6d7; background-image:none;}
	.mEvt46226 .story li .typeB {background:#ff9f9f; background-image:none;}
	.mEvt46226 .story li .typeC {background:#8cbefa; background-image:none;}
	.mEvt46226 .story li .typeD {background:#b395d4; background-image:none;}
	}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_suprise46226.asp?iCC="+iP;
	}
	function goPage(page)
	{
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
	    alert("이미지를 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="여러분의 생각을 입력해보세요. (최대100자)"){
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

	   frm.action = "/event/etc/doEventSubscript43248.asp";
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

//-->
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt46226">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_head.png" alt="어느 날, 당신에게 생긴 서프라이즈~! VOL 13 텐바이텐에게 여러분의 이야기를 들려주세요~ 정성껏 작성해주신 10분께 준비한 서프라이즈 선물을 드립니다. 이벤트 기간 : 10.28 ~ 11.10 ★당첨자 발표 : 11.11" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_img01.png" alt="" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_txt01.png" alt="얼마 남지 않은 크리스마스! 그 설레임을 담아! 올해가 가기 전에 꼭 받고 싶은 선물은?" style="width:100%;" /></p>
					<div class="research">
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
						<ul>
							<li>
								<p><input type="radio" name="spoint" value="1" id="cmt01" /></p>
								<p><label for="cmt01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_item01.png" alt="선택1" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="2" id="cmt02" /></p>
								<p><label for="cmt02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_item02.png" alt="선택2" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="3" id="cmt03" /></p>
								<p><label for="cmt03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_item03.png" alt="선택3" style="width:100%;" /></label></p>
							</li>
							<li>
								<p><input type="radio" name="spoint" value="4" id="cmt04" /></p>
								<p><label for="cmt04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_item04.png" alt="선택4" style="width:100%;" /></label></p>
							</li>
						</ul>
						<div class="myCollab"><textarea name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="여러분의 생각을 입력해보세요. (최대100자)" autocomplete="off">여러분의 생각을 입력해보세요. (최대100자)</textarea></div>
						<p><input type="image" alt="등록하기" class="enroll" src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_btn01.png" style="width:50%;" /></p>
					</form>
					</div>
					<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript43248.asp" style="margin:0px;">
						<input type="hidden" name="eventid" value="<%=eCode%>">
						<input type="hidden" name="bidx" value="<%=bidx%>">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					</form>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/46226/46226_txt02.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>

					<p class="total">Total <%=iCTotCnt%></p>
					<div class="story">
						<ul>
						<a name="rank" id="rank"></a>
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div class="type<% selchg() %>">
									<div class="txt">
										<p class="writer"><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님의 스토리
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											 <span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span>
										<% End If %>
										</p>
										<p class="cmt"><%=db2html(arrCList(1,intCLoop))%>
										<% If arrCList(8,intCLoop)="M" Then %>
										<span><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" alt="모바일에서 작성" width="9px" /></span><!--for dev msg : 모바일에서 작성시 노출 -->
										<% End If %>
										</p>
									</div>
								</div>
							</li>
							<% next %>
						<% End If %>
						</ul>
					</div>
					<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
				</div>
			</div>
			<!-- //content area -->

</body>
</html>