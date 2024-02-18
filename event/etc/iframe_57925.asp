<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
	Dim vUserID, eCode, cMil, vMileValue, vMileArr
	vUserID = GetLoginUserID
	'vUserID = "10x10yellow"
	IF application("Svr_Info") = "Dev" THEN
		eCode = "21417"
	Else
		eCode = "57926"
	End If
	
	If Now() > #12/24/2014 00:00:00# AND Now() < #12/31/2014 23:59:59# Then
		vMileValue = 200
	Else
		vMileValue = 100
	End If

	Set cMil = New CEvaluateSearcher
	cMil.FRectUserID = vUserID
	cMil.FRectMileage = vMileValue
	
	If vUserID <> "" Then
		vMileArr = cMil.getEvaluatedTotalMileCnt
	End If
	Set cMil = Nothing
%>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>[상품후기] 더블 마.일.리.지</title>
<style type="text/css">
.mEvt57926 .viewMileage {padding:24px 0; text-align:center; color:#fff; background:#8d6959;}
.mEvt57926 .viewMileage .mgCont {font-size:12px; line-height:1.6; -webkit-text-size-adjust: 100%}
.mEvt57926 .viewMileage .mgCont strong {display:inline-block;  line-height:1.1;}
.mEvt57926 .viewMileage .mgCont .t01 {color:#fff; border-bottom:1px solid #fff;}
.mEvt57926 .viewMileage .mgCont .t02 {color:#ffdb5f; border-bottom:1px solid #ffdb5f;}
.mEvt57926 .viewMileage .mgCont .t03 {color:#fe8125; border-bottom:1px solid #fe8125;}
.mEvt57926 .viewMileage .mgBtn {width:85%; margin:0 auto; padding-top:12px;}
.mEvt57926 .viewReview {position:relative;}
.mEvt57926 .viewReview ul {position:absolute; left:5%; top:8%; width:90%; height:92%;  overflow:hidden;}
.mEvt57926 .viewReview li {float:left; width:50%; height:15%; padding:0 2%; margin-bottom:3.8%;}
.mEvt57926 .viewReview li a {display:none; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt57926 .evtNoti {padding:30px 20px; background:url(http://webimage.10x10.co.kr/eventIMG/2014/57926/blank.png) left top repeat; background-size:100% 100%;}
.mEvt57926 .evtNoti dt {margin:0 auto; width:93px; padding-bottom:15px;}
.mEvt57926 .evtNoti li {position:relative; font-size:12px; line-height:1.4; color:#917a70; padding-left:13px;}
.mEvt57926 .evtNoti li:after {content:' '; position:absolute; left:0; top:5px; width:6px; height:2px; background:#917a70;}
@media all and (min-width:480px){
	.mEvt57926 .viewMileage {padding:36px 0;}
	.mEvt57926 .viewMileage .mgCont {font-size:18px;}
	.mEvt57926 .viewMileage .mgBtn {padding-top:18px;}
	.mEvt57926 .evtNoti {padding:45px 30px;}
	.mEvt57926 .evtNoti dt {width:140px; padding-bottom:23px;}
	.mEvt57926 .evtNoti li {font-size:18px; padding-left:20px;}
	.mEvt57926 .evtNoti li:after {top:7px; width:9px; height:3px;}
}
</style>
<% if isApp=1 then %>
<script type="text/javascript" src="/apps/appCom/wish/web2014/lib/js/customapp.js"></script>
<% end if %>
<script type="text/javascript">
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsLoginLogin(){
	<% if isApp=1 then %>
		parent.calllogin();
		return false;
	<% else %>
		parent.jsChklogin_mobile('','<%=Server.URLencode("/event/eventmain.asp?eventid="&eCode&"")%>');
		return false;
	<% end if %>
}

function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}

function jsGoGoodsUsing(){
	<% if isApp=1 then %>
		fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp');
	<% else %>
		top.location.href = "/my10x10/goodsusing.asp";
	<% end if %>
}
</script>
</head>
<body>
<div class="content" id="contentArea">
	<div class="mEvt57926">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/tit_year_end_adjust.gif" alt="더블 마일리지" /></h2>
		<% If IsUserLoginOK Then %>
		<div class="viewMileage">
			<div class="mgCont">
				<p><strong class="t01"><%=vUserID%></strong> 고객님,<br /> <strong class="t02"><%=vMileArr(0,0)%></strong> 개의 상품후기를 남길 수 있습니다.</p>
				<p>이벤트 기간 동안 예상 마일리지 적립금은 <strong class="t03"><%=FormatNumber(vMileArr(1,0),0)%></strong> 원 입니다.</p>
			</div>
			<p class="mgBtn"><a href="" onClick="jsGoGoodsUsing(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/btn_go_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a></p>
		</div>
		<% Else %>
		<div class="viewMileage">
			<div class="mgCont">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/txt_expect_mileage.png" alt="나의 예상 적립 마일리지를 확인하세요!" /></p>
			</div>
			<p class="mgBtn"><a href="" onClick="jsLoginLogin();return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/btn_go_login.png" alt="로그인하기" /></a></p>
		</div>
		<% End If %>
		<div class="viewReview">
			<ul>
				<li>
					<a href="" onClick="jsViewItem('1157043'); return false;" class="mw" target="_top">베스트상품1</a>
					<a href="" onclick="jsViewItem('1157043'); return false;" class="ma">베스트상품1</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('280991'); return false;" class="mw" target="_top">베스트상품2</a>
					<a href="" onclick="jsViewItem('280991'); return false;" class="ma">베스트상품2</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('976316'); return false;" class="mw" target="_top">베스트상품3</a>
					<a href="" onclick="jsViewItem('976316'); return false;" class="ma">베스트상품3</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1177009'); return false;" class="mw" target="_top">베스트상품4</a>
					<a href="" onclick="jsViewItem('1177009'); return false;" class="ma">베스트상품4</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1163356'); return false;" class="mw" target="_top">베스트상품5</a>
					<a href="" onclick="jsViewItem('1163356'); return false;" class="ma">베스트상품5</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1171610'); return false;" class="mw" target="_top">베스트상품6</a>
					<a href="" onclick="jsViewItem('1171610'); return false;" class="ma">베스트상품6</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('686254'); return false;" class="mw" target="_top">베스트상품7</a>
					<a href="" onclick="jsViewItem('686254'); return false;" class="ma">베스트상품7</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('195325'); return false;" class="mw" target="_top">베스트상품8</a>
					<a href="" onclick="jsViewItem('195325'); return false;" class="ma">베스트상품8</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1171538'); return false;" class="mw" target="_top">베스트상품9</a>
					<a href="" onclick="jsViewItem('1171538'); return false;" class="ma">베스트상품9</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('837396'); return false;" class="mw" target="_top">베스트상품10</a>
					<a href="" onclick="jsViewItem('837396'); return false;" class="ma">베스트상품10</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('1071404'); return false;" class="mw" target="_top">베스트상품11</a>
					<a href="" onclick="jsViewItem('1071404'); return false;" class="ma">베스트상품11</a>
				</li>
				<li>
					<a href="" onClick="jsViewItem('940482'); return false;" class="mw" target="_top">베스트상품12</a>
					<a href="" onclick="jsViewItem('940482'); return false;" class="ma">베스트상품12</a>
				</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/img_best_review.jpg" alt="BEST상품에는 BEST리뷰가 따라온다!" /></p>
		</div>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2014/57926/tit_event_noti.png" alt="이벤트 유의사항" /></dt>
			<dd>
				<ul>
					<li>이벤트 기간 내에 새롭게 작성하신 상품후기에 한해서만 더블 마일리지가 적용됩니다.</li>
					<li>기존에 작성했던 상품후기 수정은 적용되지 않습니다.</li>
					<li>상품후기가 삭제된 경우에는 마일리지 지급이 되지 않습니다.</li>
					<li>상품후기는 배송정보 [출고완료] 이후부터 작성 하실 수 있습니다.</li>
					<li>상품과 관련 없는 내용이나 이미지를 올리거나, 직접 찍은 사진이 아닐 경우 삭제 및 마일리지 지급이 취소 될 수 있습니다.</li>
				</ul>
			</dd>
		</dl>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->