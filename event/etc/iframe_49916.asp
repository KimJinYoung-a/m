<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 자, 이제 위시리스트 시작이야
' History : 2014.02.07 허진원 생성
'####################################################
%>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->
<%
	dim eCode, mECd

	IF application("Svr_Info") = "Dev" THEN
		eCode = "21106"
		mECd = "21109"
	Else
		eCode = "49915"
		mECd = "49916"
	End If

	dim strSql, isMaxFolder, isSubscript, vFidx, ix
	isSubscript = false
	isMaxFolder = false

	'// 이벤트 참여여부 및 위시폴더 확인
	if IsUserLoginOK then
		'응모여부 확인
		strSql = "select count(*) cnt " &_
				"from db_event.dbo.tbl_event_subscript " &_
				"where evt_code=" & eCode &_
				"	and userid='" & GetLoginUserID & "' "
		rsget.Open strSql,dbget,1
		if rsget(0)>0 then isSubscript = true		'응모여부
		rsget.Close

		if isSubscript then
			'이벤트 폴더 접수
			strSql = "select top 1 fidx " &_
					"from db_my10x10.dbo.tbl_myFavorite_folder " &_
					"where userid='" & GetLoginUserID & "' " &_
					"	and viewIsUsing='Y' " & _
					"	and foldername='[3월의 위시리스트]' "
			rsget.Open strSql,dbget,1
			if Not(rsget.EOF or rsget.BOF) then
				vFidx = rsget(0)
			else
				vFidx = 0
			end if
			rsget.Close
		else
			'위시폴더 수 확인
			strSql = "select count(*) cnt " &_
					"from db_my10x10.dbo.tbl_myFavorite_folder " &_
					"where userid='" & GetLoginUserID & "' "
			rsget.Open strSql,dbget,1
			if rsget(0)>=9 then isMaxFolder = true
			rsget.Close
		end if
	end if
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 자, 이제 WISH LIST 시작이야!</title>
<style type="text/css">
.mEvt49916 img {vertical-align:top; width:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49809/blt_square.png) left 8px no-repeat; background-size:3px 3px;}
.mEvt49916 p {max-width:100%;}
.mEvt49916 .evtNotice {padding:20px 10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_notice.png) left top repeat-y; background-size:100% auto;}
.mEvt49916 .evtNotice p {padding-bottom:12px;}
.mEvt49916 .evtNotice li {color:#fff; font-size:11px; line-height:16px; padding:0 0 3px 8px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/blt_round.png) left 6px no-repeat; background-size:3px 3px;}
.mEvt49916 .myWishWrap {padding-bottom:10px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_wish_cont.png) left top repeat-y; background-size:100% auto;}
.mEvt49916 .putList {padding-bottom:20px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_wish_cont_btm.png) left bottom no-repeat; background-size:100% auto;}
.mEvt49916 .putList ul {overflow:hidden; margin:0 4%; border-bottom:1px solid #ddd;}
.mEvt49916 .putList li {position:relative; float:left; width:46%; margin:0 2% 5%;}
.mEvt49916 .putList li span {display:none;}
.mEvt49916 .putList li span.on {position:absolute; left:0; top:0; display:block; width:100%; height:100%; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_check.png) left bottom no-repeat; background-size:100% 100%;}
.mEvt49916 .case01 {position:relative; padding-bottom:20px; }
.mEvt49916 .case01 .loginBtn {position:absolute;left:30%; top:50%; width:40%; }
.mEvt49916 .case02 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_wish_cont_mid.png) left top repeat-y; background-size:100% auto;}
.mEvt49916 .case02 .apply {width:60%; margin-left:20%;}
.mEvt49916 .case03 {position:relative; padding-bottom:20px;}
.mEvt49916 .case03 .goWishBtn {position:absolute; left:15%; top:55%; width:70%; }
.mEvt49916 .case04 {background:url(http://webimage.10x10.co.kr/eventIMG/2014/49916/bg_wish_cont_mid.png) left top repeat-y; background-size:100% auto;}
.mEvt49916 .case04 .more {width:76%; margin-left:12%;}
.noData {padding:80px 0 100px; text-align:center; font-size:12px;}
</style>
<script type="text/javascript">
function fnSubmit() {
<%
	If IsUserLoginOK Then
		if isSubscript then
			Response.Write "alert('이미 응모하셨습니다.');" &vbCrLf
	    	Response.Write "return;"
		else
			if Not(isMaxFolder) then
				Response.Write "if($('#lyrSeltItem .on').length<5) {" &vbCrLf
				Response.Write "	alert('상품은 최소 5개 이상 선택해주세요.');" &vbCrLf
				Response.Write "	return;" &vbCrLf
				Response.Write "} else {" &vbCrLf
				Response.Write "	document.frmSub.submit();" &vbCrLf
				Response.Write "}"
			else
				Response.Write "alert('위시리스트는 최대 10개까지만 생성이 가능합니다.\n이벤트에 참여를 원하시면 위시리스트를 정리해주세요.');" &vbCrLf
		    	Response.Write "return;"
			end if
		end if
	else
		Response.Write "alert('로그인 후에 응모하실 수 있습니다.');" &vbCrLf
		Response.Write "top.location.href='" & M_SSLUrl & "/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D" & mECd & "';" &vbCrLf
    	Response.Write "return;"
	end if
%>
}

function fnAddItem(elm) {
<% If IsUserLoginOK or not(isMaxFolder) Then %>
	if($("#lyrSeltItem .on").length>29) {
		alert("응모 상품은 30개까지 가능합니다.");
		return;
	}
	$(elm).find(".selItem").toggleClass("on")
	fnCalItems()
<% end if %>
}

function fnCalItems() {
	var tt="";
	$("#lyrSeltItem .on").each(function(){
		if(tt!="") tt+=",";
		tt+=$(this).attr("addIid");
	});
	$("#arrItem").val(tt);
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt49916">
		<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/wish_head.png" alt="자, 이제 WISH LIST 시작이야!" /></p>
		<div class="myWishWrap">
			<div class="putMyWish">
				<% If Not(IsUserLoginOK) Then %>
				<div class="case01">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_login.png" alt="로그인을 하시면 이벤트에 참여할 수 있어요!" /></p>
					<div class="loginBtn">
						<a href="<%=M_SSLUrl%>/login/login.asp?backpath=%2Fevent%2Feventmain%2Easp%3Feventid%3D<%=mECd%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/btn_login.png" alt="로그인" /></a>
					</div>
				</div>
				<%
					else
						if Not(isSubscript) then
							if Not(isMaxFolder) then
							'//이벤트 참여
								Dim cPopular, i, j
								Set cPopular = New CMyFavorite
								cPopular.FPageSize = 12
								cPopular.FCurrpage = 1
								cPopular.FRectSortMethod = "6"		'랜덤
								''cPopular.FRectUserID = GetLoginUserID()
								cPopular.fnPopularList
				%>
				<div class="case02">
					<div class="putList">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/tit_wish_list.png" alt="3월의 위시리스트" /></p>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_select.png" alt="아래의 리스트에서 원하는 사웊ㅁ을 5개 이상 선택해주세요!" /></p>
						<ul id="lyrSeltItem">
						<%
								If (cPopular.FResultCount > 0) Then
									For i = 0 To cPopular.FResultCount-1
						%>
							<li onclick="fnAddItem(this)">
								<img src="<%= getThumbImgFromURL(cPopular.FItemList(i).FImageBasic,200,200,"true","false") %>" alt="<%= Replace(cPopular.FItemList(i).FItemName,"""","") %>" />
								<span class="selItem" addIid="<%= cPopular.FItemList(i).FItemID %>">선택</span>
							</li>
						<%
									Next
								end IF
	
								Set cPopular = Nothing
						%>
						</ul>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_apply.png" alt="응모하기 버튼을 누르면 상품이 담긴 [3월의 위시리스트] 폴더가 생성됩니다." /></p>
						<p class="apply"><a href="" onclick="fnSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/btn_apply.png" alt="" /></a></p>
					</div>
				</div>
				<%
							else
							'// 기존 위시폴더가 10개 이상일 경우
				%>
				<div class="case03">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_already.png" alt="이미 10갸의 위시리스트를 갖고 계시군요! 위시리스트는 최대 10개까지만 생성이 가능합니다." /></p>
					<div class="goWishBtn">
						<a href="/my10x10/mywishlist.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/btn_go_wish.png" alt="나의 위시리스트 보러가기" /></a>
					</div>
				</div>
				<%
							end if
						else
						'//이벤트 참여 완료시 내 참여 위시 폴더 상품 출력

						dim myfavorite
						set myfavorite = new CMyFavorite
							myfavorite.FPageSize        = 10
							myfavorite.FCurrpage        = 1
							myfavorite.FScrollCount     = 10
							myfavorite.FRectUserID      = GetLoginUserID
							myfavorite.FFolderIdx		= vFidx
							if vFidx>0 then myfavorite.getMyWishList
				%>
				<div class="case04">
					<div class="putList">
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/tit_wish_list.png" alt="3월의 위시리스트" /></p>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_my_wish.png" alt="현재 3월의 위시리스트 상품 중 최대 10개만 보여집니다." /></p>
					<% If (myfavorite.FResultCount <1) Then %>
						<div class="noData">
							<p>폴더에 등록된 상품이 없습니다.</p>
						</div>
					<% else %>
						<ul>
							<% for ix = 0 to myfavorite.FResultCount-1 %>
							<li><a href="/category/category_itemPrd.asp?itemid=<%= myfavorite.FItemList(ix).FItemID %>" target="_top"><img src="<%=getThumbImgFromURL(myfavorite.FItemList(ix).FImageBasic,200,200,"true","false") %>" alt="<%= Replace(myfavorite.FItemList(ix).FItemName,"""","") %>" /></a></li>
							<% next %>
						</ul>
					<% end if %>
						<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/txt_more_wish.png" alt="응모하기 버튼을 누르면 상품이 담긴 [3월의 위시리스트] 폴더가 생성됩니다." /></p>
						<p class="more"><a href="/my10x10/mywishlist.asp?fidx=<%=vFidx%>" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/btn_wish_more.png" alt="" /></a></p>
					</div>
				</div>
				<%
						set myfavorite = Nothing
						end if
					end if
				%>
			</div>
		</div>
		<div class="evtNotice">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/tit_notice.png" alt="이벤트 유의사항" style="width:86px;" /></p>
			<ul>
				<li>본 이벤트는 텐바이텐 회원 대상입니다. (비회원 참여불가)</li>
				<li>한 아이디 당 위시리스트는 최대 10개까지 만드실 수 있습니다. 따라서 10개 이상의 위시리스트를 갖고 계신 고객님께서는 위시리스트를 정리해주셔야 이벤트 참여가 가능합니다.</li>
				<li>[3월의 위시리스트] 폴더에 최소 5개 이상의 상품을 담으셔야 하며, 3/19 (수) 자정까지 담겨있는 상품을 기준으로 발표합니다.</li>
				<li>폴더 명은 [3월의 위시리스트]만을 대상으로 하며, 폴더명을 직접 설정/수정 하신 경우에는 참여에서 제외됩니다. 꼭 상단 버튼을 통해 이벤트에 참여하셔야 합니다.</li>
				<li>상기의 상품 리스트에서 상품명을 클릭하시면, 해당 상품 상세정보 페이지로 이동합니다.</li>
			</ul>
		</div>
		<div><a href="/event/eventmain.asp?eventid=49809" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2014/49916/morning_banner.png" alt="ONLY 모바일 전용 이벤트 매일 아침 8시~10시! QR코드를 찍어 텐바이텐을 깨우면, 아침식사를 드려요!" /></a></div>
	</div>
<form name="frmSub" method="post" action="/event/etc/doEventSubscript49916.asp" style="margin:0px;" target="prociframe">
<input type="hidden" name="evt_code" value="<%=eCode%>">
<input type="hidden" id="arrItem" name="evt_option" value="">
</form>
<iframe name="prociframe" id="prociframe" frameborder="0" width="0" height="0" src="about:blank"></iframe>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->