<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : we wish, your wish!
' History : 2014.02.21 한용민 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/event/etc/event49651Cls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/itemOptionCls.asp" -->

<%
dim eCode, userid, subscriptcount, intLoop, ix
	eCode=getevt_code
	userid = getloginuserid()

subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")

dim iCPerCnt, iCPageSize, iCCurrpage, SortMethod, OrderType, vDisp, SellScope
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN iCCurrpage = 1
iCPageSize = 6
iCPerCnt = 5		'보여지는 페이지 간격
OrderType="ran"		'//최근담은순

dim nowOpenYN, fidx
	fidx		= requestCheckVar(request("fidx"),10)
	
nowOpenYN = false	'현재 선택폴더 공개설정 여부
if fidx	= "" then fidx = 0
	
dim myfavorite
set myfavorite = new Cevent49651_list
	myfavorite.FPageSize        = 6
	myfavorite.FCurrpage        = 1
	myfavorite.FScrollCount     = 5
	myfavorite.FRectOrderType   = OrderType
	myfavorite.FRectSortMethod  = SortMethod
	myfavorite.FRectDisp		= vDisp
	myfavorite.FRectSellScope	= SellScope
	myfavorite.FRectUserID      	= userid
	myfavorite.FRectviewisusing = "Y"
	myfavorite.FFolderIdx		= ""

	if userid<>"" then
		'//위시리스트 상품 리스트 검색
		myfavorite.getMyWishList
	end if

dim myfolder, arrList
set myfolder = new Cevent49651_list
	myfolder.FRectUserID      	= userid

	if userid<>"" then
		'위시리스트 폴더 검색
		arrList = myfolder.fnGetFolderList
	end if
set myfolder=nothing

dim ccomment
set ccomment = new Cevent_etc_common_list
	ccomment.FPageSize        = iCPageSize
	ccomment.FCurrpage        = iCCurrpage
	ccomment.FScrollCount     = iCPerCnt
	ccomment.frectordertype="new"
	ccomment.frectevt_code      	= eCode
	'ccomment.FRectUserID      	= userid
	ccomment.frectgubun="item"	
	ccomment.event_subscript_paging

'//sns용
dim cEvent, emimg, ename
set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent

	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > we WISH, your WISH!</title>
<style type="text/css">
.mEvt49652 img {vertical-align:top;}
.mEvt49652 p {max-width:100%;}
.ourWish .wishRealized .notice {position:relative;}
.ourWish .wishRealized .notice .btnRefresh {position:absolute; right:9.58333%; top:24.61538%; width:138px; height:45px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49652/btn_refresh.gif) left top no-repeat; background-size:138px 45px; cursor:pointer; text-indent:-999em;}
@media all and (max-width:480px){
	.ourWish .wishRealized .notice .btnRefresh {width:92px; height:30px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49652/btn_refresh.gif) left top no-repeat; background-size:92px 30px;}
}
.ourWish .wishRealized legend {visibility:hidden; overflow:hidden; position:absolute; top:-1000%; width:0; height:0; line-height:0;}
.ourWish .wishRealized .goodsSelect ul {overflow:hidden; margin-top:-1px; padding:0 9px;}
.ourWish .wishRealized .goodsSelect ul li {float:left; width:50%; min-height:300px; padding:20px 0 20px; border-top:1px solid #d6d6d6; color:#000; font-size:15px; text-align:center;}
.ourWish .wishRealized .goodsSelect ul li img {width:218px; height:218px;}
.ourWish .wishRealized .goodsSelect ul li label {display:block; width:218px; margin:0 auto; padding:12px 0; line-height:1.313em;}
.ourWish .wishRealized .goodsSelect ul li.addWish span {display:block; color:#b1b1b1; line-height:1.313em;}
@media all and (max-width:480px){
	.ourWish .wishRealized .goodsSelect ul li {min-height:200px; padding:10px 0 20px; font-size:12px;}
	.ourWish .wishRealized .goodsSelect ul li img {width:145px; height:145px;}
	.ourWish .wishRealized .goodsSelect ul li label {width:145px; padding:7px 0;}
}
.ourWish .wishWrite {margin-bottom:13px; /*background-color:#ff5578;*/}
.ourWish .wishWrite .iText {padding:0 15px 15px; background-color:#ffe6c3;}
.ourWish .wishWrite .iText input {width:100%; height:50px; border:3px solid #ff4f6f; color:#a3a3a3; font-size:15px; font-weight:bold; text-align:center;}
@media all and (max-width:480px){
	.ourWish .wishWrite .iText input {height:33px; font-size:12px;}
}
.ourWish .wishWrite .btnSubmit {padding-bottom:17px; background-color:#ffe6c3;}
.ourWish .putWishList {padding:0 13px; border-top:2px solid #dedede;}
.ourWish .putWishList .wishLetter {position:relative; min-height:120px; margin-top:13px; padding:6px 10px 6px 140px; border:4px solid #ffbbbb;}
.ourWish .putWishList .wishLetter.wishLetter01 {border:4px solid #ffbbbb;}
.ourWish .putWishList .wishLetter.wishLetter02 {border:4px solid #ffde6d;}
.ourWish .putWishList .wishLetter.wishLetter03 {border:4px solid #96eeab;}
.ourWish .putWishList .wishLetter.wishLetter04 {border:4px solid #94e4d8;}
.ourWish .putWishList .wishLetter .thumbnail {position:absolute; left:6px; top:6px}
.ourWish .putWishList .wishLetter .thumbnail img {width:120px; height:120px;}
.ourWish .putWishList .wishLetter .writer {position:relative; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49652/blt_heart_red.gif) left 3px no-repeat; background-size:7px 5px; font-size:13px;}
.ourWish .putWishList .wishLetter .writer em {padding-left:9px; color:#d81c1c;}
.ourWish .putWishList .wishLetter .writer em img {width:6px;}
.ourWish .putWishList .wishLetter .writer .number {position:absolute; right:0; top:0; color:#bcbcbc;}
.ourWish .putWishList .wishLetter .sum {height:70px; padding-top:20px; color:#000; font-size:18px;}
.ourWish .putWishList .wishLetter .date {color:#999; font-size:13px; text-align:right;}
.ourWish .putWishList .wishLetter .date .btnRemove {margin:-1px 4px 0 0; width:36px; height:13px; border:0; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49652/btn_delete.gif) left top no-repeat; background-size:36px 13px; text-indent:-999em; vertical-align:middle;}
@media all and (max-width:480px){
	.ourWish .putWishList .wishLetter {min-height:80px; border:4px solid #ffbbbb; padding-left:100px;}
	.ourWish .putWishList .wishLetter .thumbnail img {width:80px; height:80px;}
	.ourWish .putWishList .wishLetter .writer {font-size:11px;}
	.ourWish .putWishList .wishLetter .sum {height:35px; font-size:12px;}
	.ourWish .putWishList .wishLetter .date {font-size:11px;}
}
</style>

<script type="text/javascript">

function jsCheckLimit() {
	if ("<%=IsUserLoginOK%>"=="False") {
		jsChklogin('<%=IsUserLoginOK%>');
		return;
	}

	if (evtFrm1.txtcomm.value == '20자 이내로 입력해주세요'){
		evtFrm1.txtcomm.value='';
	}	
}

function jsGoComPage(iP){
	document.evtFrm1.iCC.value = iP;
	document.evtFrm1.submit();
}

//위시리스트 폴더내용보기
function SwapFidx49651(fidx){
	document.frmsearch.fidx.value = fidx;
	document.frmsearch.submit();
}

function jsDelComment(sub_idx)	{
	if(confirm("삭제하시겠습니까?")){
		evtFrm1.sub_idx.value = sub_idx;
		evtFrm1.mode.value="delcomment";
		evtFrm1.action="/event/etc/doEventSubscript49651.asp";
		evtFrm1.target="evtFrmProc";
   		evtFrm1.submit();
	}
}

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #03/09/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-02-24" and getnowdate<="2014-03-10" Then %>
				<% if subscriptcount<3 then %>
					if(frm.txtcomm.value =="로그인 후 글을 남길 수 있습니다."){
						jsChklogin('<%=IsUserLoginOK%>');
						return false;
					}

					var listitemid = document.getElementsByName("listitemid");
					var tmpitemid='';
					for(var i=0; i < listitemid.length;i++){
						if(listitemid[i].checked){
							tmpitemid = listitemid[i].value
						}
					}
					if (tmpitemid==''){
						alert('상품을 선택해 주세요.');
						return;
					}

					if (frm.txtcomm.value == '' || GetByteLength(frm.txtcomm.value) > 40 || frm.txtcomm.value == '20자 이내로 입력해주세요'){
						alert("코맨트가 없거나 제한길이를 초과하였습니다. 20자 까지 작성 가능합니다.");
						frm.txtcomm.focus();
						return;
					}
					
					frm.itemid.value=tmpitemid;
					frm.mode.value="addcomment";
					frm.action="/event/etc/doEventSubscript49651.asp";
					frm.target="evtFrmProc";
					frm.submit();
				<% else %>
					alert("응모는 하루 3번씩만 가능합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>				
		<% End If %>
	<% Else %>
		alert('로그인을 하셔야 참여가 가능 합니다');
		return;
		//if(confirm("로그인을 하셔야 참여가 가능 합니다. 로그인 하시겠습니까?")){
		//	var winLogin = window.open('/login/PopLoginPage.asp','popLogin','width=400,height=300');
		//	winLogin.focus();
		//	return;
		//}
	<% End IF %>
}

</script>

</head>
<body>

<div class="mEvt49652">
	<div class="ourWish">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/tit_our_wish.jpg" alt="소원이 이루어지는 위시리스트 we Wish, your Wish!" style="width:100%;" /></h2>
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/txt_our_wish.jpg" alt="시리스트는 상품만 담는게 아니예요. ‘이건 가져야만 한다!’ 하는 다짐과 희망을 담는거죠! 텐바이텐이 총 100분에게 위시리스트의 상품 모두를 보내드립니다. 이벤트 기간 : 2014.02.24 - 03.02 당첨자 발표 : 2014.03.06" style="width:100%;" /></p>

		<!-- 나만의 Wish List -->
		<form name="frmsearch" method="post" action="/event/etc/iframe_49651.asp" onsubmit="return false;" style="margin:0px;">
		<input type="hidden" name="fidx" value="<%=fidx%>">
		<input type="hidden" name="page" value="1">
		<input type="hidden" name="sscp" value="<%=SellScope%>">
		<input type="hidden" name="disp" value="<%=vDisp%>">
		<input type="hidden" name="ordertype" value="<%=orderType%>">
		<input type="hidden" name="wishsearch">
		<div class="onlyMyWish">
			<% if userid="" and not isarray(arrList) then %>
				<!-- for dev msg : 로그인 전 -->
				<div class="beforeLogin">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/txt_login_msg.jpg" alt="앗! 로그인이 필요해요! 로그인을 하고, 위시리스트를 채워주시면 이벤트에 응모하실 수 있습니다. *공개폴더로 설정된 위시리스트만 이벤트 응모가 가능합니다." style="width:100%;" /></p>
				</div>
				<!-- //for dev msg : 로그인 전 -->				
			<% else %>		
				<% IF isArray(arrList) THEN %>
					<!-- for dev msg : 로그인 후 -->
					<div class="afterLogin">
						<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/tit_my_wish_check.jpg" alt="나의 위시리스트 확인하기" style="width:100%;" /></h3>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/txt_wish_open.jpg" alt="공개로 설정된 나의 위시리스트 속 상품들을 확인하고 선택하세요. 새로고침 버튼을 눌러 꼭 갖고 싶은 상품을 찾아보세요! 공유폴더로 설정된 위시리스트만 이벤트 응모가 가능합니다." style="width:100%;" /></p>
					</div>
					<!-- //for dev msg : 로그인 후 -->
				<% else %>
					<% ' for dev msg : 위시가 없는 경우 %>
					<div class="beforeLogin">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/txt_no_wish.jpg" alt="앗! 위시리스트가 없어요! 위시리스트에 갖고 싶었던 상품을 가득 담아주시면 이벤트에 응모하실 수 있습니다. *공개폴더로 설정된 위시리스트만 이벤트 응모가 가능합니다." style="width:100%;" /></p>
					</div>
				<% end if %>
			<% end if %>
		</div>
		</form>
		<!-- //나만의 Wish List -->

		<!-- 소원을 들어 줄 Wish List -->
		<div class="wishRealized">
			<% ' for dev msg : 로그인 전이나, 위시가 없는 경우에는  <fieldset class="loginAndWish">...</fieldset> display:none; 처리해주세요. %>
			<fieldset class="loginAndWish" <% if userid="" or myfavorite.FResultCount<1 then %> style="display:none;"<% end if %>>
				<legend>소원을 이루어 줄 상품 선택하기</legend>
				<div class="notice">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/txt_wish_check_notice.gif" alt="상품은 랜덤으로 6개씩 보여지며 응모는 하루 3번씩만 가능합니다" style="width:100%;" /></p>
					<button type="button" onclick="location.reload();" class="btnRefresh">새로고침</button>
				</div>
				<div class="goodsSelect">
					<ul>
						<% ' for dev msg : 6개 고정입니다. 공개된 위시 상품이 6개가 되지 않을 경우 <li class="addWish">....</li>로 채워주세요. %>
						<% If myfavorite.FResultCount >0 Then %>
						<% for ix = 0 to myfavorite.FResultCount-1 %>
							<li>
								<img src="<% = myfavorite.FItemList(ix).FImageIcon2 %>" alt="<%= myfavorite.FItemList(ix).FItemName %>" />
								<label for="wishgoods0<%=ix+1 %>"><%= myfavorite.FItemList(ix).FItemName %></label>
								<input type="radio" id="wishgoods0<%=ix+1 %>" name="listitemid" value="<%= myfavorite.FItemList(ix).FItemid %>" />
							</li>
						<% next %>
						<% end if %>
						
						<% ' for dev msg : 공개된 위시가 없을 경우 %>
						<% if myfavorite.FResultCount<>6 and myfavorite.FResultCount<>0 Then %>
							<% for ix = 0 to 6-(myfavorite.FResultCount mod 6)-1 %>
							<li class="addWish">
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/img_wish_goods_no.jpg" alt="" />
								<span>위시리스트에<br /> 더 많은 상품을 담아보세요!</span>
							</li>							
							<% next %>
						<% end if %>
					</ul>
				</div>
			</fieldset>

			<%' for dev msg : 로그인 전이거나 위시가 없는 경우에는 .wishWrite에 background-color:#ff5578; 추가할 수 있을까요 %>
			<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
			<input type="hidden" name="mode">
			<input type="hidden" name="itemid">
			<input type="hidden" name="sub_idx">
			<input type="hidden" name="iCC" value="<%=iCCurrpage%>">
			<fieldset>
				<legend>소원 쓰기</legend>
				<div class="wishWrite" <% if userid="" or myfavorite.FResultCount<1 then %> style="background-color:#ff5578;"<% end if %>>
					<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/tit_wish_write.png" alt="위시와 함께 소원을 담아요" style="width:100%;" /></h3>
					<div class="iText">
						<input type="text" name="txtcomm" onClick="jsCheckLimit();" onKeyUp="jsCheckLimit();" <%IF NOT(IsUserLoginOK) THEN%>readonly<%END IF%> value="<%IF NOT IsUserLoginOK THEN%>로그인 후 글을 남길 수 있습니다.<% else %>20자 이내로 입력해주세요<%END IF%>" />
					</div>
					<div class="btnSubmit" onclick="jsSubmitComment(evtFrm1); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/49652/btn_submit.gif" alt="응모하기" style="width:100%;" /></div>
				</div>
			</fieldset>
			</form>
		</div>
		<!-- //소원을 들어 줄 Wish List -->

		<!-- 소원 리스트 -->
		<div class="putWishList">
			<% ' for dev msg : 6개씩 보여주세요. %>
			<% IF ccomment.ftotalcount>0 THEN %>
				<%
				dim rndNo : rndNo = 1
									
				for ix = 0 to ccomment.fresultcount - 1
	
				randomize
				rndNo = Int((4 * Rnd) + 1)		
				%>
					<div class="wishLetter wishLetter0<%= rndNo %>">
						<% ' for dev msg : 배경 클래스명 wishLetter01/wishLetter02/wishLetter03/wishLetter04 / for dev msg : Alt 값 상품명으로 넣어주세요. %>
						<div class="thumbnail">
							<a href="/shopping/category_prd.asp?itemid=<%= ccomment.FItemList(ix).fsub_opt2%>" target="_top">
							<img src="<%= ccomment.FItemList(ix).FImageicon2 %>" alt="" /></a>
						</div>
						<div class="writer">
							<em>
								<%=printUserId(ccomment.FItemList(ix).fuserid,2,"*")%>님의 소원 <!--<img src="http://webimage.10x10.co.kr/eventIMG/2014/49652/ico_mobile.gif" alt="모바일에서 작성한 글" />-->
							</em> 
							<span class="number">no.<%=ccomment.FTotalCount-ix-(ccomment.FPageSize*(ccomment.FCurrPage-1))%></span>
						</div>
						<p class="sum"><strong><%=ReplaceBracket(ccomment.FItemList(ix).fsub_opt3)%></strong></p>

						<% if ((userid = ccomment.FItemList(ix).fuserid) or (userid = "10x10")) and ( ccomment.FItemList(ix).fuserid<>"") then %>
							<div class="date">
								<button type="button" onclick="jsDelComment('<%= ccomment.FItemList(ix).fsub_idx %>');" class="btnRemove"><span>삭제</span></button> 
								<%=FormatDate(left(ccomment.FItemList(ix).fsub_opt1,10),"0000.00.00")%>
							</div>
						<% end if %>						
					</div>
				<% next %>
			<% end if %>
		</div>
		<!-- //소원 리스트 -->

		<% IF ccomment.ftotalcount>0 THEN %>
			<br /><br />
			<%= fnDisplayPaging_New(ccomment.FCurrpage, ccomment.ftotalcount, ccomment.FPageSize, ccomment.FScrollCount,"jsGoComPage") %>
		<% end if %>
	</div>
</div>
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>

<%
set myfavorite=nothing
set ccomment=nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->