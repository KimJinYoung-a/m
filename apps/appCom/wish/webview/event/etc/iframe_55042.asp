<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 담고받고즐기고!
' History : 2014.09.22 원승현
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/iframe_55042Cls.asp" -->
<!-- #include virtual="/apps/appCom/wish/webview/lib/classes/Apps_eventCls.asp" -->

<%
dim eCode, blnitempriceyn, giftlimitcnt, eLinkCode
dim ename, cEvent, emimg, smssubscriptcount, usercell, userid

	IF application("Svr_Info") = "Dev" THEN
		eCode   =  "21307"
		eLinkCode = "21309"
	Else
		eCode   =  "55009"
		eLinkCode = "55042"
	End If


Dim ifr, page, i, y
page = request("page")

If page = "" Then page = 1

	userid = getloginuserid()

set cEvent = new ClsEvtCont
	cEvent.FECode = eCode
	cEvent.fnGetEvent
	
	eCode		= cEvent.FECode	
	ename		= cEvent.FEName
	emimg		= cEvent.FEMimg
	blnitempriceyn = cEvent.FItempriceYN	
set cEvent = Nothing


set ifr = new evt_wishfolder
	ifr.FPageSize = 5
	ifr.FCurrPage = page
	ifr.FeCode = eCode
	ifr.evt_wishfolder_list
%>


<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
.mEvt55010 img {vertical-align:top; width:100%;}
.mEvt55010 p {max-width:100%;}
.mEvt55010 .putMyWish {position:relative;}
.mEvt55010 .putMyWish .makeFolder {position:absolute; left:5%; bottom:5%; width:90%;}
.mEvt55010 .evtGuide {text-align:left; padding:25px 10px 30px; background:#e9f9f6;}
.mEvt55010 .evtGuide dt img {width:55px;}
.mEvt55010 .evtGuide dt {padding-bottom:15px;}
.mEvt55010 .evtGuide li {position:relative; padding:0 0 0 13px; font-size:11px; line-height:1.4; color:#444;}
.mEvt55010 .evtGuide li:after {content:' '; position:absolute; left:0; top:4px; display:inline-block; width: 0; height: 0; border-style: solid; border-width:3px 0 3px 6px; border-color: transparent transparent transparent #d50c0c;}
.mEvt55010 .share {position:relative;}
.mEvt55010 .share a {display:inline-block; position:absolute; top:60%; width:16%; height:22%; text-indent:-9999em; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55010/blank.png) left top repeat-x; background-size:100% 100%;}
.mEvt55010 .share a.twitter {left:22%; }
.mEvt55010 .share a.facebook {left:42%;}
.mEvt55010 .share a.kakaotalk {left:61%;}
.mEvt55010 .yourWishList {padding:25px 12px 10px;}
.mEvt55010 .yourWishList dt {color:#888; font-size:11px; line-height:1; margin-left:-1px; padding-bottom:4px; font-weight:bold; border-bottom:1px solid #ddd;}
.mEvt55010 .yourWishList dt span {padding-left:14px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55095/ico_cart.gif) left 50% no-repeat; background-size:9px 9px;}
.mEvt55010 .yourWishList dd {padding:10px 0 25px;}
.mEvt55010 .yourWishList dd ul {overflow:hidden; margin:0 -6px;}
.mEvt55010 .yourWishList dd li {float:left; width:33.33333%; padding:0 5px; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box;}
</style>
<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript">

function jsGoPage(iP){
	document.pageFrm.page.value = iP;
	document.pageFrm.submit();
}


<% if page>1 then %>
	setTimeout("$('html,body',parent.document).scrollTop(2745);", 200);
<% end if %>

Kakao.init('c967f6e67b0492478080bcf386390fdd');




function kakaosendcall(){
	kakaosend54471();
}

function kakaosend54471(){
	  Kakao.Link.sendTalkLink({
		  label: '[텐바이텐 EVENT]\n원하는 상품을 담고!\n모조리 받고! 친구랑 즐기고!\n텐바이텐이 최대 30만원!\n위시를 비워드립니다!',
		 appButton: {
			text: '10X10 앱으로 이동',
			execParams :{
			<% IF application("Svr_Info") = "Dev" THEN %>
				android: { url: encodeURIComponent('http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= eLinkCode %>')},
				iphone: { url: 'http://testm.10x10.co.kr:8080/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= eLinkCode %>'}
			<% Else %>
				android: { url: encodeURIComponent('http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= eLinkCode %>')},
				iphone: { url: 'http://m.10x10.co.kr/apps/appCom/wish/webview/event/eventmain.asp?eventid=<%= eLinkCode %>'}
			<% End If %>
			}
		  },
		  installTalk : Boolean
	  });
}


function jsSubmit()
{
	<% If IsUserLoginOK() Then %>
		<% If Now() > #09/30/2014 23:59:59# Then %>
			alert("이벤트가 종료되었습니다.");
			return;
		<% Else %>
			<% If getnowdate>="2014-09-22" and getnowdate<"2014-10-01" Then %>
				var frm = document.frm;
				frm.action="/apps/appcom/wish/webview/my10x10/event/myfavorite_folderProc.asp";
				frm.submit();
			<% else %>
				alert("이벤트 응모 기간이 아닙니다.");
				return;
			<% end if %>
		<% end if %>
	<% else %>
		parent.calllogin();
		return false;
	<% end if %>
}

</script>
<%
Dim sp, spitemid, spimg
Dim arrCnt
%>
</head>



<div id="content">
	<!-- 담고! 받고! 즐기고! -->
	<form name="frm" method="post">
	<input type="hidden" name="hidM" value="I">
	<div class="mEvt55010">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/tit_put_wish.png" alt="담고! 받고! 즐기고!" /></h2>
		<div class="putMyWish">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/tit_wish_process.png" alt="간단하게! 누구나 참여할 수 있어요!" /></p>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/img_wish_process.png" alt="간단하게! 누구나 참여할 수 있어요!" /></p>
			<p class="makeFolder"><a href="" onclick="jsSubmit(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/btn_make_folder.png" alt="폴더 만들고 이벤트 참여하기" /></a></p>
		</div>
		<div class="evtGuide">
			<dl>
				<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/tit_notice.png" alt="이벤트 안내" /></dt>
				<dd>
					<ul>
						<li>참여하기 버튼 클릭 시 &lt;담고받고즐기고!&gt; 폴더가 자동생성됩니다.</li>
						<li>참여하기 버튼을 클릭하셔야 이벤트 참여가능합니다.<br />(기존 폴더 이름 수정 시 이벤트 참여 불가)</li>
						<li>&lt;담고받고즐기고!&gt; 폴더는 1개만 생성가능합니다.</li>
						<li>해당 폴더에 총 30만원 상당의 원하시는 상품을 담아주세요.</li>
						<li>상품을 담으실 때는 판매가를 기준으로 담아주세요. 할인 상품의 경우는 할인 전 판매가를 확인해주세요.</li>
						<li>해당 폴더 외에 다른 폴더명에 담으시는 상품은 이벤트 참여대상에서 제외됩니다.<br />ex) 먹고마시고즐기고!(X), 받고담고즐기고!(X)</li>
					</ul>
				</dd>
			</dl>
		</div>
		</form>
		<p class="share">
		<%
		'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
		dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
		snpTitle = Server.URLEncode(ename)
		snpLink = Server.URLEncode("http://10x10.co.kr/event/55042")		' & ecode
		snpPre = Server.URLEncode("텐바이텐 이벤트")
		snpTag = Server.URLEncode("텐바이텐 " & Replace(ename," ",""))
		snpTag2 = Server.URLEncode("#10x10")
		snpImg = Server.URLEncode(emimg)
		%>
			<img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/txt_share_sns.png" alt="이렇게 하면 당첨 확률이 쑥쑥 올라가요!" />
			<a href="" onclick="popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');return false;" class="twitter">트위터</a>
			<a href="" onclick="popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');return false;" class="facebook">페이스북</a>
			<a href="" onclick="kakaosendcall(); return false;" class="kakaotalk">카카오톡</a>
		</p>

		<% If ifr.FResultCount > 0 Then%>
		<!-- 위시 리스트 -->
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2014/55010/tit_your_wish.png" alt="참여한 고객분들의 위시리스트를 공개합니다!" /></h3>
		<div class="yourWishList">
			<% For i = 0 to ifr.FResultCount -1 %>
			<dl>
				<dt><span><%=printUserId(ifr.FList(i).FUserid,2,"*")%> 님의 위시리스트</span></dt>
				<dd>
					<ul>
						<%
							arrCnt = Ubound(Split(ifr.FList(i).FArrIcon2Img,","))

							If ifr.FList(i).FCnt > 2 Then
								arrCnt = 3
							Else
								arrCnt = ifr.FList(i).FCnt
							End IF

							For y = 0 to CInt(arrCnt) - 1
								sp = Split(ifr.FList(i).FArrIcon2Img,",")(y)
								spitemid = Split(sp,"|")(0)
								spimg	 = Split(sp,"|")(1)
						%>
							<li><a href="/apps/appcom/wish/webview/category/category_itemPrd.asp?itemid=<%=spitemid%>" target="_top"><img src="http://webimage.10x10.co.kr/image/icon2/<%=GetImageSubFolderByItemid(spitemid)%>/<%=spimg%>" /></a></li>
						<%
							Next
						%>							
					</ul>
				</dd>
			</dl>
		<% Next %>
		</div>
		<%= fnDisplayPaging_New(page,ifr.FTotalCount,5,4,"jsGoPage") %>
		<% End If %>
		<!--// 위시 리스트 -->
	</div>
	<!--// 담고! 받고! 즐기고! -->
</div><!-- #content -->
<p>&nbsp;</p>
<p>&nbsp;</p>
<form name="pageFrm" method="get" action="<%=CurrURL()%>">
<input type="hidden" name="page" value="">
</form>

<!-- #include virtual="/lib/db/dbclose.asp" -->