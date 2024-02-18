<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/login/checklogin.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->

<%
	Dim eCode, Vol
	IF application("Svr_Info") = "Dev" THEN
		eCode   =  20967
		Vol		=  "vol02"
	Else
		eCode   =  45796
		Vol		=  "vol02"
	End If

	Dim chkid, chklevel, i
	dim myprofile
	dim userphone, usercell
	dim evtID
	chkid = getEncLoginUserID
	chklevel =  GetLoginUserLevel

'----------------------------------
' fnAlertMsg : 메시지 표시
'----------------------------------
Function fnAlertMsg(ByVal strMsg)
%>
	<script language="javascript">
		alert("<%=strMsg%>");
		location.replace('<%=wwwURL%>')
	</script>
<%
End Function

'유효기간 체크'
	rsget.open "select top 1 evt_code from db_event.dbo.tbl_event where evt_code = '" & eCode & "' and getdate()>evt_startdate and getdate() <= dateadd(d,1,evt_enddate) ",dbget,1
	if not rsget.eof then
		evtID = rsget("evt_code")
	else
		evtID = ""
	end if
	rsget.close

	if evtID="" then
		fnAlertMsg("주소 확인 기간이 아닙니다.")
		response.end
	end if

	'// vip 회원이상만 신청가능 //
	IF  ( chklevel <> 3 and chklevel <> 4 and chklevel <> 7 and chkid <> "star088")  THEN
		fnAlertMsg("V.I.P 회원만 이용가능합니다.\n\n고객등급을 확인해주세요")
		response.end
	END IF

'// 주소, 핸드폰, 유선전화번호 가져오기 //
	set myprofile = new CUserInfo
	myprofile.FRectUserID = chkid
	myprofile.GetUserData

If isnull(myprofile.FOneItem.Fuserphone) then
	myprofile.FOneItem.Fuserphone = "--"
	userphone = split(myprofile.FOneItem.Fuserphone,"-")
else
	userphone = split(myprofile.FOneItem.Fuserphone,"-")

end if
	usercell = split(myprofile.FOneItem.Fusercell,"-")
%>

<!doctype html>
<html lang="ko">
<head>
<!-- #include virtual="/lib/inc/head.asp" -->
<title>생활감성채널, 텐바이텐 > 이벤트 > 고마워서 보내는 선물</title>
<style type="text/css">
.mEvt45797 {}
.mEvt45797 img {vertical-align:top;}
.mEvt45797 .ct {text-align:center !important;}
.mEvt45797 .tMar15 {margin-top:15px;}
.mEvt45797 .myCandleWrap {position:relative; overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_bg_addr.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .myCandle { width:89%; border-top:5px solid #cc0d0d; margin:8% 5%;}
.mEvt45797 .myCandle .myAddr {position:relative;  padding:5%; border:1px solid #bebebe; border-top:0; box-shadow:3px 3px 3px #ebebeb;}
.mEvt45797 .myCandle .myAddr dl {overflow:hidden; width:100%; display:table; font-size:12px; margin-bottom:15px;}
.mEvt45797 .myCandle .myAddr dt {display:table-cell; vertical-align:top; width:30%; padding-top:9px; font-weight:bold; color:#555;}
.mEvt45797 .myCandle .myAddr dd {display:table-cell; width:70%; text-align:left; vertical-align:top;}
.mEvt45797 .myCandle .myAddr dd .bar {padding-top:7px; display:inline-block;}
.mEvt45797 .myCandle .myAddr dd .txtInp {height:18px; padding:5px 10px; font-size:12px; border:1px solid #bbb; color:#666; vertical-align:top; font-family:verdana, tahoma, dotum, dotumche, '돋움', '돋움체', sans-serif;}
.mEvt45797 .myAddr .btn01 {font-size:11px; line-height:12px; padding:8px; color:#fff; background:#aaa; border:1px solid #aaa; vertical-align:top; }
.mEvt45797 .myAddr .btn01:hover {background:#8a8a8a; border:1px solid #8a8a8a;}
.mEvt45797 .myAddr .btn02 {color:#fff; background:#d50c0c; border:1px solid #d50c0c; font-size:12px; line-height:13px; padding:12px 25px; vertical-align:top; }
.mEvt45797 .myAddr .btn02:hover {background:#b20202; border:1px solid #b20202;}
.mEvt45797 .specialGift {position:relative;}
.mEvt45797 .slide {position:relative; overflow:hidden; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .slidesjs-slide {background-size:100% 100%; background-position:left top; background-repeat:no-repeat;}
.mEvt45797 .slidesjs-container {width:95% !important; margin:0 auto;}
.mEvt45797 .slidesjs-pagination {position:absolute; right:20px; bottom:10px; z-index:100; overflow:hidden;}
.mEvt45797 .slidesjs-pagination li {float:left; width:10px; margin-left:4px;}
.mEvt45797 .slidesjs-pagination li a {display:block; width:10px; height:10px; text-indent:-9999px; background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_pagination_off.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .slidesjs-pagination li a.active {background:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_pagination_on.png) left top no-repeat; background-size:100% 100%;}
.mEvt45797 .goldGrade .slide .photo01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle01.png);}
.mEvt45797 .goldGrade .slide .photo02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle02.png);}
.mEvt45797 .goldGrade .slide .photo03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle03.png);}
.mEvt45797 .goldGrade .slide .photo04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle04.png);}
.mEvt45797 .goldGrade .slide .photo05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_gold_candle05.png);}
.mEvt45797 .silverGrade .slide .photo01 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle01.png);}
.mEvt45797 .silverGrade .slide .photo02 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle02.png);}
.mEvt45797 .silverGrade .slide .photo03 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle03.png);}
.mEvt45797 .silverGrade .slide .photo04 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle04.png);}
.mEvt45797 .silverGrade .slide .photo05 {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_silver_candle05.png);}
.mEvt45797 .candleImage {background-size:100% 100%; background-repeat:no-repeat; background-position:left top;}
.mEvt45797 .goldGrade .candleImage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_img_gold_candle.png);}
.mEvt45797 .silverGrade .candleImage {background-image:url(http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_img_silver_candle.png);}
</style>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="http://www.10x10.co.kr/lib/js/jquery.slides.min_3.0.4.js"></script>
<script type="text/javascript">
$(function(){
	$(function(){
	$('.slide').slidesjs({
		//width:"850",
		//height:"564",
		navigation: false,
		pagination: {
			effect: "fade"
		},
		play: {
			interval:3000,
			effect: "fade",
			auto: true,
			swap: false
		},
		effect: {
			fade: {
				speed:1500,
				crossfade: true
			}
		}
	});
});
});
</script>

<script language="JavaScript" type="text/javascript">

	function jsSubmit(frm){
		// 주소, 전화번호, 핸드폰 필수 정보입력
	if (frm.txZip2.value.length<3){
		alert('우편번호를 입력해 주세요.');
		frm.txZip2.focus();
		return;
	}

	if (frm.txAddr2.value.length<1){
		alert('나머지 주소를 입력해 주세요.');
		frm.txAddr2.focus();
		return;
	}

	if (frm.userphone1.value.length<2){
		alert('전화번호1을 입력해 주세요.');
		frm.userphone1.focus();
		return;
	}

	if (frm.userphone2.value.length<2){
		alert('전화번호2을 입력해 주세요.');
		frm.userphone2.focus();
		return;
	}

	if (frm.userphone3.value.length<2){
		alert('전화번호3을 입력해 주세요.');
		frm.userphone3.focus();
		return;
	}

	if (frm.usercell1.value.length<2){
		alert('핸드폰번호1을 입력해 주세요.');
		frm.usercell1.focus();
		return;
	}

	if (frm.usercell2.value.length<2){
		alert('핸드폰번호2을 입력해 주세요.');
		frm.usercell2.focus();
		return;
	}

	if (frm.usercell3.value.length<2){
		alert('핸드폰번호3을 입력해 주세요.');
		frm.usercell3.focus();
		return;
	}

	frm.submit();
	}

</script>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container">
			<!-- #include virtual="/lib/inc/incHeader.asp" -->
			<!-- content area -->
			<div class="content" id="contentArea">
			<form name="frminfo" method="post" action="specialthanks2013_process.asp">
			<input type="hidden" name="chkid" value="<%=chkid%>">
			<input type="hidden" name="chklevel" value="<%=chklevel%>">
			<input type="hidden" name="Vol" value="<%=Vol%>">
				<div class="mEvt45797">
					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_head.png" alt="고마워서 보내는 선물" style="width:100%;" /></div>
					<!-- for dev msg : 골드 회원일경우 클래스 goldGrade / 실버회원일경우 클래스 silverGrade 추가해주세요 -->
					<div class="specialGift <%= ChkIIF(chklevel=3,"silverGrade","goldGrade")%>">
						<div class="slide">
							<div class="photo01"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo02"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo03"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo04"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
							<div class="photo05"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank03.png" alt="" style="width:100%;" /></div>
						</div>
						<div class="myCandleWrap">
							<div class="myCandle">
								<div class="myAddr">
									<p><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_txt01.png" alt="주소확인" style="width:100%;" /></p>
									<dl>
										<dt>회원아이디</dt>
										<dd><input type="text" value="<%=chkid%>" class="txtInp" style="width:60%;" readonly /></dd>
									</dl>
									<dl>
										<dt>주소</dt>
										<dd>
											<p>
												<input type="tel" name="txZip1" value="<%= Left(myprofile.FOneItem.Fzipcode,3) %>" readOnly class="txtInp" style="width:9%;" />
												<span class="bar">-</span>
												<input type="tel" name="txZip2" value="<%= right(myprofile.FOneItem.Fzipcode,3) %>" readOnly class="txtInp" style="width:9%;" />
												<a href="javascript:TnFindZip('frminfo');" class="btn btn01">우편번호 찾기</a>
											</p>
											<p class="tMar15"><input type="text" name="txAddr1" value="<%= myprofile.FOneItem.FAddress1 %>" readOnly class="txtInp" style="width:81%;" /></p>
											<p class="tMar15"><input type="text" name="txAddr2" value="<%= myprofile.FOneItem.FAddress2 %>" class="txtInp" style="width:81%;" /></p>
										</dd>
									</dl>
									<dl>
										<dt>전화번호</dt>
										<dd>
											<input type="tel" name="userphone1" size="3" value="<%= userphone(0) %>" maxlength="3" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" name="userphone2" size="3" value="<%= userphone(1) %>" maxlength="4" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" name="userphone3" size="3" value="<%= userphone(2) %>" maxlength="4" class="txtInp" style="width:15%;" />
										</dd>
									</dl>
									<dl>
										<dt>휴대전화</dt>
										<dd>
											<input type="tel" name="usercell1" size="3" value="<%= usercell(0) %>" maxlength="3" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" name="usercell2" size="4" value="<%= usercell(1) %>" maxlength="4" class="txtInp" style="width:15%;" />
											<span class="bar">-</span>
											<input type="tel" name="usercell3" size="4" value="<%= usercell(2) %>" maxlength="4" class="txtInp" style="width:15%;" />
										</dd>
									</dl>
									<p class="ct" style="margin-top:25px;"><a href="javascript:jsSubmit(document.frminfo);" onFocus="this.blur()" class="btn btn02">주소 확인하기</a></p>
									<p class="ct" style="margin-top:10px;"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_txt02.png" alt="이곳에서 확인하신 주소는 기본 회원 정보로 업데이트됩니다." style="width:100%;" /></p>
								</div>
							</div>
						</div>
						<div class="candleImage"><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_blank02.png" alt="" style="width:100%;" /></div>
					</div>

					<div><img src="http://webimage.10x10.co.kr/eventIMG/2013/45797/45797_tenten_gift.png" alt="10월10일 12주년을 맞이하는 텐바이텐에서 만나요!" style="width:100%;" /></div>
				</div>
			</form>
			</div>
			<!-- //content area -->
		</div>
		<!-- #include virtual="/lib/inc/incFooter.asp" -->
	</div>
	<!-- #include virtual="/category/incCategory.asp" -->
</div>
</body>
</html>
<%
set myprofile = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->