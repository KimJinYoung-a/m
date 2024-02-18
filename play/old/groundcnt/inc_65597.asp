<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : 텐바이텐여름 인스타그램
' History : 2015.08.14 한용민 생성
'####################################################
%>
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbCTopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->

<%
Dim eCode, eCodedisp
IF application("Svr_Info") = "Dev" THEN
	eCode   =  64853
	eCodedisp = 64853
Else
	eCode   =  65597
	eCodedisp = 65597
End If

dim userid, i, vreload
	userid = getloginuserid()
	vreload	= requestCheckVar(Request("reload"),2)

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, sqlstr
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'현재 페이지 번호

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'보여지는 페이지 간격
'한 페이지의 보여지는 열의 수
if blnFull then
	iCPageSize = 6	'풀단이면 15개			'/수기이벤트 둘다 강제 12고정
else
	iCPageSize = 6	'메뉴가 있으면 10개			'/수기이벤트 둘다 강제 12고정
end if

'// sns데이터 총 카운팅 가져옴
sqlstr = "select count(*) "
sqlstr = sqlstr & " from [db_Appwish].[dbo].[tbl_snsSelectData]"
sqlstr = sqlstr & " Where evt_code="& eCode &""

'response.write sqlstr & "<br>"
rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
	iCTotCnt = rsCTget(0)
rsCTget.close

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'전체 페이지 수
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
img {vertical-align:top;}
.yourSummer {padding:40px 0 35px; background:url(http://webimage.10x10.co.kr/playmo/ground/20150817/bg_noise.gif) 0 0 repeat-y; background-size:100% auto;}
.yourSummer ul {overflow:hidden; padding:10px 6%;}
.yourSummer li {float:left; width:50%; padding:0 2.4% 23px;}
.yourSummer li .pic {overflow:hidden; padding:5px; background:#fff; border-radius:3px; box-shadow:1px 1px 2px 1px rgba(0,0,0,.07);}
.yourSummer li p {text-align:right; color:#999; font-size:12px; line-height:1.1; padding:10px 5px 0 0; font-weight:bold;}
.yourSummer li p em {color:#6e9ba3; padding-right:3px;}
.swiper .numbering {position:absolute; left:0; bottom:7%; z-index:10; width:100%; text-align:center;}
.swiper .numbering span {display:inline-block; width:8px; height:8px; margin:0 4px; border:2px solid rgba(255,255,255,.4); border-radius:50%; background-color:transparent;}
.swiper .numbering span.swiper-active-switch {border:0; background:rgba(255,255,255,.5);}
.swiper button {position:absolute; bottom:6.5%; width:12px; z-index:30; background:transparent;}
.swiper .prev {left:36%;}
.swiper .next {right:36%;}
@media all and (min-width:480px){
	.yourSummer {padding:60px 0 53px;}
	.yourSummer ul {padding:15px 6%;}
	.yourSummer li {padding:0 2.4% 35px;}
	.yourSummer li .pic {padding:7px; border-radius:4px;}
	.yourSummer li p {font-size:17px; padding:15px 7px 0 0;}
	.swiper .numbering span {width:13px; height:13px; margin:0 6px; border:3px solid rgba(255,255,255,.4);}
	.swiper button {width:18px;}
}
</style>
<script type="text/javascript">
$(function(){
	mySwiper = new Swiper('.swiper',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:3000,
		speed:800,
		pagination:".numbering",
		paginationClickable:true,
		autoplayDisableOnInteraction:false,
		nextButton:'.next',
		prevButton:'.prev'
	});
	$('.prev').on('click', function(e){
		e.preventDefault()
		mySwiper.swipePrev()
	});
	$('.next').on('click', function(e){
		e.preventDefault()
		mySwiper.swipeNext()
	});

	$(".shareBtn").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top}, 800);
	});
	
	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#instagram").offset().top},'slow');
	<% end if %>
});

function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}

</script>
</head>
<body>

<!-- SUMMER #2 -->
<div class="mPlay20150817">
	<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/tit_summer.jpg" alt="그해 여름" /></h2>
	<p><a href="#packageInfo" class="shareBtn"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_purpose.gif" alt="여김없이 돌아온 무더위를 보내며, 문득 여러분의 여름이 궁금해졌습니다. 휴가를 떠나 시원하게 보내고 계신가요? 혹은 떠나지 않더라도 나만의 특별한 여름을 즐기고 계신가요? 텐바이텐이 선물한 그해 여름 패키지를 통해 여러분의 기억 속 올해 여름을 간직하고, 설레는 마음으로 내년에 다시 돌아올 여름을 기대해보세요." /></a></p>
	<div class="yourSummer">
		<% '<!-- 인스타그램 이미지 불러오기 --> %>
		<div class="instagram" id="instagram">
			<%
			sqlstr = "Select * From "
			sqlstr = sqlstr & " ( "
			sqlstr = sqlstr & " 	Select row_Number() over (order by idx desc) as rownum, snsid, link, img_low, img_thum, img_stand, text, snsuserid, snsusername, regdate "
			sqlstr = sqlstr & " 	From db_AppWish.dbo.tbl_snsSelectData "
			sqlstr = sqlstr & " 	Where evt_code="& eCode &""
			sqlstr = sqlstr & " ) as T "
			sqlstr = sqlstr & " Where RowNum between "&(iCCurrpage*iCPageSize)-5&" And "&iCCurrpage*iCPageSize&" "
			
			'response.write sqlstr & "<br>"
			rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
			If Not(rsCTget.bof Or rsCTget.eof) Then
			%>
			<ul>
				<%
				Do Until rsCTget.eof
				%>
				<% '8개 뿌리기 %>
				<li>
					<div class="pic">
						<% If IsApp="1" Then %>
							<a href="" onclick="openbrowser('<%=rsCTget("link")%>'); return false;" target="_blank">
						<% Else %>
							<a href="<%=rsCTget("link")%>"  target="_blank">
						<% End If %>
						<img src="<%=rsCTget("img_stand")%>" alt=""></a>
					</div>
					<p><em><%= printUserId(rsCTget("snsusername"),2,"*") %></em>님의 여름</p>
				</li>
				<%
				rsCTget.movenext
				Loop
				%>
			</ul>
			<div class="paging">
				<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
			</div>
			<%
			End If
			rsCTget.close
			%>
		</div>
		<% '<!--// 인스타그램 이미지 불러오기 --> %>
	</div>
	<div class="applyEvent">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/tit_apply.gif" alt="그해 여름 이벤트 참여방법" /></h3>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_apply.gif" alt="1. 기억으로 남기고픈 여름 사진을 촬영하거나 선택합니다./2. 인스타그램에 #텐바이텐여름 해시태그와 함께 업로드합니다." /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_event_gift.gif" alt="추첨을 통해 3분에게 그해 여름 PACKAGE를 선물로 드립니다! 이벤트기간:2015년 8월17일~8월 31일/당첨자발표:2015년 9월 1일" /></p>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_apply_notice.gif" alt="NOTICE:계정이 비공개인 경우, 집계가 되지 않습니다./이벤트 기간 동안 '#텐바이텐여름' 해시태그로 업로드 한 사진은 이벤트 참여를 의미하며, 텐바이텐 플레이 페이지 노출에 동의하는 것으로 간주합니다." /></p>
	</div>
	<div class="packageInfo" id="packageInfo">
		<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/tit_package.gif" alt="그해 여름 PACKAGE - 그해 여름 패키지에는 사진인화 상품권, 액자 10개 세트, 인화 사진 1장이 포함되어 있습니다." /></h3>
		<ol>
			<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_package01.jpg" alt="1. 액자 10개 세트:액자 사이즈는 상이합니다." /></li>
			<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_package02.jpg" alt="2. 사진 인화 상품권:나머지 액자에도 여름 사진을 담아둘 수 있도록 사진 인화 상품권을 드립니다." /></li>
			<li><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_package03.jpg" alt="3. 당첨된 사진 인화 1매:당첨된신 고객님의 사진을 인화해드립니다.(8X10인치 사이즈 1장)" /></li>
		</ol>
		<p><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/txt_package_notice.gif" alt="NOTICE:인화를 위한 사진의 최소 해상도는 1280x960 pixel 이상입니다./당첨되신 고객님께는 업로드 하신 사진의 원본 사진을 요청합니다./원본의 화질과 프린트 환경에 따라 색감 변화나 노이즈가 있을 수 있습니다./상품권은 온라인 사진인화기업인 찍스(zzixx.com)의 인화 상품권입니다." /></p>
	</div>
	<div class="swiper-container swiper">
		<div class="swiper-wrapper">
			<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/img_slide01.jpg" alt="" /></div>
			<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/img_slide02.jpg" alt="" /></div>
			<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/img_slide03.jpg" alt="" /></div>
			<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/img_slide04.jpg" alt="" /></div>
		</div>
		<div class="numbering"></div>
		<button type="button" class="prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/btn_prev.png" alt="이전" /></button>
		<button type="button" class="next"><img src="http://webimage.10x10.co.kr/playmo/ground/20150817/btn_next.png" alt="다음" /></button>
	</div>
</div>
<!-- //SUMMER #2 -->
<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="1">
<input type="hidden" name="reload" value="ON">
<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
</form>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbCTclose.asp" -->