<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'#############################################################
' Description : [컬쳐] 영화 <슈퍼배드 3> in 텐바이텐
' History : 2017-07-06 원승현 생성
'#############################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/item/itemInfoCls.asp" -->
<!-- #include virtual="/lib/classes/item/CategoryPrdCls.asp" -->
<%
	Dim eCode
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  66382
	Else
		eCode   =  78751
	End If

	dim userid, i, UserAppearChk, nowdate
		userid = GetEncLoginUserID()

	nowdate = Left(Now(), 10)

	'// 응모여부 확인
	Dim vQuery
	vQuery = "SELECT count(*) FROM [db_event].[dbo].[tbl_event_subscript] WHERE evt_code = '" & eCode & "' And userid='"&userid&"' And convert(varchar(10), regdate, 120) = '"&nowdate&"' "
	rsget.CursorLocation = adUseClient
	rsget.Open vQuery, dbget, adOpenForwardOnly, adLockReadOnly
	IF Not rsget.Eof Then
		UserAppearChk = rsget(0)
	End IF
	rsget.close

%>
<style type="text/css">
.superbad .enter button {width:100%;}
.superbad .enter .enteredLayer {display:none; position:absolute; top:0; left:50%; width:100%; height:100%; margin-left:-50%; background-color:rgba(0,0,0,.5); z-index:10;}
.superbad .enter .enteredLayer div {position:relative; width:90.6%; margin:251.5% auto 0;}
.superbad .enter .enteredLayer .btnClose {width:100%;background-color:transparent;}
.superbad .rolling {background-size:100% auto;}
.superbad .rolling .swiper {position:relative;}
.superbad .rolling .swiper .swiper-container {margin:0 auto;}
.superbad .swiper button {position:absolute; top:26.5%; z-index:20; width:5.9%; background-color:transparent;}
.superbad .swiper .btnPrev {left:2.3%;}
.superbad .swiper .btnNext {right:2.3%;}
.superbad .rolling .swiper .pagination {position:absolute; bottom:8.1%; left:0; z-index:5; width:100%; height:auto; z-index:50; padding-top:0; text-align:center;}
.superbad .rolling .swiper .pagination .swiper-pagination-switch {display:inline-block; width:0.75rem; height:0.75rem; margin:0 0.85rem; border:.5rem solid #fff; background-color:#fff; opacity:0.3; border-radius:50%; cursor:pointer; transition:all 0.5s ease;}
.superbad .rolling .swiper .pagination .swiper-active-switch {opacity:1;}
.superbad .rolling .swiper-slide-video {background:url(http://webimage.10x10.co.kr/eventIMG/2017/78751/m/img_slide_1.jpg) no-repeat 0 0; background-size:100%;}
.superbad .rolling .swiper-slide-video .video {overflow:hidden; position:relative; height:0; padding-bottom:56.09%;}
.superbad .rolling .swiper-slide-video .video iframe {position:absolute; top:0; left:0; width:100%; height:100%; z-index:10;}
</style>

<script>
function goMinionsIns()
{
	<% If IsUserLoginOK() Then %>
		<% If not( left(now(),10)>="2017-07-06" and left(now(),10)<"2017-07-18" ) Then %>
			alert("이벤트 응모 기간이 아닙니다.");
			return false;
		<% else %>
			<% if UserAppearChk > 0 then %>
				alert('이미 응모하셨습니다.\n발표일을 기다려주세요 : )');
				return false;
			<% else %>
				$.ajax({
					type:"GET",
					url:"/event/etc/doEventSubscript78751.asp?mode=ins",
					dataType: "text",
					async:false,
					cache:true,
					success : function(Data, textStatus, jqXHR){
						if (jqXHR.readyState == 4) {
							if (jqXHR.status == 200) {
								if(Data!="") {
									res = Data.split("|");
									if (res[0]=="OK")
									{
										window.parent.$('html,body').animate({scrollTop:$('#tgmi').offset().top+100},0);
										$('.enteredLayer').show();
										return false;
									}
									else
									{
										errorMsg = res[1].replace(">?n", "\n");
										alert(errorMsg);
										return false;
									}
								} else {
									alert("잘못된 접근 입니다.");
									parent.location.reload();
									return false;
								}
							}
						}
					},
					error:function(jqXHR, textStatus, errorThrown){
						alert("잘못된 접근 입니다.");
						<% if false then %>
							//var str;
							//for(var i in jqXHR)
							//{
							//	 if(jqXHR.hasOwnProperty(i))
							//	{
							//		str += jqXHR[i];
							//	}
							//}
							//alert(str);
						<% end if %>
						parent.location.reload();
						return false;
					}
				});
			<% end if %>
		<% end if %>
	<% Else %>
		<% if isApp=1 then %>
			calllogin();
			return false;
		<% else %>
			jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
			return false;
		<% end if %>
	<% End IF %>
}

$(function(){

	mySwiper = new Swiper('#rolling .swiper-container',{
		loop:true,
		autoplay:5000,
		speed:800,
		pagination:"#rolling .pagination",
		paginationClickable:true,
		nextButton:'#rolling .btnNext',
		prevButton:'#rolling .btnPrev',
		effect:'fade'
	});

	$(".enteredLayer").hide();

	$(".enteredLayer .btnClose").click(function(){
		$(".enteredLayer").hide();
	});

});
</script>

<div class="evt78751 superbad">
	<div class="head">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/tit_superbad.jpg" alt="일루미네이션 제작 슈퍼배드 in 텐바이텐 텐바이텐과 영화 <슈퍼배드 3>의 만남! 이벤트에 참여하고, 다양한 상품을 받으세요!" /></h2>
		<%' for dev msg // 앱에서 링크가 새창으로 뜨는지 확인 부탁드려요.%>
		<a href="http://m.10x10.co.kr/culturestation/culturestation_event.asp?evt_code=3998" target="_blank" class="goMovieInfo mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_movie_info.jpg" alt="영화 정보가 궁금해? 보러가기" /></a>
		<a href="" onclick="fnAPPpopupCulture_URL('http://m.10x10.co.kr/culturestation/culturestation_event.asp?evt_code=3998'); return false;" target="_blank" class="goMovieInfo mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_movie_info.jpg" alt="영화 정보가 궁금해? 보러가기" /></a>
	</div>
	<div class="evt1">
		<div class= "txt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_1.jpg" alt="이벤트 하나! 악당으로 변신! 귀여운 미니언들을   Click  해서  다크한 악당으로 변신시켜주세요! 텐바이텐과 영화 <슈퍼배드 3>가 준비한 특별한 선물을 드립니다. 기간은 2017년 7월7일 부터 7월 17일 까지 입니다. 발표일은 2017년 7월 19일" /></div>
		<div class="enter">
			<button class="btnEnter" onclick="goMinionsIns();return false;" id="tgmi"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/btn_click.jpg" alt="Click! * 클릭시 자동 이벤트 응모 (하루에 한 번 참여 가능)" /></button>
			<div class="enteredLayer">
				<%' 7~16일 응모시 %>
				<% If nowdate >= "2017-07-06" And nowdate < "2017-07-17" Then %>
					<div><button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_completed_more.jpg" alt="응모완료! 변신완료! 이벤트에 응모되었습니다! 내일 또 응모하면 당첨 확률 UP!" /></button></div>
				<% End If %>
				<%'  17일 응모시 %>
				<% If nowdate = "2017-07-17" Then %>
					<div><button class="btnClose"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_completed.jpg" alt="응모완료! 변신완료! 이벤트에 응모되었습니다! 19일 당첨 발표를 기대해주세요!" /></button></div>
				<% End If %>				
			</div>
		</div>
		<div class="gift">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/tit_gift.jpg" alt="gift 선물 1 영화 <슈퍼배드 3> 전용 예매권 150명 선물 2 영화 <슈퍼배드 3> 키링 or 마그넷 200명 선물 3  영화 <슈퍼배드 3> 우산 50명" /></div>
		</div>
	</div>
	<div class="evt2">
		<div class="txt"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_2.jpg" alt="이벤트 두울! 배송박스 속 미니언을 찰칵! 추첨을 통해 30분께 기프트카드 1만원 권을 드립니다.   * '미니언 리플렛'은 텐바이텐 배송상품과 함께 배송되며 소진시 포함되지 않습니다." /> </div>
		<div class="conts">
			<ul>
				<li>
					<%' for dev msg // 앱에서 링크가 새창으로 뜨는지 확인 부탁드려요. %>
					<a href="/event/eventmain.asp?eventid=79056" target="_blank" alt="텐바이텐 쇼핑하러 가기" class="mWeb"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_2_1.jpg" alt="1. 텐바이텐 배송 상품 쇼핑하기 2. 배송박스 속 ‘미니언’ 인증샷 찍기 " /></a>
					<a href="/apps/appCom/wish/web2014/event/eventmain.asp?eventid=79056" onclick="onclick=ʺfnAPPpopupEvent('79056'); return false;" target="_blank" alt="텐바이텐 쇼핑하러 가기" class="mApp"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_2_1.jpg" alt="1. 텐바이텐 배송 상품 쇼핑하기 2. 배송박스 속 ‘미니언’ 인증샷 찍기 " /></a>
				</li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_2_2.jpg" alt="2. 배송박스 속 ‘미니언’ 인증샷 찍기"/></li>
				<li><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/txt_evt_2_3.jpg" alt="3. 인스타그램 업로드 필수 포함 해시태그 #텐바이텐 #슈퍼배드3"/></li>
			</ul>
		</div>
	</div>
	<div id="rolling" class="rolling">
		<h3><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/tit_movie.jpg" alt="영화 <슈퍼배드 3> 7월 26일 대개봉!" /></h3>
		<div class="swiper">
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide swiper-slide-video">
						<div class="video">
							<iframe width="560" height="315" src="https://www.youtube.com/embed/ekrJQ158oug" title="슈퍼배드3 예고편" frameborder="0" allowfullscreen=""></iframe>
						</div>
					</div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/img_slide_2.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/img_slide_3.jpg" alt="" /></div>
					<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/img_slide_4.jpg" alt="" /></div>
				</div>
			</div>
			<button type="button" class="btnPrev"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/btn_prev.png" alt="이전" /></button>
			<button type="button" class="btnNext"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78751/m/btn_next.png" alt="다음" /></button>

			<div class="pagination"></div>
		</div>
	</div>
</div>
<!-- #include virtual="/lib/db/dbclose.asp" -->