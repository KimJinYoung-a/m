<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  2015 텐텐 연말정산
' History : 2015.09.01 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_evaluatesearchercls.asp" -->
<%
dim eCode, vUserID, cMil, vMileValue, vMileArr
	vUserID = GetEncLoginUserID()
	'vUserID = "10x10yellow"
	If Now() > #09/02/2015 00:00:00# AND Now() < #09/06/2015 23:59:59# Then
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
<style type="text/css">
img {vertical-align:top;}
.mEvt57926 .viewMileage {padding:24px 0; text-align:center; color:#fff; background:#ff6c5d;}
.mEvt57926 .viewMileage .mgCont {font-size:12px; line-height:1.6; -webkit-text-size-adjust: 100%}
.mEvt57926 .viewMileage .mgCont strong {display:inline-block;  line-height:1.1;}
.mEvt57926 .viewMileage .mgCont .t01 {color:#fff; border-bottom:1px solid #fff;}
.mEvt57926 .viewMileage .mgCont .t02 {color:#ffea5f; border-bottom:1px solid #ffea5f;}
.mEvt57926 .viewMileage .mgCont .t03 {color:#c40000; border-bottom:1px solid #c40000;}
.mEvt57926 .viewMileage .mgBtn {width:85%; margin:0 auto; padding-top:12px;}
.mEvt57926 .viewReview {position:relative;}
.mEvt57926 .viewReview ul {position:absolute; left:5%; top:8%; width:90%; height:92%;  overflow:hidden;}
.mEvt57926 .viewReview li {float:left; width:50%; height:15%; padding:0 2%; margin-bottom:3.8%;}
.mEvt57926 .viewReview li a {display:none; width:100%; height:100%; background:url(http://webimage.10x10.co.kr/eventIMG/2014/55406/blank.png) left top repeat; background-size:100% 100%; text-indent:-9999em;}
.mEvt57926 .evtNoti {padding:30px 20px; background:#f9f8eb url(http://webimage.10x10.co.kr/eventIMG/2015/65902/m/bg_paper.png) repeat-y 50% 0; background-size:100% auto;}
.mEvt57926 .evtNoti dt {margin:0 auto; width:93px; padding-bottom:15px;}
.mEvt57926 .evtNoti li {position:relative; margin-top:3px; font-size:13px; line-height:1.688em; color:#917a70; padding-left:13px;}
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
<script>
$(function(){
	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
		$('a.ma').css('display','block');
	}else{
		$('a.mw').css('display','block');
	}
});

function jsSubmitComment(){
	<% If isapp="1" Then %>
		parent.calllogin();
		return;
	<% else %>
		parent.jsevtlogin();
		return;
	<% End If %>
}
</script>
	<div class="mEvt57926">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/tit_year_end_adjust.gif" alt="텐텐 연말정산" /></h2>
		<!-- 마일리지 확인하기 -->
		<% If IsUserLoginOK Then %>
			<div class="viewMileage">
				<div class="mgCont">
					<p><strong class="t01"><%=vUserID%></strong> 고객님,<br /> <strong class="t02"><%=vMileArr(0,0)%></strong> 개의 상품후기를 남길 수 있습니다.</p>
					<p>이벤트 기간 동안 예상 마일리지 적립금은 <strong class="t03"><%=FormatNumber(vMileArr(1,0),0)%></strong> 원 입니다.</p>
				</div>
				<% if isapp = "1" then %>
					<p class="mgBtn"><a href="" onclick="fnAPPpopupBrowserURL('상품후기','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/goodsusing.asp'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/btn_go_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a></p>
				<% else %>
					<p class="mgBtn"><a href="/my10x10/goodsusing.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/btn_go_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a></p>
				<% end if %>
				
			</div>
		<% else %>
			<div class="viewMileage">
				<div class="mgCont">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/txt_expect_mileage.png" alt="나의 예상 적립 마일리지를 확인하세요!" /></p>
				</div>
				<p class="mgBtn"><a href="#" onClick="jsSubmitComment(); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/btn_go_login.png" alt="로그인하기" /></a></p>
			</div>
		<% end if %>

		<div class="viewReview">
			<ul>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1185849" class="mw" target="_top">내폰에도 추석빔을</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1185849'); return false;" class="ma">내폰에도 추석빔을</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1246002" class="mw" target="_top">널 지켜보고 있다</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1246002'); return false;" class="ma">널 지켜보고 있다</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1095765" class="mw" target="_top">내 충전기는 소중하니까</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1095765'); return false;" class="ma">내 충전기는 소중하니까</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1113424" class="mw" target="_top">머리 속으로 치워버리자</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1113424'); return false;" class="ma">머리 속으로 치워버리자</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1197918" class="mw" target="_top">반짝반짝 트레이</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1197918'); return false;" class="ma">반짝반짝 트레이</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=771146" class="mw" target="_top">걸이에서 (feat.옷걸이)</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('771146'); return false;" class="ma">걸이에서 (feat.옷걸이)</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1328744" class="mw" target="_top">책상위의 서커스보이밴드</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1328744'); return false;" class="ma">책상위의 서커스보이밴드</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1202849" class="mw" target="_top">100% 펑키 트래쉬</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1202849'); return false;" class="ma">100% 펑키 트래쉬</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1116307" class="mw" target="_top">내 책상의 시크릿 향기</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1116307'); return false;" class="ma">내 책상의 시크릿 향기</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1300686" class="mw" target="_top">가을나들이는 미키와</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1300686'); return false;" class="ma">가을나들이는 미키와</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=972970" class="mw" target="_top">스탠드-UP!</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('972970'); return false;" class="ma">스탠드-UP!</a>
				</li>
				<li>
					<a href="/category/category_itemprd.asp?itemid=1289019" class="mw" target="_top">식탁위의 오아시스</a>
					<a href="#" onclick="parent.fnAPPpopupProduct('1289019'); return false;" class="ma">식탁위의 오아시스</a>
				</li>
			</ul>
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/img_best_review.jpg" alt="BEST상품에는 BEST리뷰가 따라온다!" /></p>
		</div>
		<dl class="evtNoti">
			<dt><img src="http://webimage.10x10.co.kr/eventIMG/2015/65902/m/tit_event_noti.png" alt="이벤트 유의사항" /></dt>
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
<!-- #include virtual="/lib/db/dbclose.asp" -->