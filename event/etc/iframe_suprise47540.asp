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
	eCode   =  21033
Else
	eCode   =  47540
End If

dim com_egCode, bidx
	Dim cEComment
	Dim cEComment1
	Dim iCTotCnt, arrCList,arrClist1,intCLoop, iSelTotCnt
	Dim iCPageSize, iCCurrpage
	Dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt
	Dim timeTern, totComCnt, FCpage, vPaging

	'파라미터값 받기 & 기본 변수 값 세팅
	vPaging = requestCheckVar(Request("paging"),1)
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
		case 5
			response.write "E"
		case 6
			response.write "F"
	End select
End function

%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 어느 날 당신에게 생긴 서프라이즈~!</title>
	<style type="text/css">
	.mEvt47541 {}
	.mEvt47541 img {vertical-align:top; display:inline;}
	.mEvt47541 .surprise {padding-bottom:25px; background:#fffae8;}
	.mEvt47541 .surprise .selectType {overflow:hidden; padding:0 1%; }
	.mEvt47541 .surprise .selectType li {float:left; width:29%; padding:0 2% 6%; text-align:center;}
	.mEvt47541 .surprise .selectType li label {display:block; padding-top:8px;}
	.mEvt47541 .surprise .writeForm {padding:0 2%;}
	.mEvt47541 .surprise .writeForm .txtBox {border:3px solid #ff767c; padding:10px; background:#fff;}
	.mEvt47541 .surprise .writeForm .txtBox textarea {display:block; width:100%; height:60px; font-size:12px; color:#888; border:0;}
	.mEvt47541 .surprise .writeForm .enroll {margin-top:10px; width:50%; margin-left:25%;}
	.mEvt47541 .surprise .writeForm .enroll input {-webkit-appearance: none; border-radius:0;}
	.mEvt47541 .myStory .total {text-align:right; font-size:11px; color:#888; padding:0 7px 5px 0; margin:15px 0 3px; border-bottom:1px solid #ddd;}
	.mEvt47541 .myStory ul {margin:0 8px 35px;}
	.mEvt47541 .myStory li {position:relative; margin-top:20px; font-size:11px;}
	.mEvt47541 .myStory li .cmtBox {position:absolute; left:27%; top:10%; width:68%; height:78%;}
	.mEvt47541 .myStory li .cmtBox .writer {color:#2c2c2c;}
	.mEvt47541 .myStory li .cmtBox .writer strong {display:inline-block; position:relative; top:2px;}
	.mEvt47541 .myStory li .cmtBox .txt {color:#707070; line-height:16px; padding-top:8px;}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="<%=CurrURL()%>?iCC="+iP;
	}
	function goPage(page)
	{
		document.frmcom.paging.value="o";
		document.frmcom.iCC.value=page;
		document.frmcom.action="";
		document.frmcom.submit();
	}

function GetByteLength(val){
 	var real_byte = val.length;
 	for (var ii=0; ii<val.length; ii++) {
  		var temp = val.substr(ii,1).charCodeAt(0);
  		if (temp > 127) { real_byte++; }
 	}

   return real_byte;
}

	function jsSubmitComment(frm){
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked||frm.spoint[4].checked||frm.spoint[5].checked)){
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

		<% '같은 구문이라 따로 파일을 안만듬. %>
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
				<div class="mEvt47541">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_head.png" alt="어느 날, 당신에게 생긴 서프라이즈~!" style="width:100%;" /></p>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_earth.png" alt="YOUR 2013 WEATHER!" style="width:100%;" /></p>
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="paging" value="">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<div class="surprise">
						<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_tit_weather.png" alt="당신의 2013년은 어땠나요? 2013년의 날씨를 선택하고, 2014년을 향한 응원메시지를 남겨주세요!" style="width:100%;"  /></p>
						<ul class="selectType">
							<li>
								<input type="radio" name="spoint" value="1" id="cmt01" />
								<label for="cmt01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather01.png" style="width:100%;" alt="선택1" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="2" id="cmt02" />
								<label for="cmt02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather02.png" style="width:100%;" alt="선택2" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="3" id="cmt03" />
								<label for="cmt03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather03.png" style="width:100%;" alt="선택3" /></label>
							</li>
						</ul>
						<ul class="selectType">
							<li>
								<input type="radio" name="spoint" value="4" id="cmt04" />
								<label for="cmt04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather04.png" style="width:100%;" alt="선택4" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="5" id="cmt05" />
								<label for="cmt05"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather05.png" style="width:100%;" alt="선택5" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="6" id="cmt06" />
								<label for="cmt06"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_img_weather06.png" style="width:100%;" alt="선택6" /></label>
							</li>
						</ul>
						<div class="writeForm">
							<p class="txtBox"><textarea cols="50" rows="3" name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="여러분의 생각을 입력해보세요. (최대100자)" autocomplete="off">여러분의 생각을 입력해보세요. (최대100자)</textarea></p>
							<p class="enroll"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_btn_enroll.png" style="width:100%;" alt="등록하기" /></p>
						</div>
					</div>
					</form>
					<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript43248.asp" style="margin:0px;">
						<input type="hidden" name="eventid" value="<%=eCode%>">
						<input type="hidden" name="bidx" value="<%=bidx%>">
						<input type="hidden" name="Cidx" value="">
						<input type="hidden" name="mode" value="del">
						<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					</form>
					<!--// 날씨 선택, 메시지 작성 -->
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_txt_caution.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며 이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>
					<!-- 메시지 목록 -->
					<div class="myStory">
						<p class="total">Total <%=iCTotCnt%></p>
						<ul>
						<a name="rank" id="rank"></a>
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li>
								<div class="cmtBox">
									<p class="writer">
										<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%> 님의 스토리</strong>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
											 <span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span>
										<% End If %>
									</p>
									<p class="txt"><%=db2html(arrCList(1,intCLoop))%>
									<% If arrCList(8,intCLoop)="M" Then %>
									<img width="9" class="mob" alt="모바일에서 작성됨" src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" />
									<% End If %>
									</p>
								</div>
								<p class="bg"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47541/47541_bg_weather<% selchg() %>.png" alt="" style="width:100%;" /></p>
							</li>
							<% next %>
						<% End If %>
						</ul>
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
					</div>
					<!--// 메시지 목록 -->
				</div>
			</div>
			<!-- //content area -->
<script>
<% If vPaging = "o" Then %>
var offset = $("#rank").offset();
window.parent.$("html, body").animate({scrollTop: offset.top},500);
<% End If %>
</script>
</body>
</html>