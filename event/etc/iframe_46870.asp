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
	eCode   =  21005
Else
	eCode   =  46726
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
<title>생활감성채널, 텐바이텐 > 이벤트 > EVERYDAY WATERFUL CHRISTMAS!</title>
<style type="text/css">
.mEvt46870 {}
.mEvt46870 img {vertical-align:top;}
.mEvt46870 .tMar06 {margin-top:6px;}
.mEvt46870 .bCont {position:relative;}
.mEvt46870 .bCont .innerBtn {position:absolute; left:50%;}
.mEvt46870 .tPad20 {padding-top:20px;}
.mEvt46870 .receiveAgree ul {overflow:hidden; width:100%;}
.mEvt46870 .receiveAgree li { float:left; width:50%;}
.mEvt46870 .receiveAgree li .agrCont {position:relative;}
.mEvt46870 .receiveAgree li .clickBtn {position:absolute; left:27%; bottom:8%; display:block; width:46%; height:13%; cursor:pointer; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46611/46611_btn_blank.png) left top no-repeat; background-size:100% 100%;}
.mEvt46870 .clickLyr {display:none;}
.mEvt46870 .clickLyrCont {padding:25px 0 20px; text-align:center; background:url(http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_bg_layer.png) left bottom no-repeat; background-size:100% auto;}
.mEvt46870 .clickLyrCont .agrInfo {padding-top:12px; font-size:18px; line-height:1; font-weight:bold; color:#cc0d0d;}
.mEvt46870 .clickLyrCont .btn {margin-top:13px;}
.mEvt46870 .circusPrd {overflow:hidden; width:99%; padding-left:1%; background:#fff9ee;}
.mEvt46870 .circusPrd li {float:left; width:33%;}
.mEvt46870 .writeMsg {position:relative; padding-bottom:100px; background:#fff9ee;}
.mEvt46870 .writeMsg .selectDrop {overflow:hidden;}
.mEvt46870 .writeMsg .selectDrop li {float:left; width:25%; text-align:center;}
.mEvt46870 .writeMsg .selectDrop li label {display:block; margin-bottom:5px;}
.mEvt46870 .writeMsg textarea {display:block; width:86%; padding:2%; margin:16px auto; border:2px solid #ffd161;}
.mEvt46870 .writeMsg .enroll {position:absolute; left:50%; bottom:8%; width:70%; margin-left:-35%;}
.mEvt46870 .totalMsg {position:relative;}
.mEvt46870 .totalMsg p {position:absolute; left:0; top:65%; width:100%; text-align:center;}
.mEvt46870 .totalMsg p span {display:inline-block; padding-bottom:3px; font-size:12px; line-height:12px; vertical-align:top; border-bottom:2px solid #ff6b09;}
.mEvt46870 .totalMsg p span em {position:relative; top:-1px; display:inline-block; vertical-align:top; font-weight:bold; color:#ff6b09;}
.mEvt46870 .dropList {margin-top:30px;}
.mEvt46870 .dropList li {position:relative; overflow:hidden; padding:0 15px; margin-top:8px; border:8px solid #e7edf0; border-left:6px solid #e7edf0; border-right:6px solid #e7edf0;}
.mEvt46870 .dropList li:first-child {marign-top:0;}
.mEvt46870 .dropList li .ftLt {float:left; width:30%; margin:18px 0; background-position:left top; background-repeat:no-repeat; background-size:100% 100%;}
.mEvt46870 .dropList li .ftRt { float:right; width:65%; height:100%; margin:10px 0 15px; padding-bottom:15px;}
.mEvt46870 .dropList li .txt {font-size:11px; line-height:13px; padding-top:8px;}
.mEvt46870 .dropList li .num {font-size:10px; padding-bottom:6px; color:#777; text-align:right; border-bottom:1px dashed #dfdfdf;}
.mEvt46870 .dropList li .num .mob {vertical-align:bottom;}
.mEvt46870 .dropList li .userInfo {position:absolute; left:37%; bottom:12px; font-size:10px; color:#999;}
.mEvt46870 .dropList li .userInfo .bar {padding:0 5px;}
.mEvt46870 .dropList li.d01 .ftLt {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop01.png);}
.mEvt46870 .dropList li.d02 .ftLt {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop02.png);}
.mEvt46870 .dropList li.d03 .ftLt {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop03.png);}
.mEvt46870 .dropList li.d04 .ftLt {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop04.png);}
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

	   if(!frm.txtcomm.value||frm.txtcomm.value=="100자 이내로 입력해 주세요."){
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

	   frm.action = "/event/etc/doEventSubscript46870.asp";
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
			if(document.frmcom.txtcomm.value =="100자 이내로 입력해 주세요."){
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
			document.frmcom.txtcomm.value="100자 이내로 입력해 주세요.";
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
				<div class="mEvt46870">
				<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
				<input type="hidden" name="iCTot" value="">
				<input type="hidden" name="mode" value="add">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_head.png" alt="EVERYDAY WATERFUL CHRISTMAS!" style="width:100%;" /></div>
					<div class="bCont">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img01.png" alt="깨끗한 물을 마시는 것,우리 모두가 누려야 할 기본 권리 입니다. 누구나 깨끗한 물을 마실 수 있고, 건강하고 행복한 삶을 살 수 있도록 여러분의 사랑으로 기적을 만들어 주세요 : )" style="width:100%;" />
						<p class="innerBtn" style="bottom:8%; width:70%; margin-left:-35%;"><a href="http://m.worldvision.or.kr/mobile/03_sponsor/sponsor_001.asp" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_btn01.png" alt="월드비전 식수사업 후원하기" style="width:100%;" /></a></p>
					</div>
					<div class="bCont">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img02.png" alt="Everyday Waterful Christmas Item" style="width:100%;" />
						<p class="innerBtn" style="bottom:8%; width:60%; margin-left:-30%;"><a href="/street/street_brand.asp?makerid=ithinkso"  target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_btn02.png" alt="Designed by ithinkso 브랜드 바로가기" style="width:100%;" /></a></p>
					</div>
					<div><a href="/category/category_itemPrd.asp?itemid=955779" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_product01.png" alt="2014 World Vision Calendar" style="width:100%;" /></a></div>
					<div><a href="/category/category_itemPrd.asp?itemid=955780" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_product02.png" alt="Mobile Card" style="width:100%;" /></a></div>
					<div class="bCont">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_blank.png" alt="Everyday Waterful Christmas Item" style="width:100%;" />
						<p class="innerBtn" style="top:10%; width:70%; margin-left:-35%;"><a href="/street/street_brand.asp?makerid=circusboyband"  target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_btn03.png" alt="Designed by circusboyband 브랜드 바로가기" style="width:100%;" /></a></p>
					</div>
					<ul class="circusPrd">
						<li><a href="/category/category_itemPrd.asp?itemid=871358" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_product03.png" alt="Cotton Bag" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=871341" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_product04.png" alt="sticker set" style="width:100%;" /></a></li>
						<li><a href="/category/category_itemPrd.asp?itemid=871349" target="_top" ><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_product05.png" alt="mug" style="width:100%;" /></a></li>
					</ul>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img03.png" alt="마을의 식수 펌프는 이렇게 만들어져요!" style="width:100%;" /></div>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img04.png" alt="응원 메시지 남기고 기부하자!" style="width:100%;" /></div>
					<div class="writeMsg">
						<ul class="selectDrop">
							<li>
								<label for="drop01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop01.png" alt="물방울1" style="width:100%;" /></label>
								<input type="radio" name="spoint" value="1" id="drop01" />
							</li>
							<li>
								<label for="drop02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop02.png" alt="물방울2" style="width:100%;" /></label>
								<input type="radio" name="spoint" value="2" id="drop02" />
							</li>
							<li>
								<label for="drop03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop03.png" alt="물방울3" style="width:100%;" /></label>
								<input type="radio" name="spoint" value="3" id="drop03" />
							</li>
							<li>
								<label for="drop04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img_drop04.png" alt="물방울4" style="width:100%;" /></label>
								<input type="radio" name="spoint" value="4" id="drop04" />
							</li>
						</ul>
						<textarea cols="70" rows="5" name="txtcomm" maxlength="100" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur()" onKeyUp="jsChklogin11('<%=IsUserLoginOK%>');return Limit(this);" <%IF NOT IsUserLoginOK THEN%>readonly<%END IF%>  value="100자 이내로 입력해 주세요." autocomplete="off">100자 이내로 입력해 주세요.</textarea>
						<p class="enroll"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_btn04.png" style="width:100%;" alt="응원메시지 등록하기" /></p>
					</div>
				</form>
				<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript46870.asp" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="Cidx" value="">
					<input type="hidden" name="mode" value="del">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img05.png" alt="이벤트 유의사항" style="width:100%;" /></div>
					<div class="totalMsg">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_img06.png" alt="여러분이 작성하신 응원메시지는 1개당 100원씩 적립되어 식수사업에 기부됩니다." style="width:100%;" />
						<p>
							<span>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_txt01.png" alt="총" style="width:23px;" />
								<em><%=iCTotCnt%></em>
								<img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_txt02.png" alt="개의 응원 메시지" style="width:64px;" />
							</span>
						</p>
					</div>
					<ul class="dropList">
						<!-- for dev msg : 위의 물방울 선택에 따라 클래스 d01~04 추가해주세요. / 리스트는 5개씩 노출됩니다. -->
						<a name="rank" id="rank"></a>
						<% IF isArray(arrCList) THEN %>
							<% For intCLoop = 0 To UBound(arrCList,2) %>
						<li class="d0<%= arrCList(3,intCLoop) %>">
							<div class="ftLt"><img src="http://webimage.10x10.co.kr/eventIMG/2013/46870/46870_bg_drop.png" alt="물방울 이미지" style="width:100%;" /></div>
							<div class="ftRt">
								<p class="num"><% If arrCList(8,intCLoop)="M" Then %><img src="http://fiximage.10x10.co.kr/m/2013/common/ico_mobile.png" width="9px" class="mob" alt="모바일에서 작성" /><% End If %> <strong>no.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></strong></p>
								<div class="txt">
									<p><%=db2html(arrCList(1,intCLoop))%></p>
								<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
									<p class="tMar06">
										<span class="btn btn5 gryB w40B"><a href="javascript:jsDelComment('<% = arrCList(0,intCLoop) %>')">삭제</a></span>
									</p>
								<% End If %>
								</div>
								<div class="userInfo">
									<strong><%=printUserId(arrCList(2,intCLoop),2,"*")%></strong>
									<span class="bar">|</span>
									<span class="date"><%=FormatDate(arrCList(4,intCloop),"0000.00.00")%></span>
								</div>
							</div>
						</li>
							<% next %>
						<% End If %>
					</ul>
					<div class="paging tMar25">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"goPage")%>
					</div>
				</div>
			</div>
			<!-- //content area -->

</body>
</html>