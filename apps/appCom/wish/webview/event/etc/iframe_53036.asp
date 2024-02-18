<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>

<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 어떤 WISH를 담으시겠어요?(A)
' History : 2014.06.27 유태욱
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event53036Cls.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/classes/item/iteminfoCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_myfavoritecls.asp" -->

<%
dim cEvent, eCode, ename, emimg, subscriptcount
dim usercell, userid
	eCode=getevt_code
	userid = getloginuserid()

dim OrderType, SortMethod, vDisp, SellScope

subscriptcount=0
subscriptcount = getevent_subscriptexistscount(eCode, userid, getnowdate, "", "")

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
set cEvent = nothing

dim nowOpenYN, fidx
	fidx		= requestCheckVar(request("fidx"),10)
	
nowOpenYN = false	'현재 선택폴더 공개설정 여부
if fidx	= "" then fidx = 0

dim myfavorite
set myfavorite = new Cevent53036_list
	myfavorite.FPageSize        = 10
	myfavorite.FCurrpage        = 1
	myfavorite.FScrollCount     = 10
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
set myfolder = new Cevent53036_list
	myfolder.FRectUserID      	= userid

	if userid<>"" then
		'위시리스트 폴더 검색
		arrList = myfolder.fnGetFolderList
	end if
set myfolder=nothing

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
				"	and foldername='담기만 해도 설레는 이벤트' "
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

<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->

<style type="text/css">
.mEvt53036 {position:relative;}
.mEvt53036 img {vertical-align:top; width:100%;}
.mEvt53036 p {max-width:100%;}
.mEvt53036 .wishProduct {overflow:hidden;}
.mEvt53036 .wishProduct li {position:relative; float:left; width:50%; text-align:center;}
.mEvt53036 .wishProduct li span {display:inline-block; position:absolute; left:0; bottom:8%; width:100%; text-align:center;}
.mEvt53036 .apply {padding:23px 20px;}
.mEvt53036 .apply input {width:100%; -webkit-border-radius:0;}
.mEvt53036 .evtNoti {width:94%; margin:0 auto; border-top:1px solid #7f7f7f; padding:24px 0 10px; text-align:left;}
.mEvt53036 .evtNoti dt {padding:0 0 12px 12px}
.mEvt53036 .evtNoti dt img {width:108px;}
.mEvt53036 .evtNoti dd {margin:0; padding:0;}
.mEvt53036 .evtNoti li {position:relative; padding:0 0 5px 12px; font-size:13px; color:#444; line-height:14px;}
.mEvt53036 .evtNoti li:after {content:''; display:block; position:absolute; top:2px; left:0; width:0; height:0; border-color:transparent transparent transparent #5c5c5c; border-style:solid; border-width: 4px 0 4px 6px;}
.mEvt53036 .evtNoti li strong {color:#d50c0c; font-weight:normal;}
@media all and (max-width:480px){
	.mEvt53036 .evtNoti dt img {width:75px;}
	.mEvt53036 .evtNoti li {padding:0 0 3px 12px; font-size:11px; line-height:12px; letter-spacing:-0.055em;}
	.mEvt53036 .evtNoti li:after {top:1px;}
}
</style>

<script src="/lib/js/kakao.Link.js"></script>
<script type="text/javascript">

function jsSubmitComment(frm){
	<% If IsUserLoginOK() Then %>
		<% If Now() > #07/06/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-06-30" and getnowdate<="2014-07-06" Then %>
				<% if subscriptcount<1 then %>
					//alert('아이템코드를 받아옵니다');
					var listitemid = document.getElementsByName("listitemid");
					var tmpitemid='';
					for(var i=0; i < listitemid.length;i++){
						if(listitemid[i].checked){
							tmpitemid = listitemid[i].value
						}
					}
					//alert('상품선택여부 판단');
					if (tmpitemid==''){
						alert('상품을 선택해 주세요.');
						return;
					}
					frm.itemid.value=tmpitemid;
					frm.action="/apps/appcom/wish/webview/event/etc/doEventSubscript53036.asp";
					frm.target="evtFrmProc";
					//alert('폼전송 합니다');
					frm.submit();
				<% else %>
					alert("한 ID당 한번만 참여가 가능합니다.");
					return;
				<% end if %>
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% End If %>
	<% Else %>
		//alert('로그인을 하셔야 참여가 가능 합니다');
		calllogin();
		//return;
	<% End IF %>
}
</script>

</head>
<body>

<!-- 어떤 WISH를 담으시겠어요?  -->
<div class="mEvt53036">
	<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/tit_my_wish.png" alt="어떤 WISH를 담으시겠어요?" /></h3>
	<ul class="wishProduct">
		<li>
			<label for="w01"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product01.png" alt="캠핑마니아 WISH" /></label>
			<span><input type="radio" id="w01" name="listitemid" value="1062995" /></span>
		</li>
		<li>
			<label for="w02"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product02.png" alt="비 오는날, WISH" /></label>
			<span><input type="radio" id="w02" name="listitemid" value="1067731" /></span>
		</li>
		<li>
			<label for="w03"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product03.png" alt="리듬에 몸을 맡겨 WISH" /></label>
			<span><input type="radio" id="w03" name="listitemid" value="1083137" /></span>
		</li>
		<li>
			<label for="w04"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product04.png" alt="여행의 기술 WISH" /></label>
			<span><input type="radio" id="w04" name="listitemid" value="870544" /></span>
		</li>
		<li>
			<label for="w05"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product05.png" alt="커피처럼 향긋한 WISH" /></label>
			<span><input type="radio" id="w05" name="listitemid" value="995513" /></span>
		</li>
		<li>
			<label for="w06"><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/img_wish_product06.png" alt="바람이 좋아 WISH" /></label>
			<span><input type="radio" id="w06" name="listitemid" value="1061520" /></span>
		</li>
	</ul>
	<form name="evtFrm1" action="" onsubmit="return false;" method="post" style="margin:0px;">
		<input type="hidden" name="itemid">
		<input type="hidden" name="sub_idx">
		<p class="apply"><a href="" onclick="jsSubmitComment(evtFrm1); return false;"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/53036/btn_apply.png" alt="응모하기" /></a></p>
	</form>
	<dl class="evtNoti">
		<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/53036/tit_notice.png" alt="이벤트 유의사항" /></dt>
		<dd>
			<ul>
				<li>텐바이텐 APP을 설치 후 로그인하여 응모하실 수 있습니다.</li>
				<li>한 ID당 1회 참여 가능합니다.</li>
				<li>당첨자 발표는 7월 8일 진행됩니다.</li>
				<li>당첨 시 상품수령 및 세무신고를 위해 개인정보를 요청할 수 있습니다.</li>
			</ul>
		</dd>
	</dl>
</div>

<!-- //어떤 WISH를 담으시겠어요?  -->
<iframe id="evtFrmProc" name="evtFrmProc" src="about:blank" frameborder="0" width=0 height=0></iframe>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->