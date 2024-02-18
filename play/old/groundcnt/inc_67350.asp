<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<%
'########################################################
' PLAY #26	PRESENT _ 선물말이야  
' 2015-11-13 원승현 작성
'########################################################
Dim eCode , sqlStr , userid , totcnt , iCTotCnt
IF application("Svr_Info") = "Dev" THEN
	eCode   =  "65948"
Else
	eCode   =  "67350"
End If

userid = GetEncLoginUserID

If GetEncLoginUserID <> "" then
	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where userid = '"& userid &"' and evt_code = '"& ecode &"' " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		totcnt = rsget(0)
	End IF
	rsget.close()
End If 

	sqlStr = "select count(*) from db_event.dbo.tbl_event_subscript where evt_code = '"& ecode &"' " 
	rsget.CursorLocation = adUseClient
	rsget.Open sqlStr, dbget, adOpenForwardOnly, adLockReadOnly 

	IF Not rsget.Eof Then
		iCTotCnt = rsget(0)
	End IF
	rsget.close()
%>
<style type="text/css">
img {vertical-align:top;}
.mPlay20151116 {}
.presentItem .item {position:relative;}
.presentItem .item a {display:block; position:absolute; left:10%; top:25%; width:80%; height:26%; background:rgba(0,0,0,0); color:transparent;}
.swiper {position:relative;}
.swiper .bPagination {position:absolute; bottom:4%; left:0; width:100%; height:10px; text-align:center; z-index:100;}
.swiper .bPagination span {display:inline-block; width:10px; height:10px; margin:0 7px; border:2.5px solid rgba(0,0,0,.2);; cursor:pointer; vertical-align:top; border-radius:50%;}
.swiper .bPagination .swiper-active-switch {border:0; background:rgba(0,0,0,.4);}
.getTalisman .eventApply {position:relative;}
.getTalisman .eventApply .btnApply {display:block; position:absolute; left:20%; bottom:15%; width:60%;}
.count {text-align:center; padding:10px 0 15px; background:url(http://webimage.10x10.co.kr/playmo/ground/20151116/bg_count.png) 0 0 repeat-y; background-size:100% auto;}
.count p {display:inline-block; height:23px; padding-left:15px; background:url(http://webimage.10x10.co.kr/playmo/ground/20151116/txt_count01.png) 0 0 no-repeat; background-size:12px 23px;}
.count img {width:209px; vertical-align:bottom;}
.count strong {display:inline-block; padding:0 3px; font-size:18px; line-height:0.9; font-family:verdana; vertical-align:bottom;}
@media all and (min-width:480px){
	.swiper .bPagination span {width:15px; height:15px; margin:0 11px; border:3px solid rgba(0,0,0,.2);}
	.count {padding:15px 0 23px;}
	.count p {height:35px; padding-left:23px; background-size:18px 35px;}
	.count img {width:312px;}
	.count strong {padding:0 4px; font-size:27px;}
}
</style>
<script type="text/javascript">
<!--
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
	   
	   <% if totcnt >= 5 then %>
			alert("최대 5회까지만 참여하실 수 있습니다.");
			return false;
	   <% end if %>


	   var frm = document.frmcom;
	   frm.action = "/play/groundcnt/doeventsubscript67350.asp";
	   frm.submit();
	   return true;
	}

	$(function(){
		showSwiper= new Swiper('.swiper1',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true, 
			pagination:'.bPagination',
			paginationClickable:true,
			speed:300
		});

		var chkapp = navigator.userAgent.match('tenapp');
		if ( chkapp ){
			$(".ma").show();
			$(".mw").hide();
		}else{
			$(".ma").hide();
			$(".mw").show();
		}
	});

//-->
</script>

<div class="mPlay20151116">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/tit_present.png" alt="선물말이야" /></h2>
	<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/txt_purpose.png" alt="꽃에는 그 의미를 지칭하는 꽃말들이 있습니다. 선물에도 미신처럼 따라다니는 선물말이 있습니다. 주는 사람을 망설여지게 하거나, 받는 사람에게 한 번쯤 생각하게 만드는 여러 가지 의미와 미신들! 하지만 이제 이 부적들과 함께 마음 놓고 선물하고, 좋은 의미는 더욱 재미있게 만들어보세요!" /></p>
	<div class="presentItem">
		<div class="item shoes">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_talisman01.png" alt="신발-연인에게 신발을 선물하면 그 신발을 신고 떠나 헤어지게 된다." /></p>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1188907'); return false;" class="ma">[Excelsior] Low Cut, U3199</a>
			<% Else %>
				<a href="/category/category_itemprd.asp?itemid=1188907" class="mw">[Excelsior] Low Cut, U3199</a>
			<% End If %>
		</div>
		<div class="item handkerchief">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_talisman02.png" alt="손수건-손수건은 슬픔을 의미해서 눈물을 부른다." /></p>

			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1285323'); return false;" class="ma">아이코닉 에브리데이 행키 v.3</a>
			<% Else %>
				<a href="/category/category_itemprd.asp?itemid=1285323" class="mw">아이코닉 에브리데이 행키 v.3</a>
			<% End If %>
		</div>
		<div class="item wallet">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_talisman03.png" alt="지갑-빨간 지갑을 선물하며 돈을 넣어 주면, 부자가 된다." /></p>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1339984'); return false;" class="ma">Fennec Mini Pocket Red</a>
			<% Else %>
				<a href="/category/category_itemprd.asp?itemid=1339984" class="mw">Fennec Mini Pocket Red</a>
			<% End If %>
		</div>
		<div class="item mirror">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_talisman04.png" alt="거울-나의 있는 그대로를 사랑해주고, 나만 바라봐 주기를." /></p>
			<% If isApp="1" Then %>
				<a href="" onclick="fnAPPpopupProduct('1114756'); return false;" class="ma">THE MIRROR</a>
			<% Else %>
				<a href="/category/category_itemprd.asp?itemid=1114756" class="mw">THE MIRROR</a>
			<% End If %>
		</div>
	</div>
	<div class="swiper">
		<div class="swiper-container swiper1">
			<div class="swiper-wrapper">
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_slide01.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_slide02.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_slide03.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_slide04.jpg" alt="" /></div>
				<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_slide05.jpg" alt="" /></div>
			</div>
		</div>
		<div class="bPagination"></div>
	</div>
	<!-- 이벤트 참여 -->
	<div class="getTalisman" id="tGetTalisman">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/tit_event.png" alt="선물말이야 이벤트" /></h3>
		<div><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/img_package.png" alt="패키지 이미지" /></div>
		<div class="eventApply">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/txt_event.png" alt="지금 선물을 망설이거나 고민 중이신가요? 이 부적 카드들과 함께 자신 있게, 즐겁게 선물하세요! 응모해주신 분들  중 추첨을 통해 총 5분에게  선물말이야 부적 PACK 을 드립니다." /></p>
			<input type="image" src="http://webimage.10x10.co.kr/playmo/ground/20151116/btn_apply.png" alt="응모하기" class="btnApply" onclick="jsSubmitComment();return false;" />
		</div>
		<div class="count">
			<p>
				<strong><%=iCTotCnt%></strong><img src="http://webimage.10x10.co.kr/playmo/ground/20151116/txt_count02.png" alt="명이 부적카드를 신청했습니다." />
			</p>
		</div>
	</div>
	<!--// 이벤트 참여 -->
</div>
<form name="frmcom" method="post">
	<input type="hidden" name="giftUserId" value="<%=userid%>">
</form>
<!-- #include virtual="/lib/db/dbclose.asp" -->