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
	eCode   =  21019
Else
	eCode   =  47081
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

	iCPageSize = 10		'한 페이지의 보여지는 열의 수
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
%>
<!doctype html>
<html lang="ko">
<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 생활감정채널</title>
	<style type="text/css">
	.mEvt47087 {}
	.mEvt47087 p {max-width:100%;}
	.mEvt47087 img {vertical-align:top; display:inline;}
	.mEvt47087 .myType {background:#5da4bb;}
	.mEvt47087 .selectType {overflow:hidden; padding:0 5%;}
	.mEvt47087 .selectType li {float:left; width:44%; padding:0 3%; margin-bottom:18px; text-align:center;}
	.mEvt47087 .selectType li label {display:block; padding-bottom:5px;}
	.mEvt47087 .selectType li input {}
	.mEvt47087 .writeType {padding:0 8% 10%;}
	.mEvt47087 .writeType p {position:relative; padding:0 3px 25px 0;}
	.mEvt47087 .writeType label {display:block; position:absolute; left:0; top:0; }
	.mEvt47087 .writeType .enroll {-webkit-border-radius:0; -webkit-appearance:none;}
	.mEvt47087 .writeType .writeForm {display:block; margin-left:90px; height:30px; padding:0 5px; border:3px solid #ffee5f; background:#fff;}
	.mEvt47087 .writeType .writeForm input {display:block; width:100%; height:30px; border:0; padding:0; font-size:15px; font-weight:bold; line-height:30px; color:#000; background:#fff; }
	.mEvt47087 .myTypeList {margin-top:30px;}
	.mEvt47087 .myTypeList ol {margin-bottom:40px;}
	.mEvt47087 .myTypeList li {position:relative; height:72px; border-radius:6px; margin-bottom:10px; background-position:left top; background-repeat:no-repeat; background-size:auto 100%;}
	.mEvt47087 .myTypeList li.t01 {border:14px solid #947364; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_bg_type01.png);}
	.mEvt47087 .myTypeList li.t02 {border:14px solid #ff884d; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_bg_type02.png);}
	.mEvt47087 .myTypeList li.t03 {border:14px solid #abd989; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_bg_type03.png);}
	.mEvt47087 .myTypeList li.t04 {border:14px solid #fdb300; background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_bg_type04.png);}
	.mEvt47087 .myTypeList li .num {width:58px; position:absolute; left:0; bottom:4px; text-align:center; font-weight:bold; font-size:10px;  color:#999;}
	.mEvt47087 .myTypeList li .txtWrap {display:table; width:100%;}
	.mEvt47087 .myTypeList li .txt {display:table-cell; vertical-align:middle; height:64px; padding-left:60px; text-align:center; }
	.mEvt47087 .myTypeList li .txt p {padding:3px 0;}
	.mEvt47087 .myTypeList li .txtInfo {position:absolute; right:10px; bottom:4px; width:237px; color:#999; text-align:right; font-size:10px;}
	.mEvt47087 .myTypeList li .txtInfo .date {margin-left:4px; padding-left:8px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_blt_bar.png) left 50% no-repeat; background-size:1px auto;}
	.mWebtoonNav {overflow:hidden;}
	.mWebtoonNav li {float:left; width:25%;}
</style>
<script type="text/javascript">
<!--
 	function jsGoComPage(iP){
		location.href="/event/etc/iframe_47087.asp?iCC="+iP;
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
	    alert("패션아이템을 선택해주세요");
	    return false;
	   }

	   if(!frm.txtcomm.value||frm.txtcomm.value=="다섯글자로"){
	    alert("코멘트를 입력해주세요");
	    document.frmcom.txtcomm.value="";
	    frm.txtcomm.focus();
	    return false;
	   }
	   	if(GetByteLength(frm.txtcomm.value)>10){
			alert('최대 한글 5자 까지 입력 가능합니다.');
	    frm.txtcomm.focus();
	    return false;
		}
	   	if(GetByteLength(frm.txtcomm.value)!=10 ){
			alert('5글자로 입력해주세요.');
	    frm.txtcomm.focus();
	    return false;
		}
	   frm.action = "/event/etc/doEventSubscript46928.asp";
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
			if(document.frmcom.txtcomm.value =="다섯글자로"){
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
			document.frmcom.txtcomm.value="다섯글자로";
		}
	}
	function Limit(obj)
	{
	   var maxLength = parseInt(obj.getAttribute("maxlength"));
	   if ( obj.value.length > maxLength ) {
		alert("글자수는 최대 5자 입니다.");
		obj.value = obj.value.substring(0,maxLength); //100자 이하 튕기기
		}
	}

//-->
</script>
</head>
<body>

			<!-- content area -->
			<div class="content" id="contentArea">
				<div class="mEvt47087">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_head.png" alt="생활감정채널" style="width:100%;" /></div>
					<ul class="mWebtoonNav">
						<!-- for dev msg : nav02부터 해당 날짜가 되면 이미지명이 _off.png로 바뀌게 해주세요 -->
						<li class="nav01"><a href="/event/eventmain.asp?eventid=47087"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav01_on.png" alt="EPISODE 1" style="width:100%;" /></a></li>
						<% If Now() > #11/27/2013 00:00:00# Then %>
						<li class="nav02"><a href="/event/eventmain.asp?eventid=47088"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav02_off.png" alt="EPISODE 2" style="width:100%;" /></a></li>
						<% else %>
						<li class="nav02"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav02.png" alt="EPISODE 2" style="width:100%;" /></li>
						<% End If %>
						<li class="nav03"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav03.png" alt="EPISODE 3" style="width:100%;" /></li>
						<li class="nav04"><img src="http://fiximage.10x10.co.kr/m/2013/event/series/webtoon_nav04.png" alt="EPISODE 4" style="width:100%;" /></li>
					</ul>
					<dl>
						<dt><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_img01.png" alt="이상형" style="width:100%;" /></dt>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_img02.png" alt="내 이상형은 지적인 여자" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_img03.png" alt="내 이상형은 섹시한 여자" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_img04.png" alt="내 이상형은 귀여운 여자" style="width:100%;" /></dd>
						<dd><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_img05.png" alt="내 이상형은 처음 본 여자" style="width:100%;" /></dd>
					</dl>

					<!-- comment write -->
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_txt01.png" alt="COMMENT EVENT - 여러분의 이상형을 5글자로 들려주세요!" style="width:100%;" /></div>
					<div class="myType">
						<ul class="selectType">
							<li>
								<label for="type01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_select_type01.png" alt="아이띵소 레이백"  style="width:100%;" /></label>
								<input type="radio" name="spoint" value="1" id="type01" />
							</li>
							<li>
								<label for="type02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_select_type02.png" alt="베이직 니트 머플러"  style="width:100%;" /></label>
								<input type="radio" name="spoint" value="2" id="type02" />
							</li>
							<li>
								<label for="type03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_select_type03.png" alt="마크모크 장갑"  style="width:100%;" /></label>
								<input type="radio" name="spoint" value="3" id="type03" />
							</li>
							<li>
								<label for="type04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_select_type04.png" alt="이어 머플러"  style="width:100%;" /></label>
								<input type="radio" name="spoint" value="4" id="type04" />
							</li>
						</ul>
						<div class="writeType">
							<p>
								<label><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_txt02.png" alt="나의 이상형은" style="width:83px;" /></label>
								<span class="writeForm" ><input type="text" name="txtcomm" maxlength="5" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="다섯글자로" autocomplete="off" /></span>
							</p>
							<input type="image" class="enroll" src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_btn_enroll.png" style="width:100%;" />
						</div>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/47087/47087_txt03.png" alt="통신예절에 어긋나는 글이나 상업적인 글, 타 사이트에 관련된 글 또는 도용한 글은 관리자에 의해 사전 통보 없이 삭제될 수 있으며,이벤트 참여에 제한을 받을 수 있습니다." style="width:100%;" /></p>
				</form>
				<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript46928.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
					<!--// comment write -->

					<!-- comment list -->
					<style>

					</style>
					<a name="rank" id="rank"></a>
					<div class="myTypeList">
						<ol>
							<!-- for dev msg : 아이템 선택에 따라 li클래스 t01~04 / 리스트는 10개씩 노출됩니다. -->
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
							<li class="t0<%= arrCList(3,intCLoop) %>">
								<p class="num"><%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
								<div class="txtWrap">
									<div class="txt">
										<p><% If arrCList(8,intCLoop)="M" Then %><img src="http://fiximage.10x10.co.kr/web2013/event/ico_mobile.png" alt="모바일에서 작성" /><% End IF %> 나의 이상형은, <strong><%=db2html(arrCList(1,intCLoop))%></strong></p>
										<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<span class="btn btn6 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span>
										<% End If %>
									</div>
								</div>
								<p class="txtInfo">
									<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
									<span class="date"><%=FormatDate(arrCList(4,intCloop),"0000.00.00")%></span>
								</p>
							</li>
							<% next %>
						<% End If %>
						</ol>
						<div class="paging">
							<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
						</div>
					</div>
					<!--// comment list -->
				</div>
			</div>
			<!-- //content area -->

</body>
</html>
