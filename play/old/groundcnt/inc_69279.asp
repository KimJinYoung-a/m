<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description : PLAY 27 ����� ���, ��⸦ ���.M
' History : 2016.02.17 ���¿� ����
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
	eCode   =  66033
Else
	eCode   =  69279
End If

dim userid, i, vreload
	userid = getloginuserid()
	vreload	= requestCheckVar(Request("reload"),2)

dim cEComment ,blnFull, cdl, com_egCode, bidx, blnBlogURL, strBlogURL
dim iCTotCnt, arrCList,intCLoop
dim iCPageSize, iCCurrpage, isMyComm
dim iCStartPage, iCEndPage, iCTotalPage, iCx,iCPerCnt, sqlstr
	iCCurrpage	= requestCheckVar(Request("iCC"),10)	'���� ������ ��ȣ

IF iCCurrpage = "" THEN
	iCCurrpage = 1
END IF
IF iCTotCnt = "" THEN
	iCTotCnt = -1
END IF

iCPerCnt = 4		'�������� ������ ����
'�� �������� �������� ���� ��
if blnFull then
	iCPageSize = 6	'Ǯ���̸� 15��			'/�����̺�Ʈ �Ѵ� ���� 12����
else
	iCPageSize = 6	'�޴��� ������ 10��			'/�����̺�Ʈ �Ѵ� ���� 12����
end if

'// sns������ �� ī���� ������
sqlstr = "select count(*) "
sqlstr = sqlstr & " from [db_Appwish].[dbo].[tbl_snsSelectData]"
sqlstr = sqlstr & " Where evt_code="& eCode &""

'response.write sqlstr & "<br>"
rsCTget.Open sqlstr, dbCTget, adOpenForwardOnly, adLockReadOnly
	iCTotCnt = rsCTget(0)
rsCTget.close

iCTotalPage 	=  Int(iCTotCnt/iCPageSize)	'��ü ������ ��
IF (iCTotCnt MOD iCPageSize) > 0 THEN	iCTotalPage = iCTotalPage + 1
%>
<!-- #include virtual="/lib/inc/head.asp" -->

<style type="text/css">
html {font-size:11px;}
@media (max-width:320px) {html{font-size:10px;}}
@media (min-width:414px) and (max-width:479px) {html{font-size:12px;}}
@media (min-width:480px) and (max-width:749px) {html{font-size:16px;}}
@media (min-width:750px) {html{font-size:16px;}}

img {vertical-align:top;}

.app {display:none;}
.hidden {visibility:hidden; width:0; height:0;}

.topic {position:relative;}
.topic h2 {position:absolute; top:11%; left:50%; width:75.625%; margin-left:-37.8125%;}
.topic h2 img {transform:scale(0.8); transition:1.5s ease-in-out; -webkit-transform:scale(0.8); -wekit-transition:1.5s ease-in-out;}
.topic h2.scale img {transform:scale(1); -webkit-transform:scale(1);}

.topic .btnevent {position:absolute; bottom:12.5%; left:12.5%; width:31.25%;}

.scent {position:relative;}
.item li {position:absolute; width:50%; height:13%;}
.item li.item01 {top:56%; right:0;}
.item li.item02 {top:68%; left:0;}
.item li a {display:block; width:100%; height:100%; font-size:12px; color:transparent; text-align:center; background-color:black; opacity:0; filter:alpha(opacity=0);}
.scent .btnSkip {position:absolute; left:3.125%; bottom:4%; width:18.75%;}

.scent01 .item li.item01 {top:60%;}
.scent01 .item li.item02 {top:74%;}
.scent02 .item li.item01 {top:59%;}
.scent03 .item li.item01 {top:59%;}
.scent03 .item li.item02 {top:70%;}
.scent04 .item li.item01 {top:62%;}
.scent04 .item li.item02 {top:80%;}

.rolling {position:relative;}
.rolling h3 {position:absolute; bottom:10%; left:0; z-index:10; width:100%;}
.rolling .swiper {position:relative;}
.rolling .swiper .swiper-container {width:100%;}
.rolling .swiper button {position:absolute; top:42%; z-index:10; width:4.84%; background:transparent;}
.rolling .swiper .btn-prev {left:14.375%;}
.rolling .swiper .btn-next {right:14.375%;}

.instagram {padding-bottom:12%; background-color:#f8f0eb;}
.instagramList {overflow:hidden; margin-top:6.5%; padding:0 4%;}
.instagramList li {float:left; width:50%;}
.instagramList li a {display:block; margin:0 5% 12%; padding:7%; background-color:#fff; box-shadow:0px 0px 6px -1px rgba(000,000,000,0.15);}
.instagramList li .article {overflow:hidden; height:5rem; display: -webkit-box; text-overflow:ellipsis; -webkit-line-clamp:2; -webkit-box-orient:vertical; word-wrap:break-word; color:#404040; font-size:1.1rem;}
.instagramList li .article p {line-height:1.375em;}
.instagramList li .id {display:block; margin:5% 0 1%; color:#396991; font-weight:bold; font-size:1.2rem;}

.paging span {border-color:#afb1b1;}
.paging span.arrow {border-color:#afb1b1; background-color:#afb1b1;}
.paging span.current {background-color:transparent;}
</style>
<script type="text/javascript">
function jsGoComPage(iP){
	document.frmcom.iCC.value = iP;
	document.frmcom.iCTot.value = "<%=iCTotCnt%>";
	document.frmcom.submit();
}
</script>
<div class="mPlay20160222">
	<article>
		<div id="animation" class="topic">
			<h2><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_memory_v1.png" alt="" /></h2>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_memory_v1.jpg" alt="���� �ȴٰ� ������ ���� ��⿡ ���ƺ� ���� �ܶ� ������� �� ������ �°� �ϴ��� �÷��� �� ��ħ ��� �� ����� ������ �ð� ���� ������ ���� ���� �츮�� �𸣰� ����� ��� �˴ϴ�. ����� ���� ���, �� ���� ������ �ٹ������� �����մϴ�." /></p>
			<a href="#instagram" id="btnevent" class="btnevent"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_event.png" alt="�̺�Ʈ �����ϱ�" /></a>
		</div>

		<div id="scent01" class="scent scent01">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_01_v1.jpg" alt="���� �ּ� ������ ������ ���" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1235472&amp;pEtr=69279">Precious Baby � ���� �������� �ȱ�� �����ϰ� ������ ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189621&amp;pEtr=69279">Laundromat ������ �� ��ٸ��� �����ϰ� Ǫ���� ���� ���</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=1235472&amp;pEtr=69279" onclick="fnAPPpopupProduct('1235472&amp;pEtr=69279');return false;">Precious Baby � ���� �������� �ȱ�� �����ϰ� ������ ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189621&amp;pEtr=69279" onclick="fnAPPpopupProduct('189621&amp;pEtr=69279');return false;">Laundromat ������ �� ��ٸ��� �����ϰ� Ǫ���� ���� ���</a></li>
			</ul>
			<a href="#scent02" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent02" class="scent scent02">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_02_v2.jpg" alt="�α� �α� ���� ������ ����� ���" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=247001&amp;pEtr=69279">Juicy shampoo ������ ����� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=741201&amp;pEtr=69279">Fuzzy Navel ������ ���� �����ߴ� ù����� ���</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=247001&amp;pEtr=69279" onclick="fnAPPpopupProduct('247001&amp;pEtr=69279');return false;">Juicy shampoo ������ ����� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=741201&amp;pEtr=69279" onclick="fnAPPpopupProduct('741201&amp;pEtr=69279');return false;">Fuzzy Navel ������ ���� �����ߴ� ù����� ���</a></li>
			</ul>
			<a href="#scent03" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent03" class="scent scent03">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_03_v1.jpg" alt="�� ���� �� ���� �ܿ� �ٴ� ���" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=922838&amp;pEtr=69279">Ocean breeze �ÿ��� �ٴ��� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279">Snow �� ���� ���� ���</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=922838&amp;pEtr=69279" onclick="fnAPPpopupProduct('922838&amp;pEtr=69279');return false;">Ocean breeze �ÿ��� �ٴ��� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279" onclick="fnAPPpopupProduct('189630&amp;pEtr=69279');return false;">Snow �� ���� ���� ���</a></li>
			</ul>
			<a href="#scent04" class="btnSkip"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_skip.png" alt="NEXT" /></a>
		</div>
		<div id="scent04" class="scent scent04">
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_scent_04_v1.jpg" alt="��ħ ��å�濡 ���� �ĸ��ĸ� ���" /></p>
			<ul class="item mo">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=436141&amp;pEtr=69279">Wet garden ���� �� ��å �濡 ���� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=189630&amp;pEtr=69279">aisy �޻� ���� ǰ�� �ʷ� �ܵ���� ���</a></li>
			</ul>
			<ul class="item app">
				<li class="item01"><a href="/category/category_itemPrd.asp?itemid=436141&amp;pEtr=69279" onclick="fnAPPpopupProduct('436141&amp;pEtr=69279');return false;">Wet garden ���� �� ��å �濡 ���� ���</a></li>
				<li class="item02"><a href="/category/category_itemPrd.asp?itemid=672041&amp;pEtr=69279" onclick="fnAPPpopupProduct('672041&amp;pEtr=69279');return false;">aisy �޻� ���� ǰ�� �ʷ� �ܵ���� ���</a></li>
			</ul>
		</div>

		<div class="collabo">
			<p class="mo"><a href="/street/street_brand.asp?makerid=demeter" title="�����׸� �귣�� �ٷΰ���"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_collabo_v1.png" alt="�ٹ����� �÷��� 27��° ���� Scent�� ��� �� ��� �ȳ��� �����׸��� ������� ���ӿ� �ִ� �߾��� ���� ����� ������Ʈ�� �õ��߽��ϴ�." /></a></p>
			<p class="app"><a href="" onclick="fnAPPpopupBrand('demeter'); return false;" title="�����׸� �귣�� �ٷΰ���"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_collabo_v1.png" alt="�ٹ����� �÷��� 27��° ���� Scent�� ��� �� ��� �ȳ��� �����׸��� ������� ���ӿ� �ִ� �߾��� ���� ����� ������Ʈ�� �õ��߽��ϴ�." /></a></p>
		</div>

		<section class="rolling">
			<h3><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_like_v1.png" alt="����� �����ϰ� ���� ����� ����ּ��� �����Ͻ� �������� ������� �󺧷� ����� �帳�ϴ�." /></h3>
			<div class="swiper">
				<div class="swiper-container swiper1">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_04.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_05.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_06.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_07.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/img_slide_08.jpg" alt="" /></div>
					</div>
				</div>
				<button type="button" class="btn-prev"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_prev.png" alt="����" /></button>
				<button type="button" class="btn-next"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/btn_next.png" alt="����" /></button>
			</div>
		</section>

		<section class="event">
			<h3 class="hidden">������ ��� ����� �̺�Ʈ ���� ���</h3>
			<p><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_event_v2.png" alt="�����Ͻ� �е� �� ��÷�� ���� 20�п��� ������ ����� ���� ��⸦ ���� �� �ִ� �����׸� ��� ����� ü����� �帳�ϴ� ����Ⱓ�� 2016�� 2�� 22�Ϻ��� 3�� 6�ϱ����� ��÷�� ��ǥ�� 2016�� 3�� 8���Դϴ�. ����� ����� ���� ����� ������ �ν�Ÿ�׷��� #�ٹ�������� �ؽ��±׿� �Բ� ���ε� ���ּ���! ������ �Բ� ª�� �翬�� �� �����ּ���." /></p>
			<h4><a href="#more"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_way.png" alt="�����׸� ��Ǿ ��Ʃ��� �̿� ��� �� �ڼ��� ����" /></a></h4>
			<p id="more"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_way_v2.png" alt="�̺�Ʈ ��÷�� �Ǹ� ��������� Ƽ���� ��۵˴ϴ�. ��������� Ƽ���� ������ û�㿡 ��ġ�� �����׸� ������ �湮�մϴ�. ���� ��Ÿ�ϰ� ����� ��� ��Ʈ���� �ۼ��մϴ�. ������ �Բ� ������ ����� ���� ��⸦ ����� ����� �����ϼ���!" /></p>
			<p><a href="https://www.instagram.com/your10x10/" target="_blank" title="�ٹ����� �ν�Ÿ�׷� ���� ��â"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/txt_note.png" alt="�ٹ����� �ν�Ÿ�׷� ���� @your10x10�� �ȷο��ϸ� ��÷Ȯ���� UP! �ν�Ÿ�׷� ������ ������� ��� ���谡 ���� �ʽ��ϴ�. #�ٹ�������� �ؽ��±׸� ���� ������ �̺�Ʈ ������ �ǹ��ϸ�, �÷��� �������� �ڵ� ����� �� �ֽ��ϴ�." /></a></p>
		</section>


		<section id="instagram" class="instagram">
			<h3 id="instagramevent"><a href="https://www.instagram.com/your10x10/" target="_blank" title="�ٹ����� �ν�Ÿ�׷� ���� ��â"><img src="http://webimage.10x10.co.kr/playmo/ground/20160222/tit_instagram_v1.png" alt="����� ���� ������" /></a></h3>
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
			<ul class="instagramList">
				<%
				Do Until rsCTget.eof
				%>
				<% '6�� �Ѹ��� %>
				<li>
					<% If IsApp="1" Then %>
						<a href="" onclick="openbrowser('<%=rsCTget("link")%>'); return false;" target="_blank">
					<% Else %>
						<a href="<%=rsCTget("link")%>"  target="_blank">
					<% End If %>
						<div class="figure"><img src="<%=rsCTget("img_stand")%>" onerror="this.src='http://webimage.10x10.co.kr/playmo/ground/20160222/img_not_found.jpg'" alt="" /></div>
						<div class="article"><span class="id"><%= printUserId(rsCTget("snsusername"),2,"*") %></span> <p><%=chrbyte(stripHTML(rsCTget("text")),27,"Y")%></p></div>
					</a>
				</li>
				<%
				rsCTget.movenext
				Loop
				%>
			</ul>
			<%
			End If
			rsCTget.close
			%>
			<%=fnDisplayPaging_New(iCCurrpage,iCTotCnt,iCPageSize,4,"jsGoComPage")%>
		</section>
	</article>
<form name="frmcom" method="post" onSubmit="return false;" style="margin:0px;">
<input type="hidden" name="iCC" value="1">
<input type="hidden" name="reload" value="ON">
<input type="hidden" name="iCTot" value="<%= iCTotCnt %>">
</form>
</div>
<script type="text/javascript">
$(function(){
	/* skip to contents */
	$("#btnevent").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	$(".scent .btnSkip").click(function(event){
		event.preventDefault();
		window.parent.$('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
	});

	$(".event #more").hide();
	$(".event h4 a").click(function(event){
		$(".event #more").slideDown();
		return false;
	});

	var chkapp = navigator.userAgent.match('tenapp');
	if ( chkapp ){
			$(".mPlay20160222 .app").show();
			$(".mPlay20160222 .mo").hide();
	}else{
			$(".mPlay20160222 .app").hide();
			$(".mPlay20160222 .mo").show();
	}

	/* animation */
	function animation() {
		$("#animation h2").addClass("scale");
	}
	animation();

	/* swipe js */
	mySwiper1 = new Swiper('.swiper1',{
		loop:true,
		resizeReInit:true,
		calculateHeight:true,
		autoplay:2500,
		speed:800,
		autoplayDisableOnInteraction:false,
		nextButton:'.rolling .btn-next',
		prevButton:'.rolling .btn-prev',
		effect:"fade"
	});

	<% if vreload<>"" then %>
		$('html,body').animate({scrollTop: $("#instagramevent").offset().top},0);
	<% end if %>

});
</script>
<!-- #include virtual="/lib/db/dbclose.asp" -->
<!-- #include virtual="/lib/db/dbCTclose.asp" -->