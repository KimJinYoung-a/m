<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  꽃을 든 무민(하나은행제휴 이벤트)
' History : 2017-05-11 유태욱 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	Dim eCode, vQuery, vUserID
	dim mycnt, myname, mycell, myaddr1, myaddr2, mysongjang, myregdate, myaddridx, myzipcode
	mycnt = 0

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  66323
	Else
		eCode		=  77767
	End If
	
	vUserID = getEncLoginUserID

	dim oUserInfo, vTotalCount2, allcnt
	set oUserInfo = new CUserInfo
		oUserInfo.FRectUserID = vUserID
	if (vUserID<>"") then
		oUserInfo.GetUserData
	end If

	'// 전체 인원수 확인
	vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code ='"& eCode &"' "
	rsget.Open vQuery,dbget,1
	IF Not rsget.Eof Then
		allcnt = rsget(0)
	End If
	rsget.close()

	if vUserID <> "" then
		'// 내 신청내역 확인
		vQuery = "SELECT count(*) FROM [db_temp].[dbo].[tbl_temp_event_addr] WHERE evt_code ='"& eCode &"' and userid='"&vUserID&"' "
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			mycnt = rsget(0)
		End If
		rsget.close()
	end if

	if mycnt > 0 Then
		vQuery = "Select top 1 a.username, a.usercell, a.addr1, a.addr2, s.regdate, a.idx, a.zipcode" + vbcrlf
		vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_temp_event_addr] as a" + vbcrlf	
		vQuery = vQuery & " 		join [db_event].[dbo].[tbl_event_subscript] as s " + vbcrlf	
		vQuery = vQuery & " 			on a.userid=s.userid and a.evt_code=s.evt_code " + vbcrlf	
		vQuery = vQuery & " WHERE a.evt_code='" & eCode & "' and a.userid='" & vUserID & "'" + vbcrlf	
		vQuery = vQuery & " order by a.idx desc, s.sub_idx desc " + vbcrlf	
'		response.write vQuery
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			myname = rsget(0)
			mycell = rsget(1)
			myaddr1 = rsget(2)
			myaddr2 = rsget(3)
			myregdate = rsget(4)
			myaddridx = rsget(5)
			myzipcode = rsget(6)
		end if
		rsget.Close

		vQuery = "Select top 1 songjangno " + vbcrlf
		vQuery = vQuery & " FROM [db_sitemaster].[dbo].tbl_etc_songjang  " + vbcrlf	
		vQuery = vQuery & " WHERE userid='" & vUserID & "'" + vbcrlf	
		vQuery = vQuery & " 	and gubunname='꽃을 든 무민' and gubuncd=99 and deleteyn='N' " + vbcrlf	
		vQuery = vQuery & " order by id desc " + vbcrlf	
'		response.write vQuery
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			mysongjang = rsget(0)
		end if
		rsget.Close
	end if
	
%>
<style type="text/css">
.mEvt77767 {position:relative;}
.slideTemplateV15 .limit {position:absolute; right:4.6%; top:-13%; width:14.53%; z-index:30;}
.slideTemplateV15 .slideNav {width:9.68%; background-size:100% auto;}
.slideTemplateV15 .btnPrev {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77767/m/btn_prev.png);}
.slideTemplateV15 .btnNext {background-image:url(http://webimage.10x10.co.kr/eventIMG/2017/77767/m/btn_next.png);}
.enterCode {padding-bottom:3rem; background:#87a5d4;}
.enterCode .inpArea {position:relative; overflow:hidden; width:78%; margin:0 auto; background-color:#fff;}
.enterCode .inpArea .number {position:absolute; left:0; top:0; width:70%; min-height:4rem; height:100%; font-size:1.5rem; font-weight:bold; color:#000; text-align:center; border:0;}
.enterCode .inpArea .btnSubmit {float:right; width:30%;}
.enterCode .soldout {position:absolute; left:0; top:0; width:100%;}
.enterCode .tip {padding-top:1.2rem; text-align:center; color:#fff; font-size:1rem;}
.applyList {position:relative; padding-bottom:7.5rem; text-align:center; background:#87a5d4;}
.applyList h3 {padding-bottom:1.2rem; font-size:1.7rem; line-height:1; font-weight:bold; color:#fff;}
.applyList h3 i {padding:0 0.5rem; font-size:0.9rem; vertical-align:middle;}
.applyList .btnView {display:block; position:absolute; left:50%; bottom:4rem; width:14.6rem; height:3.4rem; padding:0 2.5rem; line-height:3.5rem; color:#fff; font-weight:600; margin-left:-7.3rem;; font-size:1.3rem; border:0.1rem solid #fff; border-radius:1.7rem;}
.applyList .btnView:after {content:'신청 내역 보기'; display:inline-block; position:absolute; left:0; top:0; width:100%; height:100%; padding-right:1.8rem; box-sizing:border-box; -webkit-box-sizing:border-box; -moz-box-sizing:border-box; box-sizing:border-box;}
.applyList .btnView span {display:inline-block; position:absolute; right:2.6rem; top:50%; width:0.8rem; height:0.45rem; margin-top:-0.06rem; background:url(http://webimage.10x10.co.kr/eventIMG/2017/77767/m/blt_arrow.png) no-repeat 0 0; background-size:100%;}
.applyList.listOn .btnView span {transform:rotate(180deg);}
.applyList.listOn .btnView:after {content:'신청 내역 닫기';}
.applyList .view {display:none; width:88%; margin:0 auto 1.5rem;}
.applyList .view > div {padding:2rem; background:#fff; border-radius:0.5rem;}
.applyList.listOn .view {display:block;}
.applyList table {font-size:1.1rem; line-height:1.3; border-bottom:0.1rem solid #ddd;}
.applyList th {color:#222; background-color:#f4f4f4; border-top:0.1rem solid #ddd; vertical-align:middle;}
.applyList td {padding:1.4rem 1.8rem; text-align:left; color:#666; border-top:0.1rem solid #ddd; vertical-align:middle;}
.applyList .caution {padding-top:1rem; color:#e43d5c; font-weight:600;}
.applyList .btnModify {display:inline-block; height:2.65rem; line-height:2.7rem; padding:0 1.1rem; color:#666; border:1px solid #ccc;}
.applyList .nodata {padding:4rem 0; color:#666;}
.addrLayer {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:3rem; background-color:rgba(0,0,0,.7); z-index:1000;}
.addrLayer .layerCont {width:87.5%; margin:0 auto; padding:4rem 2.5rem; background-color:#fff;}
.addrLayer h3 {padding-bottom:2.5rem; text-align:center; font-size:1.5rem; font-weight:bold;}
.addrLayer .selectOption span {display:inline-block; width:45%;}
.addrLayer .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.addrLayer .selectOption label {color:#888; font-size:1.1rem; font-weight:bold; line-height:1.75em; vertical-align:middle;}
.addrLayer .selectOption input[type=radio]:checked {background:#fff url(http://webimage.10x10.co.kr/playmo/ground/20141229/bg_element_radio.png) no-repeat 50% 50%; background-size:10px 10px;}
.addrLayer table {margin-top:0.5rem;}
.addrLayer table caption {visibility:hidden; width:0; height:0;}
.addrLayer table th {padding-top:2.1rem; color:#666; font-size:1.1rem; text-align:left; vertical-align:top;}
.addrLayer table td {padding:0.7rem 0;}
.addrLayer table input {width:100%; height:3.4rem; border:1px solid #ddd; border-radius:0; color:#999; font-size:1.2rem;}
.addrLayer table .group {display:table; position:relative; width:100%;}
.addrLayer table .group span, .addrLayer table .group i {display:table-cell; vertical-align:middle; text-align:center;}
.addrLayer table .group i {width:8%; height:3.4rem; color:#666; text-align:center;}
.addrLayer table .group span {width:28.2%; height:3.4rem;}
.addrLayer table .group .btnFind {display:table-cell; width:30%; height:3.4rem; padding-left:0.5rem; text-align:center;}
.addrLayer table .group .btnFind span {background-color:#000; color:#fff; font-size:1.2rem;}
.addrLayer ul {padding-top:1rem;}
.addrLayer li {position:relative; padding-left:1rem; color:#777; font-size:1rem; line-height:1.4; margin-bottom:0.2rem;}
.addrLayer li:after {content:''; display:inline-block; position:absolute; left:0; top:0.44rem; width:0.25rem; height:0.25rem; background-color:#777; border-radius:50%;}
.addrLayer .btnSubmit {display:block; width:11.5rem; height:4rem; margin:1.8rem auto 0; font-size:1.5rem; font-weight:bold; background-color:#d60000;}
.producct {position:relative;}
.producct a {position:absolute; right:2%; bottom:5%; width:40%; height:15%; text-indent:-999em;}
.noti {padding:4rem 6.875%; color:#fff; background-color:#777;}
.noti h3 {padding-bottom:1.5rem; font-size:1.5rem; font-weight:bold;}
.noti .count {padding-bottom:1rem; font-size:1.15rem; font-weight:600;}
.noti .count strong {color:#ffe373;}
.noti li {position:relative; margin-top:0.3rem; padding-left:1.2rem; font-size:1.1rem; line-height:1.4;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.45rem; width:0.35rem; height:0.35rem; background-color:#fff; border-radius:50%;}
</style>
<script type="text/javascript">
$(function(){
	slideTemplate = new Swiper('.slideTemplateV15 .swiper-container',{
		loop:true,
		autoplay:3000,
		autoplayDisableOnInteraction:false,
		speed:800,
		pagination:".slideTemplateV15 .pagination",
		paginationClickable:true,
		nextButton:'.slideTemplateV15 .btnNext',
		prevButton:'.slideTemplateV15 .btnPrev'
	});

	$("#addrLayer").hide();

	// 신청내역 확인
	$(".applyList .btnView").click(function(){
		$(".applyList").toggleClass("listOn");
	});
});

function fnedit() {
	$("#addrLayer").show();
	window.parent.$('html,body').animate({scrollTop:$("#addrLayer").offset().top}, 800);
}

function fnitsm(md,amd,maidx) {
	<% If vUserID = "" Then %>
		<% If isapp="1" Then %>
			parent.calllogin();
			return;
		<% else %>
			parent.jsevtlogin();
			return;
		<% End If %>
	<% End If %>
	<% If vUserID <> "" Then %>
		$("#mode").val(md);
		$("#amode").val(amd);
		$("#myaddridx").val(maidx);
		var hncode = $("#hncode").val();
		var username = $("#username").val();
		var reqhp1 = $("#reqhp1").val();
		var reqhp2 = $("#reqhp2").val();
		var reqhp3 = $("#reqhp3").val();
		var txZip = $("#txZip").val();
		var txAddr1 = $("#txAddr1").val();
		var txAddr2 = $("#txAddr2").val();

		if(amd!="edit"){
			if(hncode==""||hncode.length != 11){
	            alert("정확한 코드를 입력해 주세요.");
	            $("#hncode").val('');
	            $("#hncode").focus();
	            return false;
	    	}
	    }

		if(md=="frin"){
	        if(isNaN(hncode) == true) {
	            alert("숫자만 입력 가능합니다.");
	            $("#hncode").focus();
	            return false;
	        }
    	}else{
			if(username==""){
	            alert("이름을 입력해 주세요.");
	            $("#hncode").focus();
	            return false;
	    	}

			if(reqhp1==""){
	            alert("휴대폰 번호를 정확히 입력해 주세요");
	            $("#reqhp1").focus();
	            return false;
	    	}

			if(reqhp2==""){
	            alert("휴대폰 번호를 정확히 입력해 주세요");
	            $("#reqhp2").focus();
	            return false;
	    	}
			if(reqhp3==""){
	            alert("휴대폰 번호를 정확히 입력해 주세요");
	            $("#reqhp3").focus();
	            return false;
	    	}
			if(txZip==""){
	            alert("주소찾기를 통해 주소를 입력해 주세요");
	            $("#txZip").focus();
	            return false;
	    	}
			if(txAddr1==""){
	            alert("주소찾기를 통해 주소를 입력해 주세요");
	            return false;
	    	}
			if(txAddr2==""){
	            alert("주소를 입력해 주세요.");
	            $("#txAddr2").focus();
	            return false;
	    	}
	        if(isNaN($("#reqhp1").val()) == true) {
	            alert("전화번호는 숫자만 입력 가능합니다.");
	            $("#reqhp1").focus();
	            return false;
	        }
	        if(isNaN($("#reqhp2").val()) == true) {
	            alert("전화번호는 숫자만 입력 가능합니다.");
	            $("#reqhp2").focus();
	            return false;
	        }
	        if(isNaN($("#reqhp3").val()) == true) {
	            alert("전화번호는 숫자만 입력 가능합니다.");
	            $("#reqhp3").focus();
	            return false;
	        }
    	}
		$("#hanacode").val(hncode);
		var params = jQuery("#frmorder").serialize();
		var reStr;
		$.ajax({
			type: "POST",
			url:"/event/etc/doeventsubscript/doEventSubscript77767.asp",
			data: params,
			dataType: "text",
			async: false,
	        success: function (str) {
	        	reStr = str.split("|");
				if(reStr[0]=="OK"){
					if(reStr[1] == "dn") {
						if(amd=="add"){
							alert('신청이 완료되었습니다.');
							document.location.reload();
							return false;
						}else if(amd=="edit"){
							alert('수정이 완료되었습니다.');
							document.location.reload();
							return false;
						}else{
							document.location.reload();
							return false;
						}
					}else if(reStr[1] == "frin"){
						$("#addrLayer").show();
						window.parent.$('html,body').animate({scrollTop:$("#addrLayer").offset().top}, 800);
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}else{
					errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
//					document.location.reload();
					return false;
				}
	        }
		});
	<% End If %>
}

function chgaddr(v){
	var frm = document.frmorder

	if (v == "N")
	{
		frm.reqname.value = "";
		frm.reqhp1.value = "";
		frm.reqhp2.value = "";
		frm.reqhp3.value = "";
		frm.txZip.value = "";
		frm.txAddr1.value = "";
		frm.txAddr2.value = "";
	}else if (v == "R"){
		frm.reqname.value = frm.tmp_reqname.value;
		frm.reqhp1.value = frm.tmp_reqhp1.value;
		frm.reqhp2.value = frm.tmp_reqhp2.value;
		frm.reqhp3.value = frm.tmp_reqhp3.value;
		frm.txZip.value = frm.tmp_txZip.value;
		frm.txAddr1.value = frm.tmp_txAddr1.value;
		frm.txAddr2.value = frm.tmp_txAddr2.value;
	}

}

function maxLengthCheck(object){
	if (object.value.length > object.maxLength){
		object.value = object.value.slice(0, object.maxLength);
	}    
}

function mysongjang(tid){
	var receiptUrl = "http://www.cjgls.co.kr/kor/service/service02_01.asp?slipno="+tid;
	var popwin = window.open(receiptUrl,"app","width=580,height=500,scrollbars=0");
	popwin.focus();
}
</script>

	<!-- 꽃을 든 무민 -->
	<div class="mEvt77767">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/tit_flower_moomin.png" alt="텐바이텐과 하나은행이 함께하는 꽃을 든 무민" /></h2>
		<div class="slideTemplateV15">
			<p class="limit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_limit.png" alt="선착순 3만명" /></p>
			<div class="swiper">
				<div class="swiper-container">
					<div class="swiper-wrapper">
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/img_slide_01.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/img_slide_02.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/img_slide_03.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/img_slide_04.jpg" alt="" /></div>
						<div class="swiper-slide"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/img_slide_05.jpg" alt="" /></div>
					</div>
				</div>
				<div class="pagination"></div>
				<button type="button" class="slideNav btnPrev">이전</button>
				<button type="button" class="slideNav btnNext">다음</button>
			</div>
		</div>
		<!-- 인증번호, 배송지 입력 -->
		<div class="enterCode">
			<%'<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_enter_num_v2.png" alt="인증번호를 입력해주세요! 본 이벤트는 ID당 한 번만 신청하실 수 있습니다." /></p>%>
			<div class="inpArea">
				<% if allcnt < 30000 then %>
					<%' <input type="number" id="hncode" name="hncode" value="" max="99999999999" maxlength="11" class="number" oninput="maxLengthCheck(this);" placeholder="인증번호" />%>
					<%' <button type="button" onclick="fnitsm('frin','',''); return false;" class="btnSubmit"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/btn_submit.png" alt="입력" /></button> %>
				<% end if %>
			</div>
			<%'<p class="tip">* 본 이벤트는 ID당 한 번만 신청하실 수 있습니다.</p>%>
			
			<% if allcnt >= 27946 then %>
				<p class="soldout"><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_soldout.png" alt="한정 수량이 모두 소진되었습니다!" /></p>
			<% end if %>
		</div>

						<!-- 신청 내역 추가(0526) -->
						<div class="applyList">
							<p class="btnView"><span></span></p>
							<div class="view">
								<h3><i>◆</i>신청 내역<i>◆</i></h3>
								<% if mycnt > 0 then %>
									<!-- 신청내역 있을경우 -->
									<div>
										<table>
											<tr>
												<th width="30%">수령인</th>
												<td><%= myname %></td>
											</tr>
											<tr>
												<th>전화번호</th>
												<td><%= mycell %></td>
											</tr>
											<tr>
												<th>주소</th>
												<td><%= myaddr1 & myaddr2 %></td>
											</tr>
											<% if trim(left(myregdate,10)) = CStr(date()) then %>
												<tr>
													<th>배송정보</th>
													<td><a href="" onclick="fnedit(); return false;" class="btnModify">주소수정</a></td>
												</tr>
											<% else %>
												<% if mysongjang <>"" then %>
													<tr>
														<th>배송정보</th>
														<td>CJ대한통운 <a href="" onclick="mysongjang('<%= mysongjang %>'); return false;" class="btnModify"><%= mysongjang %></a></td>
													</tr>
												<% else %>
													<tr>
														<th>배송정보</th>
														<td>상품준비중</td>
													</tr>
												<% end if %>
											<% end if %>
										</table>
										<p class="caution">배송지 수정은 신청 당일 자정 12시까지만 가능합니다.</p>
									</div>
								<% else %>
									<!-- 신청내역 없을경우 -->
									<div>
										<p class="nodata">이벤트 신청 내역이 없습니다.</p>
									</div>
								<% end if %>
							</div>
						</div>
						<!--// 신청 내역 추가(0526) -->

		<div id="addrLayer" class="addrLayer" style="display:none">
		<% If oUserInfo.FresultCount >0 Then %>
		<form name="frmorder" id="frmorder" method="post">
		<input type="hidden" name="reqphone1"/>
		<input type="hidden" name="reqphone2"/>
		<input type="hidden" name="reqphone3"/>
		<input type="hidden" id="hanacode" name="hanacode" />
		<input type="hidden" name="mode" id="mode" value=""/>
			<input type="hidden" name="amode" id="amode" value=""/>
			<input type="hidden" name="myaddridx" id="myaddridx" value=""/>
		<input type="hidden" name="tmp_reqname" value="<%=oUserInfo.FOneItem.FUserName%>"/>
		<input type="hidden" name="tmp_reqhp1" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) %>"/>
		<input type="hidden" name="tmp_reqhp2" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) %>"/>
		<input type="hidden" name="tmp_reqhp3" value="<%= Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) %>"/>
		<input type="hidden" name="tmp_txZip" value="<%= oUserInfo.FOneItem.FZipCode %>"/>
		<input type="hidden" name="tmp_txAddr1" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress1) %>"/>
		<input type="hidden" name="tmp_txAddr2" value="<%= doubleQuote(oUserInfo.FOneItem.FAddress2) %>"/>
		
			<div class="layerCont">
				<h3>배송받을 주소를 입력해주세요!</h3>
				<div class="selectOption">
					<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');" checked /><label for="address01">기본 주소</label></span>
					<span><input type="radio" id="address02" name="addr" value="2" onclick="chgaddr('N');" /><label for="address02">새로운 주소</label></span>
				</div>
				<table style="width:100%;">
					<caption>배송지의 이름, 휴대폰, 주소 정보</caption>
					<tbody>
					<tr>
						<th scope="row" style="width:24%;"><label for="username">이름</label></th>
						<td style="width:76%;"><input type="text" maxlength="10" id="username" value="<% if myname<>"" then response.write myname else response.write oUserInfo.FOneItem.FUserName end if %>" name="reqname" /></td>
					</tr>
					<tr>
						<th scope="row">휴대폰</th>
						<td>
							<div class="group">
								<span><input type="text" title="휴대폰번호 앞자리" maxlength="3" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",0) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) end if %>" name="reqhp1" id="reqhp1"/></span><i>-</i>
								<span><input type="text" title="휴대폰번호 가운데 자리" maxlength="4" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",1) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) end if %>" name="reqhp2" id="reqhp2"/></span><i>-</i>
								<span><input type="text" title="휴대폰번호 뒷자리" maxlength="4" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",2) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) end if %>" name="reqhp3" id="reqhp3"/></span>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td>
							<div class="group">
								<span style="width:60%;"><input type="text" title="우편번호" value="<% if myzipcode <>"" then response.write myzipcode else response.write oUserInfo.FOneItem.FZipCode end if %>" name="txZip" id="txZip" ReadOnly /></span>
								<a href="" class="btnFind" <% If isapp <> "1" Then %>onclick="fnOpenModal('/lib/pop_searchzipnew.asp?target=frmorder&gb=3'); return false;"<% Else %>onclick="TnFindZipNew('frmorder','1'); return false;"<% End If %>><span>찾기</span></a>
							</div>
							<input type="text" title="기본주소" name="txAddr1" maxlength="100" value="<% if myaddr1 <>"" then response.write myaddr1 else response.write doubleQuote(oUserInfo.FOneItem.FAddress1) end if %>" ReadOnly style="margin-top:0.5rem;" />
							<input type="text" title="상세주소" name="txAddr2" maxlength="100" value="<% if myaddr2 <>"" then response.write myaddr2 else response.write doubleQuote(oUserInfo.FOneItem.FAddress2) end if %>" style="margin-top:0.5rem;" />
						</td>
					</tr>
					</tbody>
				</table>
				<ul>
					<li>위 주소는 기본 회원 정보 주소이며, 새로 입력하신 주소로 기본 회원 정보가 변경됩니다.</li>
					<li><span class="cRd1V16a">[신청 완료]를 클릭하셔야 신청이 완료</span>되며,<br />완료된 후에는 주소를 변경하실 수 없습니다.</li>
					<li>수집된 개인 정보는 상품 발송을 위해서만 사용됩니다.</li>
				</ul>
				<% if mycnt > 0 then %>
					<button type="button" onclick="fnitsm('inst','edit','<%= myaddridx %>'); return false;" class="btnSubmit btnRed2V16a">신청완료</button>
				<% else %>
					<button type="button" onclick="fnitsm('inst','add',''); return false;" class="btnSubmit btnRed2V16a">신청완료</button>
				<% end if %>
			</div>
		</form>
		<% End If %>
		</div>
		<!--// 인증번호, 배송지 입력 -->
		<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_process.png" alt="이벤트에 참여하려면? 01.하나은행 적금 가입하고 02.텐바이텐에서 신청!" /></div>
		<div class="producct">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_product_v2.png" alt="하나은행 이벤트 상품- 하나머니세상 적금,하나멤버스 주거래 우대 적금,행복 Together 적금,주택청약종합저축,오늘은 얼마니? 적금 중 1개를 선택하여 신청하실 수 있습니다." /></p>
			<a href="https://m.kebhana.com/cont/product/product02/index.jsp" class="mWeb" target="_blank">더 자세히 알아보기</a>
			<a href="https://m.kebhana.com/cont/product/product02/index.jsp" onclick="fnAPPpopupExternalBrowser('https://m.kebhana.com/cont/product/product02/index.jsp'); return false;" target="_blank" class="mApp">더 자세히 알아보기</a>
		</div>
		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<p class="count">무민 코인뱅크 잔여 수량 : <strong><%= CurrFormat(27946-allcnt) %>개</strong> / 30,000개</p>
			<ul>
				<li>본 이벤트는 총 3만 명을 대상으로 진행되며 (1인 1개 제공) 사전 공지 없이 종료될 수 있습니다.</li>
				<li>본 사은품은 특별 제작 상품으로 배송이 지연될 수 있습니다.</li>
				<li>무민 코인뱅크는 비매품으로 타 상품과 교환 및 환불되지 않습니다.</li>
				<li>배송받을 주소를 입력한 후 ‘신청완료’ 버튼을 클릭하셔야 코인뱅크 신청이 완료되며, 이후에는 배송지를 변경하실 수 없습니다.</li>
			</ul>
		</div>
		<!--<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/77767/m/txt_comment.png" alt="COMMENT EVENT - 텐바이텐과 콜라보레이션하면 좋을 것 같은 브랜드를 코멘트로 남겨주세요! 정성껏 댓글을 남겨주신 500분께 100마일리지를 드립니다." /></p>-->
	</div>
	<!--// 꽃을 든 무민 -->

<%
	Set oUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->
