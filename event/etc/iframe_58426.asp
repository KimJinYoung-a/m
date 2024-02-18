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
' 2015 설 이벤트
' 2015-01-16 원승현 작성
'########################################################
Dim eCode, eLinkCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21441
	eLinkCode = 21443
Else
	eCode   =  58421
	eLinkCode = 58426
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

	iCPageSize = 8		'한 페이지의 보여지는 열의 수
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

	rencolor=int(Rnd*7)+1

%>
<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<style type="text/css">
.mEvt58426 {}
.mEvt58426 img {vertical-align:top;}
.mEvt58426 .sulTab {overflow:hidden;}
.mEvt58426 .sulTab li {float:left; width:25%;}
.mEvt58426 .saleMore {position:relative;}
.mEvt58426 .saleMore a {position:absolute; right:0; top:35%; width:20%; height:65%; display:block; text-indent:-999em; overflow:hidden;}
.mEvt58426 .cmtInput {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_input.png) center top no-repeat; background-size:100%; padding-bottom:60.46%; text-align:center;}
.mEvt58426 .cmtInput div {position:absolute; width:100%; height:100%; left:0; top:0;}
.mEvt58426 .cmtInput div p {padding-top:15%; width:70%; margin:0 auto;}
.mEvt58426 .cmtInput input {border:3px solid #be190c; width:100%; height:40px; margin:0 auto; text-align:center; color:#000; font-size:22px; padding:0;}
.mEvt58426 .evtBtn {display:block; width:60.625%; padding-top:16%; margin:0 auto;}
.mEvt58426 .cmtViewList {overflow:hidden; padding:10px 0; border-bottom:1px solid #ddd;}
.mEvt58426 .cmtViewList li {padding:10px 5px; width:50%; float:left; text-align:left; position:relative;}
.mEvt58426 .cmtViewList li .num {font-size:9px; color:#333; font-family:verdana, tahoma, dotum, sans-serif; padding-bottom:5px;}
.mEvt58426 .cmtViewList li .bgBox {position:relative; background-position:center top; background-repeat:no-repeat; background-size:100%; width:100%; padding-bottom:66%; text-align:left; color:#000; /*padding:19.5% 19.5% 21% 19.5%;*/ line-height:1.2;}
.mEvt58426 .cmtViewList li.bg01 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg1.png);}
.mEvt58426 .cmtViewList li.bg02 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg2.png);}
.mEvt58426 .cmtViewList li.bg03 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg3.png);}
.mEvt58426 .cmtViewList li.bg04 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg4.png);}
.mEvt58426 .cmtViewList li.bg05 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg5.png);}
.mEvt58426 .cmtViewList li.bg06 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg6.png);}
.mEvt58426 .cmtViewList li.bg07 .bgBox {background-image:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_bg7.png);}
.mEvt58426 .cmtViewList li .bgBox .cmtTxt {position:absolute; top:0%; left:0; bottom:0; width:100%; height:100%;}
.mEvt58426 .cmtViewList li .bgBox .cmtTxt div {padding-top:20%; margin:0 auto; display:inline-block; white-space:nowrap;}
.mEvt58426 .cmtViewList li .bgBox strong {font-size:11px; color:#000; display:block;}
.mEvt58426 .cmtViewList li .bgBox span {font-size:20px; color:#000; display:block; font-weight:bold; letter-spacing:0.035em; }
.mEvt58426 .cmtViewList li .date {position:absolute; right:7%; bottom:12%; text-align:right; font-size:9px; color:#666; font-family:verdana, tahoma, dotum, sans-serif; letter-spacing:-0.025em;}
.mEvt58426 .cmtViewList li .del {font-size:10px; color:#000; padding:3px 10px 2px 10px; position:absolute; right:5px; top:4px; display:block; background-color:#fff; border:1px solid #cbcbcb; text-align:center; border-radius:2px;}
.mEvt58426 .cmtViewList li .mobile {position:absolute; right:7%; top:20%; text-indent:-999em; overflow:hidden; width:9px; height:14px; background:url(http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_mobile.png) center top no-repeat; background-size:9px 14px;}
.mEvt58426 .pdtCont {min-height:90px;}
.mEvt58426 .pdtList li:nth-child(5) {background:none;}
.mEvt58426 .pdtList li:nth-child(6) {background:none;}
@media all and (min-width:480px){
	.mEvt58426 .cmtInput input {border:4px solid #be190c; height:60px; font-size:33px;}
	.mEvt58426 .evtBtn {padding-top:18%;}
	.mEvt58426 .cmtViewList {overflow:hidden; padding:10px 0; border-bottom:1px solid #ddd;}
	.mEvt58426 .cmtViewList li {padding:15px 7px;}
	.mEvt58426 .cmtViewList li .num {font-size:13px; padding-bottom:7px;}
	.mEvt58426 .cmtViewList li .bgBox strong {font-size:16px;}
	.mEvt58426 .cmtViewList li .bgBox span {font-size:30px;}
	.mEvt58426 .cmtViewList li .date {font-size:13px;}
	.mEvt58426 .cmtViewList li .del {font-size:15px; padding:4px 15px 3px 15px; right:7px; top:6px; border-radius:3px;}
	.mEvt58426 .cmtViewList li .mobile {width:13px; height:21px; background-size:13px 21px;}
	.mEvt58426 .pdtCont {min-height:135px;}
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

		if(!frm.qtext1.value||frm.qtext1.value=="5자 내외"){
			alert("댓글을 입력해주세요.");
			frm.qtext1.value="";
			frm.qtext1.focus();
			return false;
		}

		if(GetByteLength(frm.qtext1.value)>11){
			alert('5자 까지 가능합니다.');
			frm.qtext1.focus();
			return false;
		}

	   var frm = document.frmcom;
	   frm.action = "/event/etc/doEventSubscript58426.asp";
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
			if(document.frmcom.qtext1.value =="5자 내외"){
				document.frmcom.qtext1.value="";
			}
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChklogin22(blnLogin)
	{
		if (blnLogin == "True"){
			return true;
		} else {
			jsChklogin('<%=IsUserLoginOK%>');
		}

		return false;
	}

	function jsChkUnblur11()
	{
		if(document.frmcom.qtext1.value ==""){
			document.frmcom.qtext1.value="";
		}
	}

	function jsChkUnblur22()
	{
		if(document.frmcom.qtext2.value ==""){
			document.frmcom.qtext2.value="200자 내외로 적어주세요.";
		}
	}

	function jsDownCoupon(stype,idx){
			<% if Not(IsUserLoginOK) then %>
				<% If isApp="1" or isApp="2" Then %>
					parent.calllogin();
				<% else %>
					parent.jsevtlogin();
				<% end if %>
			return false;
			<% end if %>

		
		if(confirm('쿠폰을 받으시겠습니까?')) {
			var frm;
			frm = document.frmC;
			frm.stype.value = stype;
			frm.idx.value = idx;
			frm.submit();
		}
	}


//-->
</script>
</head>
<body>
<div class="mEvt58426">
	<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tit.png" alt="2015 설날 선물-대잔치" /></h2>
	<ul class="sulTab">
		<li>
			<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
				<a href="" onclick="parent.fnAPPpopupEvent(58498);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab01.png" alt="효도는 셀프 부모님께" /></a>
			<% Else %>
				<a href="/event/eventmain.asp?eventid=58498" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab01.png" alt="효도는 셀프 부모님께" /></a>
			<% End If %>
		</li>
		<li>
			<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
				<a href="" onclick="parent.fnAPPpopupEvent(58499);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab02.png" alt="존경하는 부장님께" /></a>
			<% Else %>
				<a href="/event/eventmain.asp?eventid=58499" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab02.png" alt="존경하는 부장님께" /></a>
			<% End If %>
		</li>
		<li>
			<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
				<a href="" onclick="parent.fnAPPpopupEvent(58500);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab03.png" alt="행복충전 당충전" /></a>
			<% Else %>
				<a href="/event/eventmain.asp?eventid=58500" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab03.png" alt="행복충전 당충전" /></a>
			<% End If %>
		</li>
		<li>
			<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
				<a href="" onclick="parent.fnAPPpopupEvent(58501);return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab04.png" alt="뭐니뭐니해도 머니가 최고" /></a>
			<% Else %>
				<a href="/event/eventmain.asp?eventid=58501" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_tab04.png" alt="뭐니뭐니해도 머니가 최고" /></a>
			<% End If %>
		</li>
	</ul>
	<p><a href="" onClick="javascript:jsDownCoupon('prd,prd,prd','9962,9963,9964'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_btn_down.png" alt="3종 모두 따운받기" /></a></p>
	<div class="saleMore">
		<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_subtit.png" alt="놓치면 후회! 바겐쎄일" onclick="parent.fnAPPpopupEvent(58428);return false;" />
			<a href="" onclick="parent.fnAPPpopupEvent(58428);return false;">더보기</a>
		<% Else %>		
			<img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_subtit.png" alt="놓치면 후회! 바겐쎄일" onclick="top.location.href='/event/eventmain.asp?eventid=58428'" />
			<a href="" onclick="top.location.href='/event/eventmain.asp?eventid=58428'">더보기</a>
		<% End If %>
	</div>

	<div class="inner10 bgWht">
		<div class="pdtListWrap">
			<ul class="pdtList">
			<%

				Dim cEventItem, iTotCnt, intI

				set cEventItem = new ClsEvtItem
				cEventItem.FECode 	= "58428"
				cEventItem.FEGCode 	= ""
				cEventItem.FEItemCnt= 6
				cEventItem.FItemsort= "3"
				cEventItem.fnGetEventItem
				iTotCnt = cEventItem.FTotCnt


			%>

			<% For intI =0 To iTotCnt %>
				<% If Trim(isApp)="1" Or Trim(isApp)="2" Then %>				
					<li onclick="parent.fnAPPpopupProduct('<%=cEventItem.FCategoryPrdList(intI).Fitemid%>');return false;" <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then %>class="soldOut"<% End If %>>
				<% Else %>
					<li onclick="top.location.href='/category/category_itemPrd.asp?itemid=<% = cEventItem.FCategoryPrdList(intI).Fitemid %>&flag=e';" <% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then %>class="soldOut"<% End If %>>
				<% End If %>
					<div class="pPhoto">
						<% IF cEventItem.FCategoryPrdList(intI).IsSoldOut Then %>
							<p><span><em>품절</em></span></p>
						<% End If %>
							<img src="<%= getThumbImgFromURL(cEventItem.FCategoryPrdList(intI).FImageBasic,300,300,"true","false") %>" alt="<% = cEventItem.FCategoryPrdList(intI).FItemName %>" /></div>
					<div class="pdtCont">
						<p class="pBrand"><% = cEventItem.FCategoryPrdList(intI).FBrandName %></p>
						<p class="pName"><% = cEventItem.FCategoryPrdList(intI).FItemName %></p>
						<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem or cEventItem.FCategoryPrdList(intI).isCouponItem Then %>
							<% IF cEventItem.FCategoryPrdList(intI).IsSaleItem Then %>
								<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %>원 <span class="cRd1">[<% = cEventItem.FCategoryPrdList(intI).getSalePro %>]</span></p>
							<% End IF %>
							<% IF cEventItem.FCategoryPrdList(intI).IsCouponItem Then %>
								<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).GetCouponAssignPrice,0) %>원 <span class="cGr1">[<% = cEventItem.FCategoryPrdList(intI).GetCouponDiscountStr %>]</span></p>
							<% End IF %>
						<% Else %>
							<p class="pPrice"><% = FormatNumber(cEventItem.FCategoryPrdList(intI).getRealPrice,0) %><% if cEventItem.FCategoryPrdList(intI).IsMileShopitem then %> Point<% else %> 원<% end  if %></p>
						<% End if %>						
						</p>
					</div>
				</li>
			<% Next %>
			</ul>
		</div>
	</div>

	<div class="cmtWrap">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_tit.png" alt="COMMENT EVENT" /></h2>
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_subtit.png" alt="아래빈칸을 재치있게 채워주세요!" /></h3>
		<form name="frmcom" method="post" style="margin:0px;" action="#commW">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
		<input type="hidden" name="iCTot" value="">
		<input type="hidden" name="mode" value="add">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		<input type="hidden" name="txtcommURL" value="<%=rencolor%>">
		<div class="cmtInput"> 
			<div>
				<p><input type="" maxlength="5" name="qtext1" onClick="jsChklogin11('<%=IsUserLoginOK%>');" onblur="jsChkUnblur11();" onKeyDown="javascript:if (event.keyCode == 13) jsSubmitComment();" /></p>
				<span class="evtBtn"><a href="" onclick="jsSubmitComment();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/58426/58426_cmt_btn.png" alt="응모하기" /></a></span>
			</div>
		</div>
		</form>
		<form name="frmdelcom" method="post" action="/event/etc/doEventSubscript58426.asp" style="margin:0px;">
		<input type="hidden" name="eventid" value="<%=eCode%>">
		<input type="hidden" name="bidx" value="<%=bidx%>">
		<input type="hidden" name="Cidx" value="">
		<input type="hidden" name="mode" value="del">
		<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
		</form>
		<% IF isArray(arrCList) THEN %>
			<ul class="cmtViewList" id="commW">
			<% 
				For intCLoop = 0 To UBound(arrCList,2)
			%>
				<li class="bg0<%=arrCList(7,intCLoop)%>"><%' for dev msg : bg01~bg07 클래스 랜덤으로 붙여주세요 %>
					<p class="num">No.<%=iCTotCnt-intCLoop-(iCPageSize*(iCCurrpage-1)) %></p>
					<div class="bgBox">
						<div class="cmtTxt">
							<div>
								<strong>설날엔 역시,</strong>
								<span><%=Trim(arrCList(1,intCLoop))%></span>
							</div>
						</div>
					</div>
					<p class="date"><%=formatdate(arrCList(4,intCLoop),"0000.00.00")%> / <%=printUserId(arrCList(2,intCLoop),2,"*")%></p>
					<% if ((GetLoginUserID = arrCList(2,intCLoop)) or (GetLoginUserID = "10x10")) and ( arrCList(2,intCLoop)<>"") then %>
						<a href="" class="del" onclick="jsDelComment('<% = arrCList(0,intCLoop) %>');return false;">삭제</a><%' for dev msg : 내가 쓴글 삭제버튼 %>
					<% End If %>
					<% If arrCList(8,intCLoop) = "M"  then%>
						<span class="mobile">모바일에서 작성되었습니다</span><%' for dev msg : 모바일에서 작성시 노출 %>
					<% End If %>
				</li>
			<% Next %>
			</ul>
		<% End If %>
		<div class="paging">
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</div>
	</div>
</div>
<form name="frmC" method="get" action="/shoppingtoday/couponshop_process.asp" style="margin:0px;">
<input type="hidden" name="stype" value="">
<input type="hidden" name="idx" value="">
</form>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->