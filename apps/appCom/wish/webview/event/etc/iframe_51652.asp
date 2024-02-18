<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  더블마일리지 상품후기를 써야 쇼핑의 완성 
' History : 2014.05.02 원승현 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/apps/appcom/wish/webview/event/etc/event51404Cls.asp" -->

<%

Dim eCode
IF application("Svr_Info") = "Dev" THEN
	eCode   =  21163
Else
	eCode   =  51693
End If

Dim sqlStr, mCnt, mCash
If Not(GetLoginUserID()="" or isNull(GetLoginUserID())) Then
	mCnt = 0
	mCash = 0
	sqlStr = " SELECT DISTINCT "&_
			" i.itemid , i.sellcash , i.itemname , i.brandname "&_
			" , i.listimage120, i.listimage, i.icon2image, d.oitemdiv as itemdiv, i.evalcnt,  "&_
			"  d.itemoption "&_
			" , m.orderserial ,m.regdate, i.itemscore  "&_
			" FROM  "&_
			" [db_order].[dbo].tbl_Order_Master m  "&_
			" JOIN [db_order].[dbo].tbl_Order_Detail d  "&_
			" on 1 = 1 and m.userid = '"&GetLoginUserID&"' and m.OrderSerial= d.OrderSerial and m.sitename = '10x10' and m.ipkumdiv>=7  "&_ 
			" and m.cancelyn = 'N' and m.jumundiv <> 9 and m.jumundiv <> 6 and d.cancelyn <> 'Y' and d.itemid <> 0  "&_
			" and IsNull(m.userDisplayYn, 'Y') = 'Y'  "&_
			" JOIN [db_item].[dbo].tbl_Item i on d.itemid = i.itemid  "&_
			" LEFT JOIN db_board.[dbo].tbl_Item_Evaluate e  "&_
			" on 1 = 1 and e.UserID = '"&GetLoginUserID&"' and m.OrderSerial = e.OrderSerial and d.Itemid = e.itemid  "&_
			" and d.ItemOption = e.ItemOption  "&_
			" WHERE e.idx is null  "
	'response.write sqlstr
	rsget.Open sqlStr,dbget,1
	if Not(rsget.EOF or rsget.BOF) Then
		Do Until rsget.eof
			mCnt = mCnt + 1
			If rsget("evalcnt")=0 Then
				mCash = mCash + 400
			Else
				mCash = mCash + 200
			End If
		rsget.movenext
		Loop
	End If
	rsget.Close
End If
'response.write GetLoginUserID()&"고객님, "&mCnt&"개의 상품후기를 남기실 수 있습니다.<BR>이벤트 기간 동안 예상 마일리지 적립금은 "&FormatNumber(mCash, 0)&"원 입니다."

%>
<!doctype html>
<html lang="ko">
<title>생활감성채널, 텐바이텐 > 이벤트 > 상품후기를 써야 쇼핑의 완성</title>
<!-- #include virtual="/apps/appCom/wish/webview/lib/head.asp" -->
<style type="text/css">
.mEvt51651 {position:relative;}
.mEvt51651 p {max-width:100%;}
.mEvt51651 img {vertical-align:top; width:100%;}
.mEvt51651 .myLoginCont {text-align:center; padding:30px 0 27px; background:#7a7979;}
.mEvt51651 .myLoginCont .before {overflow:hidden; padding:0 18px;}
.mEvt51651 .myLoginCont .before p {float:left; width:50%; padding:0 12px; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.mEvt51651 .myLoginCont .viewMileage {display:block; width:80%; margin:0 auto; cursor:pointer;}
.mEvt51651 .myLoginCont .after {display:none; font-size:13px; line-height:22px; color:#fff;}
.mEvt51651 .myLoginCont .after .goReview {display:block; width:85%; margin:22px auto 0;}
.mEvt51651 .myLoginCont .after strong {font-size:17px;}
.mEvt51651 .myLoginCont .after .user {border-bottom:1px solid #fff;}
.mEvt51651 .myLoginCont .after .num {color:#ff9ba0; border-bottom:1px solid #ff9ba0;}
.mEvt51651 .myLoginCont .after .mileage {color:#78e8ec; border-bottom:1px solid #78e8ec;}
.mEvt51651 .bestProduct {padding-bottom:25px; background:#f5f5f5;}
.mEvt51651 .bestProduct ul {overflow:hidden;}
.mEvt51651 .bestProduct ul li {float:left; width:50%;}
</style>
<script type="text/javascript">
$(function(){
	$('.viewMileage').click(function(){
		$(this).hide();
		$(this).next('.after').show();
	});
});
</script>

</head>
<body>
			<div class="content" id="contentArea">
				<div class="mEvt51651">
					<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/review_head.png" alt="상품후기를 써야 쇼핑의 완성" /></h2>
					<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/review_mileage.png" alt="상품후기를 쓰시면 마일리지 두배" /></p>
					<div class="myLoginCont">
					<% If Trim(GetLoginUserID())="" Or Len(Trim(GetLoginUserID()))=0 Then %>
						<div class="before">
							<p><a href="#" onclick="calllogin();"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/btn_login.png" alt="로그인" /></a></p>
							<p><a href="/apps/appCom/wish/webview/member/join.asp"  target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/btn_join.png" alt="회원가입" /></a></p>
						</div>
					<% Else %>
						<span class="viewMileage"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/btn_my_mileage.png" alt="나의 적립 예상 마일리지 보기" /></span>
						<div class="after">
							<p>
								<strong class="user"><%=GetLoginUserID()%></strong> 고객님,<br />
								<strong class="num"><%=FormatNumber(mCnt, 0)%></strong>개의 상품후기를 남기실 수 있습니다.<br />
								이벤트 기간 동안 예상 마일리지 적립금은<br />
								<strong class="mileage"><%=FormatNumber(mCash, 0)%></strong> 원입니다.
							</p>
							<span class="goReview">
							<% If getnowdate>="2014-05-06" and getnowdate<="2014-05-12" Then %>
								<a href="/apps/appCom/wish/webview/my10x10/goodsusing.asp"  target="_parent">
							<% Else %>
								<a href="#" onclick="alert('이벤트 응모기간이 아닙니다.');" >
							<% End If %>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/btn_go_review.png" alt="상품후기쓰고 더블 마일리지 받기" /></a>
							</span>
						</div>
					<% End If %>
					</div>
					<div class="bestProduct">
						<p class="tit"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/tit_best_review.png" alt="이 정도 상품후기는 받아야 BEST 상품의 품격" /></p>
						<ul>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=917051" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product01.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=366938" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product02.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=819836" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product03.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=949903" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product04.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=846181" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product05.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=244430" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product06.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=393392" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product07.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=611469" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product08.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=556050" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product09.png" alt="" /></a></li>
							<li><a href="/apps/appCom/wish/webview/category/category_itemprd.asp?itemid=572962" target="_parent"><img src="http://webimage.10x10.co.kr/eventIMG/2014/51651/img_product10.png" alt="" /></a></li>
						</ul>
					</div>
				</div>
				<!-- //상품후기를 써야 쇼핑의 완성 -->
			</div>
</body>
</html>

<!-- #include virtual="/lib/db/dbclose.asp" -->