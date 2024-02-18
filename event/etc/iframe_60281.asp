<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<%
'########################################################
' 토이 콘서트
' 2015-03-11 원승현 작성
'########################################################
Dim eCode, eLinkCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21492
	eLinkCode = 21495
Else
	eCode   =  60280
	eLinkCode = 60281
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

	iCPageSize = 4		'한 페이지의 보여지는 열의 수
	iCPerCnt = 4		'보여지는 페이지 간격


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

	Dim rencolor
	
	randomize

	rencolor=int(Rnd*8)+1

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
img {vertical-align:top;}
.mEvt60281 {}
.section2 {padding-top:10%; padding-bottom:12%; background:#7b6655 url(http://webimage.10x10.co.kr/eventIMG/2015/60281/bg_brown.png) no-repeat 50% 0; background-size:100% auto;}
.section2 ul {overflow:hidden; margin-top:5%; padding:0 1.8%;}
.section2 ul li {float:left; width:33.3333%;}
.section2 ul li:nth-child(1), .section2 ul li:nth-child(2) {width:50%;}
.section2 ul li:nth-child(1) a {display:block; margin-left:5%;}
.section2 ul li:nth-child(2) a {display:block; margin-right:5%;}
.section3 .article {background:url(http://webimage.10x10.co.kr/eventIMG/2015/60281/bg_letter.png) repeat-y 50% 0; background-size:100% auto;}
.field {padding:0 5%;}
.field legend {overflow:hidden; width:0; height:0; font-size:0; line-height:0; text-indent:-9999px;}
.field textarea {width:100%; border-radius:0; border:1px solid #bbb; vertical-align:top;}
textarea {-webkit-box-shadow: inset 3px 3px 5px 0px rgba(235,235,235,1);
-moz-box-shadow: inset 3px 3px 5px 0px rgba(235,235,235,1);
box-shadow: inset 3px 3px 5px 0px rgba(235,235,235,1);}
.field input {width:100%; margin-top:2%; margin-bottom:5%;}
.commentlist {padding:0 5%;}
.commentlist .col {position:relative; min-height:90px; margin-top:10px; padding:15px 15px 15px 80px;}
.commentlist .col .msg {font-size:12px; line-height:1.375em;}
.commentlist .col .writer {margin-top:10px; font-size:11px; line-height:1.375em;}
.commentlist .col .writer img {width:7px; margin-left:5px; vertical-align:middle;}
.commentlist .col .figure {position:absolute; top:50%; left:15px; width:50px; height:66px; margin-top:-33px; text-align:center;}
.commentlist .col .figure .no {font-size:11px;}
.commentlist .col .btndel {width:14px; height:14px; margin-left:5px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/60281/btn_del.png) no-repeat 50% 0; background-size:100% auto; text-indent:-999em; vertical-align:middle;}
.commentlist .col1 {background-color:#111; color:#fff;}
.commentlist .col2 {background-color:#fff; border:1px solid #ddd; color:#000;}
.commentlist .col3 {background-color:#fff; border:1px solid #ddd; color:#000;}
.commentlist .col4 {background-color:#111; color:#fff;}
.commentlist .col5 {background-color:#111; color:#fff;}
.commentlist .col6 {background-color:#fff; border:1px solid #ddd; color:#000;}
.commentlist .col7 {background-color:#fff; border:1px solid #ddd; color:#000;}
.commentlist .col8 {background-color:#111; color:#fff;}
@media all and (min-width:480px){
	.commentlist .col {min-height:135px; margin-top:15px; padding:25px 25px 25px 120px;}
	.commentlist .col .msg {font-size:16px;}
	.commentlist .col .figure {left:15px; width:80px; height:100px; margin-top:-50px;}
	.commentlist .col .figure .no {display:block; margin-top:5px; font-size:13px;}
	.commentlist .col .writer {margin-top:15px; font-size:13px;}
	.commentlist .col .writer img {width:9px;}
	.commentlist .col .btndel {width:18px; height:18px;}
}
</style>
<script type="text/javascript">
<!--
	$(function(){
		var txtW = $('.cmtTxt div').width() + 1;
		$('.cmtTxt div').css('width', txtW+'px');
		$('.cmtTxt div').css('display', 'block');

	});

	function jsGoComPage(iP){
		document.frmcom.iCC.value = iP;
		document.frmcom.iCTot.value = "<%=iCTotCnt%>";
		document.frmcom.submit();
	}


 	function jsSubmitComment(){
		<% if Not(IsUserLoginOK) then %>
			<% If isApp="1" or isApp="2" Then %>
			parent.calllogin();
			return false;
			<% else %>
			parent.jsevtlogin();
			return;
			<% end if %>			
		<% end if %>

		var frm = 	document.frmcom;

		if(!frm.txtcomm.value||frm.txtcomm.value==""){
			alert("댓글을 입력해주세요.");
			frm.qtext1.value="";
			frm.qtext1.focus();
			return false;
		}

		if(GetByteLength(frm.txtcomm.value)>600){
			alert('300자 까지 가능합니다.');
			frm.qtext1.focus();
			return false;
		}

	   var frm = document.frmcom;
	   frm.action = "/event/etc/doEventSubscript60281.asp";
	   frm.submit();
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
			if(document.frmcom.txtcomm.value ==""){
				document.frmcom.txtcomm.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur11()
	{
		if(document.frmcom.txtcomm.value ==""){
			document.frmcom.txtcomm.value="";
		}
	}

//-->
</script>
</head>
<body>
<div class="evtCont">
	<!-- iframe TOY (유희열) 콘서트 굿즈 및 이벤트 -->
	<div class="mEvt60281">
		<div class="section1">
			<h1><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/tit_toy.png" alt="토이 7집 발매 기념 콘서트 유희열" /></h1>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_visual.jpg" alt="TOY 7집 앨범 발매 기념 콘서트 공식 MD 텐바이텐 사전 판매 기간은 2015년 3월 11일부터 3월 31일까지며, 2015년 3월 23일부터 결제완료 기준으로 순차 발송됩니다." /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/txt_da_capo.jpg" alt="Toy 7집 발매 기념 콘서트 Da Capo 2014년의 겨울을 감성의 바다로 안내했던 유희열, 오랜만에 단독 콘서트를 열고 팬들과 만날 채비를 하고 있습니다. 늘 최고의 음악을 들려줬던 것 처럼 감동의 순간을 선물할 Da Capo 입니다. 공연일자는 2015년 4월 2일 목요일부터 4월 4일 토요일이며 공연장소는 올림픽공원 체조경기장입니다." /></p>
		</div>

		<div class="section2">
			<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/tit_official_md.png" alt="공식 MD" /></h2>
			<ul>
				<li>
					<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
						<a href="" onclick="parent.fnAPPpopupProduct(1230912);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_01.png" alt="머그컵" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1230912" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_01.png" alt="머그컵" /></a>
					<% End If %>
				</li>
				<li>
					<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
						<a href="" onclick="parent.fnAPPpopupProduct(1230913);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_02.png" alt="포토 엽서 세트" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1230913" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_02.png" alt="포토 엽서 세트" /></a>
					<% End If %>
				</li>
				<li>
					<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
						<a href="" onclick="parent.fnAPPpopupProduct(1230914);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_03.png" alt="노트" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1230914" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_03.png" alt="노트" /></a>
					<% End If %>
				</li>
				<li>
					<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
						<a href="" onclick="parent.fnAPPpopupProduct(1230915);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_04_v3.png" alt="유리컵 &amp; 워머" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1230915" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_04_v3.png" alt="유리컵 &amp; 워머" /></a>
					<% End If %>
				</li>
				<li>
					<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
						<a href="" onclick="parent.fnAPPpopupProduct(1230916);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_05.png" alt="에코백" /></a>
					<% Else %>
						<a href="/category/category_itemPrd.asp?itemid=1230916" target="_blank"><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/img_item_05.png" alt="에코백" /></a>
					<% End If %>
				</li>
			</ul>
		</div>

		<div class="section3">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/txt_comment.png" alt="토이 콘서트 Da Capo에 대한 기대평을 남겨주세요. 정성껏 코멘트 남겨주신 분들 중 추첨을 통해 아티스트의 사인이 담긴 official MD를 선물로 드립니다. 기간은 2015년 03월 11일부터 03월 25일까지며, 당첨자 발표는 2015년 03월 27일 입니다." /></p>
			<div class="article">
				<!-- comment write -->
				<div class="field" id="ToyCom">
					<form name="frmcom" method="post" style="margin:0px;" action="#ToyCom">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="mode" value="add">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
					<input type="hidden" name="txtcommURL" value="<%=rencolor%>">
						<fieldset>
							<legend>토이 콘서트 Da Capo에 대한 기대평 남기기</legend>
							<textarea id="txtcomm" name="txtcomm" cols="60" rows="5" title="기대평 쓰기" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur11();"></textarea>
							<input type="image" src="http://webimage.10x10.co.kr/eventIMG/2015/60281/btn_submit.png" alt="기대평 남기기" onclick="jsSubmitComment();return false;" />
							<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/bg_dashed_line.png" alt="" /></div>
						</fieldset>
					</form>
				</div>

				<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript60281.asp" style="margin:0px;">
				<input type="hidden" name="eventid" value="<%=eCode%>">
				<input type="hidden" name="bidx" value="<%=bidx%>">
				<input type="hidden" name="Cidx" value="">
				<input type="hidden" name="mode" value="del">
				<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
				</form>				


				<% IF isArray(arrCList) THEN %>
					<!-- comment list -->
					<div class="commentlist">
						<%' for dev msg : <div class="col">...</div>이 한 묶음입니다. col1 ~ col8 클래스명 / 아이콘 ico_music_01 ~ ico_music_08 랜덤으로 뿌려주세요 %>
						<%' for dev msg : 한페이지당 4개 %>
						<% 
							For intCLoop = 0 To UBound(arrCList,2)
						%>
							<div class="col col<%=arrCList(7,intCLoop)%>">
								<div class="figurewrap">
									<div class="figure">
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/ico_music_0<%=arrCList(7,intCLoop)%>.png" alt="" />
										<strong class="no">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></strong>
									</div>
								</div>
								<p class="msg"><%=nl2br(arrCList(1,intCLoop))%></p>
								<div class="writer">
									<span class="id"><%=printUserId(arrCList(2,intCLoop),2,"*")%></span>
									<% If arrCList(8,intCLoop) = "M"  then%>
										<img src="http://webimage.10x10.co.kr/eventIMG/2015/60280/ico_mobile.png" alt="모바일에서 작성" width="7" />
									<% End If %>
									<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
										<button type="button" class="btndel" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</button>
									<% End If %>
								</div>
							</div>
						<% Next %>
					</div>
					<!-- paging -->
					<div class="paging">
						<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
					</div>
				<% End If %>				

				<div><img src="http://webimage.10x10.co.kr/eventIMG/2015/60281/bg_letter_btm.png" alt="" /></div>
			</div>
		</div>
	</div>
	<!--// iframe -->
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->