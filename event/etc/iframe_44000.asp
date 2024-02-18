<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/classes/event/eventCls.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #INCLUDE Virtual="/lib/util/pageformlib.asp" -->
<%
Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  20929
Else
	eCode   =  44000
End If

dim com_egCode, bidx
	Dim iCTotCnt, arrCList
	Dim timeTern, totComCnt

	com_egCode = requestCheckVar(Request("eGC"),1)	'그룹 번호(엣지1, 초식2, 연하3)

%>

<head>
	<!-- #include virtual="/lib/inc/head.asp" -->
	<title>생활감성채널, 텐바이텐 > 이벤트 > 우리집에 어서와!</title>
	<style type="text/css">
		.mEvt44000 img {vertical-align:top;}
		.mEvt44000 .hwGift {padding-bottom:10px; background:url('http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_bg01.png') left top repeat-y; background-size:100% auto;}
		.mEvt44000 .hwGift ul {overflow:hidden; }
		.mEvt44000 .hwGift li {float:left; width:50%; padding-bottom:15px; text-align:center;}
		.mEvt44000 .hwGift .eatBtn {text-align:center;}
		.mEvt44000 .goMevt {position:relative;}
		.mEvt44000 .goMevt .btn {position:absolute; width:51%; left:44%; top:45%;}
		.mEvt44000 .goTalk {position:relative;}
		.mEvt44000 .goTalk .btn {position:absolute; width:50%; left:11%; top:71%;}
	</style>
<script type="text/javascript">
	function jsSubmitComment(frm){
	<% if datediff("d",date(),"2013-07-29")>=0 then %>
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	 if(!(frm.spoint[0].checked||frm.spoint[1].checked||frm.spoint[2].checked||frm.spoint[3].checked)){
	    alert("응모하실 선물을 선택해주세요.");
	    return false;
	   }

	   frm.action = "/event/etc/doEventSubscript44000.asp";
	   return true;

	<% else %>
			alert('이벤트가 종료되었습니다.11');
			return;
	<% end if %>
	}
</script>
</head>

			<!-- content area -->

				<div class="mEvt44000">
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_head.png" alt="" style="width:100%;" /></p>		<% response.write datediff("d",date(),"2013-07-29") %>

					<div class="hwGift">
					<form name="frmcom" method="post" onSubmit="return jsSubmitComment(this);" style="margin:0px;">
					<input type="hidden" name="eventid" value="<%=eCode%>">
					<input type="hidden" name="bidx" value="<%=bidx%>">
					<input type="hidden" name="iCTot" value="">
					<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
						<ul>
							<li>
								<input type="radio" name="spoint" value="1" id="gift1" />
								<label for="gift1"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_gift01.png" alt="럭키7세트" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="2" id="gift2" />
								<label for="gift2"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_gift02.png" alt="100% 파파사과즙" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="3" id="gift3" />
								<label for="gift3"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_gift03.png" alt="대박 주전부리 세트" style="width:100%;" /></label>
							</li>
							<li>
								<input type="radio" name="spoint" value="4" id="gift4" />
								<label for="gift4"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_gift04.png" alt="자유부인 3개들이 선물세트" style="width:100%;" /></label>
							</li>
						</ul>
						<p class="eatBtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_btn01.png" alt="잡숴봐 응모하기" style="width:64%;" /></p>
					</form>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_img01.png" alt="지금 가면 섭섭해요! 우리집에서 조금 더 놀다가요~" style="width:100%;" /></p>
					<div class="goMevt">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_img02.png" alt="조금 더 빠르고 알차게! 즐겨운 쇼핑을 위한 텐바이텐 알뜰정보가 한 눈에!" style="width:100%;" />
						<p class="btn"><a href="/shoppingtoday/shoppingchance_allevent.asp" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_btn02.png" alt="모바일 이벤트 바로가기" style="width:100%;" /></a></p>
					</div>
					<div class="goTalk">
						<img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_img03.png" alt="상품에 대한 색다른 토크 텐바이텐 쇼핑 톡! 상황에 따른 상품에 대한 조언이 필요하다면!" style="width:100%;" />
						<p class="btn"><a href="/shoppingtalk/" target="_top"><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_btn03.png" alt="쇼핑 톡! 바로가기" style="width:87%;" /></a></p>
					</div>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/44000/44000_img04.png" alt="이벤트 안내" style="width:100%;" /></p>
				</div>
			<!-- //content area -->

<!-- #include virtual="/lib/db/dbclose.asp" -->