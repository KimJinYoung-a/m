<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'###########################################################
' Description :  PLAY #13 Cat & Dog_10 Scarf
' History : 2014.10.24 유태욱 생성 - 모바일andApp공용
'###########################################################
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/event/lib/event_etc_function.asp" -->
<!-- #include virtual="/lib/classes/enjoy/eventApplyCls.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_pointcls.asp" -->
<%
Dim eCode, linkeCode
IF application("Svr_Info") = "Dev" THEN
	eCode   	=	21345
	linkeCode	=	21346
Else
	eCode   	=  55957
	linkeCode   =  55934
End If

	Dim sqlStr, pNum, donationCost, graph
	sqlStr = "SELECT COUNT(distinct userid), sum(sub_opt2) from db_event.dbo.tbl_event_subscript where evt_code='" & eCode & "'"
	rsget.Open sqlStr,dbget,1
	IF Not rsget.Eof Then
		pNum = rsget(0)
		donationCost = rsget(1)
	End IF
	rsget.close

	IF pNum="" then pNum=0
	IF isNull(donationCost)  then donationCost=0
	graph = Int( donationCost / 2000000 * 100  )	'게이지바 % 계산

Dim oMileage, availtotalMile
set oMileage = new TenPoint
	oMileage.FRectUserID = getEncLoginUserID
	
if (getEncLoginUserID<>"") then
    oMileage.getTotalMileage

    availtotalMile = oMileage.FTotalMileage
end if

If availtotalMile = "" Then
	availtotalMile = 0
End IF

%>
<script type="text/javascript">
<!--
	function keyevt(){
		if(event.keyCode < 48 || event.keyCode > 57){
			alert("숫자만 입력해주세요.");
			window.event.keyCode = 0;
			return false;
		}
	}

	function allcost(){
		if(document.frm1.allin.checked==true){
			document.frm1.dcost.value= <%= availtotalMile %>;
		}
		if(document.frm1.allin.checked==false){
			document.frm1.dcost.value= 0;
		}
	}
	function jsSubmitDonation(frm){
		alert("이벤트가 종료되었습니다");
		return false;
		<% if Not(IsUserLoginOK) then %>
		    jsChklogin('<%=IsUserLoginOK%>');
		    return false;
		<% end if %>

	   if(frm.dcost.value < 100){
	    alert("기부금액은 100원 이상부터 가능합니다.");
		document.frm1.dcost.value="0";
	    frm.dcost.focus();
	    return false;
	   }
		
	   document.getElementById("sbtn").style.display="hidden";
	   
	   frm.action = "/event/lib/mileage_process.asp";
	   return true;
	}
//-->
</script>
<style type="text/css">
.mEvt55934 {}
.mEvt55934 img {width:100%; vertical-align:top;}
.tendegrees-scarf .heading {position:relative; padding-bottom:10%; background-color:#fff;}
.tendegrees-scarf .heading .topic {position:absolute; top:15%; left:0; width:100%;}
.tendegrees-scarf .heading .visual {margin-bottom:10%;}
.tendegrees-scarf .heading .btn-brand {width:34.5%; margin:5% auto 0;}
.tendegrees-scarf .meaning {padding-top:10%; background-color:#f1efe3;}
.tendegrees-scarf .meaning .btn-buy {width:70%; margin:5% auto 10%;}
.tendegrees-scarf .wintering {padding:10% 0; background-color:#fff;}
.tendegrees-scarf .donation .field {padding:30px 20px; background-color:#564940; color:#fff;}
.tendegrees-scarf .donation legend {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}
input[type=number] {border:none; border-radius:0;}
input[type=number]::-webkit-inner-spin-button, 
input[type=number]::-webkit-outer-spin-button {-webkit-appearance:none;}
input[type=number] {-moz-appearance:textfield;}
.tendegrees-scarf .donation .item {position:relative; margin-top:12px; padding-left:100px;}
.tendegrees-scarf .donation .item span:first-child {position:absolute; top:0; left:0; width:100px;}
.tendegrees-scarf .donation .item span {font-size:12px; font-weight:bold; line-height:1.438em;}
.tendegrees-scarf .donation .item strong {color:#ff8c5a;}
.tendegrees-scarf .donation .item input[type=number] {width:130px; margin-right:4px; color:#ff7b41; font-size:25px; font-weight:bold; text-align:right; vertical-align:top;}
.tendegrees-scarf .donation .item em {display:block; margin-top:12px; color:#ffad89;}
.tendegrees-scarf .donation .item em input[type=checkbox] {margin-right:4px;}
.tendegrees-scarf .donation .btn-submit {margin-top:15px;}
.tendegrees-scarf .donation .btn-submit input {width:100%;}
.rates {margin-top:15px;}
.rates h3 {font-size:12px; font-weight:bold; line-height:1.438em;}
.rates .percent {overflow:hidden; display:block; width:100%; height:36px; margin-top:8px; border-radius:20px; background-color:#fff;}
.rates .percent span {display:block; height:36px; background-color:#efc8a5;}
.rates strong {font-size:12px; font-weight:bold; line-height:1.438em;}
.rates p {position:relative; margin-top:7px;}
.rates .present strong,
.rates .people strong {color:#efc8a5;}
.rates .people {position:absolute; top:0; right:0;}
.tendegrees-scarf .noti {padding:5% 0 10%; background-color:#f1efe3;}
.tendegrees-scarf .noti strong, .tendegrees-scarf .noti ul {visibility:hidden; width:0; height:0; overflow:hidden; position:absolute; top:-1000%; line-height:0;}

@media all and (min-width:640px){
	.tendegrees-scarf .donation .field {padding:45px 35px;}
	.tendegrees-scarf .donation .item {margin-top:20px; padding-left:150px;}
	.tendegrees-scarf .donation .item span:first-child {width:150px;}
	.tendegrees-scarf .donation .item span {font-size:18px;}
	.tendegrees-scarf .donation .item input[type=number] {width:195px;}
	.tendegrees-scarf .donation .item em {margin-top:18px;}
	.tendegrees-scarf .donation .btn-submit {margin-top:25px;}
	.rates h3 {font-size:18px;}
	.rates strong {font-size:18px;}
	.rates .percent {height:54px; border-radius:30px;}
	.rates .percent span {height:54px;}
	.rates p {margin-top:15px;}
}
.animated {-webkit-animation-duration:7s; animation-duration:7s; -webkit-animation-fill-mode:both; animation-fill-mode:both; -webkit-animation-iteration-count:infinite; animation-iteration-count:infinite;}
/* Flash animation */
@-webkit-keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.3;}
}
@keyframes flash {
	0%, 50%, 100% {opacity: 1;}
	25%, 75% {opacity:0.3;}
}
.flash {-webkit-animation-name:flash; animation-name:flash;}
</style>
</head>
<body>
<div class="heightGrid">
	<div class="mainSection">
		<div class="container bgGry">
			<!-- content area -->
			<div class="content evtView" id="contentArea">
				<!-- 이벤트 배너 등록 영역 -->
				<div class="evtCont">
					<div class="mEvt55934">
						<div class="tendegrees-scarf">
							<div class="section heading">
								<p class="topic animated flash"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_tenbyten_with_coteacote.png" alt="텐바이텐과 꼬떼아 꼬데가 함께 합니다." /></p>
								<div class="visual"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/img_tenbyten_with_coteacote.jpg" alt="" /></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_coteacote.gif" alt="꼬떼아꼬떼는 우리의 반려견과 더 행복한 시간을 만들어갈 수 있도록 일상에서 공유할 수 있는 다양한 아이템을기획, 제작합니다. 위트 있는 의류를 기반으로 인테리어 소품,  일러스트 제품까지. 재미를 추구하지만 올바른 메시지를 담은 반려견 문화와 함께 나란히 걷는 꼬떼아꼬떼가 되겠습니다." /></p>
								<div class="btn-brand">
								<% if isApp=1 then %>
									<a href="" onclick="fnAPPpopupBrand('coteacote'); return false;">
								<% else %>
									<a href="/street/street_brand.asp?makerid=coteacote" target="_blank" title="새창">
								<% end if %>
										<img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/btn_brand.gif" alt="브랜드 바로가기" />
									</a>
								</div>
							</div>

							<div class="section meaning">
								<h1><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/tit_tendegrees_scarf.gif" alt="텐바이텐과 꼬떼아꼬떼의 10도씨 스카프" /></h1>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_tendegrees_scarf.gif" alt="의미 있는 반려견과의 여행. 그 설레는 순간을 담은 2014 F/W JOURNEY 라인 중 반려동물 보호에 조금이나마 힘이 되고자 SPECIAL EDITION SCARF를 제작하게 되었습니다. 반려동물의 체온을 올려줄 수 있는 이 스카프의 수익금은 동물보호시민단체 KARA에 전달되어, 유기동물 보호소 겨울나기 사업에 기부됩니다. 이 스카프를 통해 우리 모두가 나란히, 그리고 함께 10℃ 더 따뜻한 겨울을 보낼 수 있기를 바랍니다." /></p>
								<span><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/img_scarf.jpg" alt="10도씨 스카프" /></span>
								<div class="btn-buy"><a href="/category/category_itemPrd.asp?itemid=1148595" target="_blank" title="새창"><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/btn_buy.png" alt="10도씨 스카프 구매하러 가기" /></a></div>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/img_photo.jpg" alt="10도씨 스카프 착용한 강아지의 모습" /></p>
							</div>
							
							<div class="section wintering">
								<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/tit_wintering.jpg" alt="유기동물 보호소 겨울나기 사업" /></h2>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_wintering.gif" alt="고양시 원정자님 댁 보호소는 은평 뉴타운 재개발로 인해 버려진 아이들이 살아가는 곳입니다. 버려진 녀석들을 한 두 마리 맡아주거나 너무 안쓰러워서 데려오셨던 아주머니.. 그렇게 모인 개들이 70여 마리가 되었습니다. 쌀쌀한 바람이 불어오는 겨울, 두꺼운 비닐로 견사 외부를 꽁꽁 막아주는 바람막이 공사를 하고, 헤지고 더러워진 이불을 말끔하게 걷어내고 땅에서 올라오는 냉기를 막아줄 푹신하고 두터운 이불을 깔아주려고 합니다. 비록 가정집만큼 따뜻하진 않지만, 따뜻한 관심과 사랑으로  이번 겨울을 잘 이겨낼 수 있기를 바랍니다. 유기동물 보호소 겨울나기 프로젝트는 동물보호 시민단체 KARA와 함께 합니다." /></p>
							</div>

							<!-- donation -->
							<div class="section donation">
								<h2><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/tit_donation.gif" alt="당신의 마일리지로 따뜻한 겨울을 만들어 주세요" /></h2>
								<p><img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_date.gif" alt="모금기간은 2014년 10월 27일부터 11월 17일까지입니다." /></p>
								<div class="field">
									
									<form name="frm1" method="post" onSubmit="return jsSubmitDonation(this);" style="margin:0px;">
									<input type="hidden" name="eventid" value="<%=eCode%>">
									<input type="hidden" name="eventidlink" value="<%=linkeCode%>">
									<input type="hidden" name="userid" value="<%=GetLoginUserID%>">
									<input type="hidden" name="availtotalMile" value="<%=availtotalMile%>">
										<fieldset>
										<legend>마일리지 기부하기</legend>
											<!-- for dev msg : 보유 마일리지 -->
											<div class="item">
												<span>보유 마일리지</span>
												<span><strong><%=FormatNumber(availtotalMile,0)%></strong> 원</span>
											</div>

											<!-- for dev msg : 기부금액 입력 및 보유 마일리지 전부 기부하기 -->
											<div class="item">
												<span><label for="amout">기부금액 입력</label></span>
												<span>
													<input name="dcost" onkeypress="keyevt();" value="0" type="number" id="amout" /> 원
													<em><input type="checkbox" name="allin" onclick="allcost();" id="donationAll" /> <label for="donationAll">보유 마일리지 전부 기부하기</label></em>
												</span>
											</div>

											<div class="btn-submit"><span id="sbtn"><input type="image" src="http://webimage.10x10.co.kr/eventIMG/2014/55934/btn_donation.gif" alt="기부하기" /></span></div>
										</fieldset>
									</form>

									<div class="rates">
										<h3>기부 참여현황</h3>
										<!-- for dev msg : 기부율 퍼센트로 표시 -->
										<span class="percent"><span style="width:<%=graph%>%;"></span></span>
										<p>
											<strong class="present">현재 <strong><%=FormatNumber(donationCost,0)%></strong> 원</strong>
											<strong class="people"><strong><%=FormatNumber(pNum,0)%></strong> 명 참여</strong>
										</p>
									</div>
								</div>
							</div>

							<div class="section noti">
								<strong>미리 확인하세요!</strong>
								<ul>
									<li>마일리지 기부는 100마일리지 이상부터 기부가 가능하며, 취소 및 환불이 불가합니다.</li>
									<li>ID 당 나눔 동참하기의 횟수 제한은 없으며, 보유하고 계신 마일리지 금액 내에서만 가능합니다. </li>
									<li>고객님의 마일리지 기부금은 동물보호시민단체 KARA의 유기동물 보호소 겨울나기 사업 기금으로 전액 기부됩니다. </li>
									<li>보유하고 계신 마일리지는 기부하기를 누르시면 바로 차감되며, 취소 및 환불 받으실 수 없습니다. </li>
									<li>마일리지가 부족하시구요? 상품구매후기를 작성하시면 마일리지가 적립됩니다 : )</li>
								</ul>
								<img src="http://webimage.10x10.co.kr/eventIMG/2014/55934/txt_noti.gif" alt="" />
							</div>
						</div>
					</div>
				</div>
				<!--// 이벤트 배너 등록 영역 -->
			</div>
			<!-- //content area -->
		</div>
	</div>
</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->