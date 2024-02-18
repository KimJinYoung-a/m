<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<%
'####################################################
' Description :  득템 찬스
' History : 2017-06-19 정태훈 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/classes/membercls/sp_userinfocls.asp" -->
<%
	Dim eCode, vQuery, vUserID, checkid
	dim mycnt, myname, mycell, myaddr1, myaddr2, mysongjang, myregdate, myaddridx, myzipcode
	mycnt = 0

	IF application("Svr_Info") = "Dev" THEN
		eCode		=  66326
	Else
		eCode		=  78559
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

	if vUserID <> "" Then
		'// 대상 체크 확인
		vQuery = "SELECT userid FROM [db_temp].[dbo].[tbl_event_etc_yongman] WHERE event_code='"& eCode &"' and isusing='Y' and userid='" &vUserID& "'"
		rsget.Open vQuery,dbget,1
		IF Not rsget.Eof Then
			checkid = rsget(0)
		End If
		rsget.close()


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
	end if
	
%>
<style type="text/css">
.mEvt78559 {position:relative;}
.addrLayer {position:absolute; left:0; top:0; width:100%; height:100%; padding-top:10rem; background-color:rgba(0,0,0,.5); z-index:1000;}
.addrLayer .layerCont {width:87.5%; margin:0 auto; padding:4rem 2.5rem; background-color:#fff;}
.addrLayer h3 {padding-bottom:2.5rem; text-align:center; font-size:1.5rem; font-weight:bold;}
.addrLayer .selectOption span {display:inline-block; width:45%;}
.addrLayer .selectOption input {margin-right:0.5rem; border-radius:50%; vertical-align:top;}
.addrLayer .selectOption label {color:#666; font-size:1.1rem; line-height:1.75em; vertical-align:middle;}
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
.addrLayer li:after {content:''; display:inline-block; position:absolute; left:0; top:0.42rem; width:0.25rem; height:0.25rem; background-color:#777; border-radius:50%;}
.addrLayer .btnSubmit {display:block; width:16.5rem; height:4rem; margin:1.8rem auto 0; font-size:1.5rem; font-weight:bold; background-color:#d60000;}
.noti {padding:3.5rem 6.875%; color:#3e3e3e; background-color:#f0f0f0;}
.noti h3 {padding-bottom:1rem; font-size:1.5rem; font-weight:bold; color:#000;}
.noti li {position:relative; margin-top:0.5rem; padding-left:1.1rem; font-size:1.1rem; line-height:1.4;}
.noti li:after {content:''; display:inline-block; position:absolute; left:0; top:0.5rem; width:0.35rem; height:0.35rem; background-color:#8e8e8e; border-radius:50%;}
</style>
<script type="text/javascript">
$(function(){
	$(".itemView").hide();

	// 신청버튼클릭
	$(".addrLayer").hide();
	$(".btnGet").click(function(){
		$(".addrLayer").show();
		window.parent.$('html,body').animate({scrollTop:230},500);
	});
});
function fnCheckLogin(){
<% If not(IsUserLoginOK()) Then %>
	<% if isApp=1 then %>
		calllogin();
		return false;
	<% else %>
		jsChklogin_mobile('','<%=Server.URLencode(appUrlPath &"/event/eventmain.asp?eventid=" & eCode)%>');
		return false;
	<% end if %>
<% else %>
	<% if checkid ="" then %>
		alert("이벤트 참여 대상이 아닙니다.");
	<% else %>
		$(".bestItemIs").hide();
		$(".itemView").show();
	<% end if %>
<% end if %>
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

		var params = jQuery("#frmorder").serialize();
		var reStr;
		$.ajax({
			type: "POST",
			url:"/event/etc/doeventsubscript/doEventSubscript78559.asp",
			data: params,
			dataType: "text",
			async: false,
	        success: function (str) {
				//alert(str);
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
					}else{
						alert('오류가 발생했습니다.');
						return false;
					}
				}else{
					errorMsg = reStr[1].replace(">?n", "\n");
					alert(errorMsg);
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
</script>
<!-- 이벤트 배너 등록 영역 -->
<div class="evtCont">

	<!-- 득템찬스 -->
	<div class="mEvt78559">
		<h2><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/tit_chance.png" alt="득템찬스 - 지금 로그인만 하면 HOT 아이템이 배송됩니다!" /></h2>
		<!-- 확인하기 -->
		<div class="bestItemIs">
			<p><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/txt_item.png" alt="한번 쓰면 종류별로 다 사게 된다는 텐바이텐 효자 아이템은?" /></p>
			<button type="button" class="btnView" onclick="fnCheckLogin()"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/btn_confirm.png" alt="확인하기" /></button>
		</div>
		<!-- 사은품 받기 -->
		<div class="itemView">
			<div><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/img_item.jpg" alt="월화수목금토일 매일매일 골라쓰는 데일리 칫솔" /></div>
			<% If allcnt >= 1500 Then %>
			<button type="button" onclick="javascript:alert('선착순 신청이 마감되었습니다.');"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/btn_get.png" alt="사은품 받기" /></button>
			<% Else %>
			<button type="button" class="btnGet"><img src="http://webimage.10x10.co.kr/eventIMG/2017/78559/m/btn_get.png" alt="사은품 받기" /></button>
			<% End If %>
		</div>
		<!-- 배송지 입력 -->
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
		<div id="addrLayer" class="addrLayer">
			<div class="layerCont">
				<h3>배송받을 주소를 입력해주세요!</h3>
				<div class="selectOption">
					<span><input type="radio" id="address01" name="addr" value="1" onclick="chgaddr('R');" checked /><label for="address01">기본 주소</label></span>
					<span><input type="radio" id="address02" name="addr" value="2" onclick="chgaddr('N');" /><label for="address02">새로 입력</label></span>
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
								<span><input type="text" title="휴대폰번호 앞자리" maxlength="3" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",0) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",0) end if %>" name="reqhp1" id="reqhp1" /></span><i>-</i>
								<span><input type="text" title="휴대폰번호 가운데 자리" maxlength="4" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",1) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",1) end if %>" name="reqhp2" id="reqhp2" /></span><i>-</i>
								<span><input type="text" title="휴대폰번호 뒷자리" maxlength="4" value="<% if mycell<>"" then response.write Splitvalue(mycell,"-",2) else response.write Splitvalue(oUserInfo.FOneItem.Fusercell,"-",2) end if %>" name="reqhp3" id="reqhp3" /></span>
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
					<li>기본 회원 정보 주소를 불러오며 수정이 가능합니다.</li>
					<li>신청 완료 후 주소를 변경 할 수 없습니다.</li>
					<li>입력된 주소는 개인정보에 반영됩니다.</li>
				</ul>
				<% if mycnt > 0 then %>
				<button type="button" onclick="fnitsm('inst','edit','<%= myaddridx %>'); return false;" class="btnSubmit btnRed2V16a">사은품 신청완료</button>
				<% else %>
				<button type="button" onclick="fnitsm('inst','add',''); return false;" class="btnSubmit btnRed2V16a">사은품 신청완료</button>
				<% end if %>
			</div>
		</form>
		</div>
		<% end if %>
		<div class="noti">
			<h3>이벤트 유의사항</h3>
			<ul>
				<li>텐바이텐 휴면 정책에 따라 2016년 7월 이후 로그인이 없는 고객 대상으로 진행되는 이벤트입니다.</li>
				<li>사은품은 1천개 한정수량으로 조기 마감될 수 있습니다.</li>
				<li>사은품 신청 후에는 주소 변경이 불가합니다.</li>
				<li>사은품은 6월 27일부터 배송될 예정입니다.</li>
				<li>이벤트는 조기 종료 될 수 있습니다.</li>
			</ul>
		</div>
	</div>
	<!--// 득템찬스 -->

</div>
<%
	Set oUserInfo = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->