<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 크리스마스(참여1차) - 공유하기
' History : 2015-11-19 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->

<%
Dim eCode, userid, vTotalCount, sqlstr

userid = GetEncLoginUserID()

IF application("Svr_Info") = "Dev" THEN
	eCode   =  65955
Else
	eCode   =  67488
End If

'// 총 카운트
sqlstr = "select count(*) "
sqlstr = sqlstr & " from db_event.dbo.tbl_event_subscript"
sqlstr = sqlstr & " where evt_code='"& eCode &"'  "
rsget.Open sqlstr, dbget, 1

If Not rsget.Eof Then
	vTotalCount = rsget(0)
End IF
rsget.close

'// 쇼셜서비스로 글보내기 (2010.07.21; 허진원)
Dim vTitle, vLink, vPre, vImg

dim snpTitle, snpLink, snpPre, snpTag, snpTag2, snpImg
snpTitle = Server.URLEncode("[텐바이텐] 2015 크리스마스")
snpLink = Server.URLEncode("http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode)
snpPre = Server.URLEncode("10x10 이벤트")

'기본 태그
snpTag = Server.URLEncode("텐바이텐")
snpTag2 = Server.URLEncode("#10x10")

'// 카카오링크 변수
Dim kakaotitle : kakaotitle = "[텐바이텐] 2015 크리스마스\n\n여러분은 올해 어떤 크리스마스를 계획하고 계세요?\n\n텐바이텐에서 특별한 Gold Magic Christmas로 여러분을 초대합니다!\n\n매혹적인 크리스마스를 공유해주신 분들께 [골드매직 크리스마스 트리 세트]를 보내드려요!"
Dim kakaoimage : kakaoimage = "http://webimage.10x10.co.kr/eventIMG/2015/67488/m/67488kakao_v1.jpg"
Dim kakaoimg_width : kakaoimg_width = "200"
Dim kakaoimg_height : kakaoimg_height = "200"
Dim kakaolink_url
	If isapp = "1" Then '앱일경우
		kakaolink_url = "http://m.10x10.co.kr/apps/appcom/wish/web2014/event/eventmain.asp?eventid="&eCode
	Else '앱이 아닐경우
		kakaolink_url = "http://m.10x10.co.kr/event/eventmain.asp?eventid="&eCode
	end if
%>
<style type="text/css">
img {vertical-align:top;}
.mEvt67488 {position:relative; background:#fff;}
.btnShare {display:block; width:71%; margin:0 auto;}
.count {padding-top:6.2%; font-size:14px; font-weight:600; text-align:center;}
.count em {color:#d60000;}
.shareList {background:#e6eded;}
.shareList ul {overflow:hidden; padding:0 1.5625% 25px;}
.shareList li {float:left; width:50%;}
.shareList li:nth-child(3),
.shareList li:nth-child(6) {width:100%;}
/* layer popup */
.shareLayer {display:none; position:absolute; left:0; top:0; width:100%; height:100%; padding-top:40%; background:rgba(0,0,0,.42); z-index:100;}
.shareLayer .layerCont {position:relative;}
.shareLayer .layerCont .goShare {overflow:hidden; position:absolute; left:14%; top:50%; width:72%; z-index:110;}
.shareLayer .layerCont .goShare li {float:left; width:25%; padding:0 1.4%;}
.shareLayer .layerCont .btnClose {position:absolute; right:10%; top:20%; width:5.4%; z-index:110; background:transparent;}
@media all and (min-width:480px){

}
</style>
<script type="text/javascript">
$(function(){
	$('.btnShare').click(function(){
		$('.shareLayer').fadeIn(250);
		window.parent.$('html,body').animate({scrollTop:120}, 300);
	});
	$('.btnClose').click(function(){
		$('.shareLayer').fadeOut(250);
	});
});

function jsevtchk(sns){
	<% if Date() < "2015-11-23" or Date() > "2015-12-06" then %>
		alert('이벤트 응모 기간이 아닙니다.');
		return;
	<% else %>
	var result;
		$.ajax({
			type:"GET",
			url:"/event/etc/doeventsubscript/doEventSubscript67488.asp",
			data: "mode=2015xmas&sns="+sns,
			dataType: "text",
			async:false,
			cache:false,
			success : function(Data){
				result = jQuery.parseJSON(Data);
				if (result.resultcode=="11")
				{
					if(sns=="tw") {
						popSNSPost('tw','<%=snpTitle%>','<%=snpLink%>','<%=snpPre%>','<%=snpTag2%>');
					}else if(sns=="fb"){
						popSNSPost('fb','<%=snpTitle%>','<%=snpLink%>','','');
					}else if(sns=="kk"){
						parent_kakaolink('<%=kakaotitle%>','<%=kakaoimage%>','<%=kakaoimg_width%>','<%=kakaoimg_height%>','<%=kakaolink_url%>');
					}else if(sns=="ln"){
						popSNSPost('ln','<%=snpTitle%>','<%=snpLink%>','','');
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}
				else if (result.resultcode=="44")
				{
					<% If isapp="1" Then %>
						calllogin();
						return;
					<% else %>
						jsevtlogin();
						return;
					<% End If %>
				}
				else if (result.resultcode=="88")
				{
					alert("이벤트 기간이 아닙니다.");
					return;
				}
			}
		});
	<% end if %>
}

//상품이동
function jsViewItem(i){
	<% if isApp=1 then %>
		parent.fnAPPpopupProduct(i);
		return false;
	<% else %>
		top.location.href = "/category/category_itemprd.asp?itemid="+i+"";
		return false;
	<% end if %>
}
</script>
	<%''// 2015 크리스마스 ENJOY TOGETHER(참여1) %>
	<div class="mEvt67488">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/tit_christmas_with_tenten.jpg" alt="텐바이텐과 함께 하는 2015크리스마스" /></h2>
		<button class="btnShare"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/btn_share.png" alt="공유하기" /></button>

		<%''// 공유하기 레이어팝업 %>
		<div id="shareLayer" class="shareLayer">
			<div class="layerCont">
				<p><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/txt_share.png" alt="sns 채널에 2개 이상 공유하시면 이벤트에 자동 응모됩니다!" /></p>
				<ul class="goShare">
					<li><a href="" onclick="jsevtchk('fb'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/ico_facebook.png" alt="페이스북" /></a></li>
					<li><a href="" onclick="jsevtchk('tw'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/ico_twitter.png" alt="트위터" /></a></li>
					<li><a href="" onclick="jsevtchk('kk'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/ico_kakaotalk.png" alt="카카오톡" /></a></li>
					<li><a href="" onclick="jsevtchk('ln'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/ico_line.png" alt="라인" /></a></li>
				</ul>
				<button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/btn_close.png" alt="닫기" /></button>
			</div>
		</div>
		<%''// 공유하기 레이어팝업 %>

		<div class="count"><p>지금까지 <em><%= vTotalCount %></em>명이 참여해 주셨습니다!</p></div>

		<%''//  크리스마스 핫 아이템 %>
		<div class="shareList">
			<h3><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/tit_hot_item.png" alt="2015 CHRISTMAS HOT ITEM" /></h3>
			<ul>
				<li><a href="" onclick="jsViewItem('1377386'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_01.jpg" alt="#유러피안 스타일 오너먼트" /></a></li>
				<li><a href="" onclick="jsViewItem('1391090'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_02.jpg" alt="#크리스마스 골드 리스" /></a></li>
				<li><a href="" onclick="jsViewItem('1395256'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_03.jpg" alt="#크리스마스 스노우 트리세트 " /></a></li>
				<li><a href="" onclick="jsViewItem('1394378'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_04.jpg" alt="#메리크리스마스 글라스돔" /></a></li>
				<li><a href="" onclick="jsViewItem('1382461'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_05.jpg" alt="#화이트 별 캔들 랜턴" /></a></li>
				<li><a href="" onclick="jsViewItem('1360932'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_06.jpg" alt="#메탈 무드 플레이트" /></a></li>
				<li><a href="" onclick="jsViewItem('1313573'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_07.jpg" alt="#메모리 래인 캔들 워머 브라스" /></a></li>
				<li><a href="" onclick="jsViewItem('1164910'); return false;"><img src="http://webimage.10x10.co.kr/eventIMG/2015/67488/m/img_item_08.jpg" alt="#레드별 미니 트리" /></a></li>
			</ul>
		</div>
		<%''//   크리스마스 핫 아이템 %>

	</div>
	<%''// 2015 크리스마스 ENJOY TOGETHER(참여1) %>
<!-- #include virtual="/lib/db/dbclose.asp" -->