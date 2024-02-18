<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 오프라인 배송 주소 입력
' History : 2018.02.02 한용민 생성
'####################################################
%>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/lib/inc/head.asp" -->
<!-- #include virtual="/lib/classes/offshop/upchebeasong_cls.asp" -->

<%
dim orderNo, certNo, confirmcertno, shopid, dbCertNo, cjumunmaster, ExistsBeasongYN, regdate, ojumun, i
dim buyemail, reqname, reqzipcode, reqzipaddr, reqaddress, reqphone, reqhp, comment, shopname, UserHp, UserHp1, UserHp2, UserHp3
dim shopIpkumDivName, SmsYN, KakaoTalkYN, cbeasongmaster, buyemail1, buyemail2, reqphone1, reqphone2, reqphone3, reqhp1, reqhp2, reqhp3
	orderNo = requestcheckvar(getNumeric(request("orderNo")),16)
	certNo = requestcheckvar(request("certNo"),40)

if orderNo="" or isnull(orderNo) or certNo="" or isnull(certNo) then
	response.write "<script type='text/javascript'>"
	response.write "	alert('정상적인 인증 경로가 아닙니다[0].');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

' 인증코드 & 주문내역 조회
set cjumunmaster = new cupchebeasong_list
	cjumunmaster.frectorderNo = orderNo
	cjumunmaster.fshopjumun_master()

if cjumunmaster.ftotalcount < 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('존재하지 않는 주문 입니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

UserHp = cjumunmaster.FOneItem.fUserHp
	if UserHp<>"" then
		if instr(UserHp,"-") = 0 then
			UserHp1 = left(UserHp,3)
			UserHp2 = mid(UserHp,4,len(UserHp)-3-4)
			UserHp3 = right(UserHp,4)
		else
			UserHp1 = split(UserHp,"-")(0)
			UserHp2 = split(UserHp,"-")(1)
			UserHp3 = split(UserHp,"-")(2)
		end if
	end if
dbCertNo = cjumunmaster.FOneItem.fCertNo
shopid = cjumunmaster.FOneItem.fshopid
orderno = cjumunmaster.FOneItem.forderno
SmsYN = cjumunmaster.FOneItem.fSmsYN
KakaoTalkYN = cjumunmaster.FOneItem.fKakaoTalkYN
regdate = cjumunmaster.FOneItem.fregdate

if datediff("m",regdate,date()) >= 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('1달 이후 주문건은 조회가 불가능 합니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

confirmcertno = md5(trim(orderno) & dbCertNo & replace(trim(UserHp),"-",""))
'response.write certNo & "<Br>"
'response.write confirmcertno & "<Br>"

if trim(certNo) <> confirmcertno then
	response.write "<script type='text/javascript'>"
	response.write "	alert('인증된 코드값이 아닙니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

set cbeasongmaster = new cupchebeasong_list
	cbeasongmaster.frectorderno = orderNo
	cbeasongmaster.fshopjumun_edit()

if cbeasongmaster.ftotalcount < 1 then
	response.write "<script type='text/javascript'>"
	response.write "	alert('해당 주문건에 배송건이 존재 하지 않습니다.');"
	response.write "</script>"
	dbget.close()	:	response.End
end if

ExistsBeasongYN="Y"

buyemail = cbeasongmaster.FOneItem.fbuyemail
	if buyemail<>"" then
		buyemail1 = split(buyemail,"@")(0)
		buyemail2 = split(buyemail,"@")(1)
	end if
reqname = cbeasongmaster.FOneItem.freqname
reqzipcode = cbeasongmaster.FOneItem.freqzipcode
reqzipaddr = cbeasongmaster.FOneItem.freqzipaddr
reqaddress = cbeasongmaster.FOneItem.freqaddress
reqphone = cbeasongmaster.FOneItem.freqphone
	if reqphone<>"" then
		reqphone1 = split(reqphone,"-")(0)
		reqphone2 = split(reqphone,"-")(1)
		reqphone3 = split(reqphone,"-")(2)
	end if
reqhp = cbeasongmaster.FOneItem.freqhp
	if reqhp<>"" then
		if instr(reqhp,"-") = 0 then
			reqhp1 = left(reqhp,3)
				if reqhp1="" then reqhp1 = UserHp1
			reqhp2 = mid(reqhp,4,len(reqhp)-3-4)
				if reqhp2="" then reqhp2 = UserHp2
			reqhp3 = right(reqhp,4)
				if reqhp3="" then reqhp3 = UserHp3
		else
			reqhp1 = split(reqhp,"-")(0)
				if reqhp1="" then reqhp1 = UserHp1
			reqhp2 = split(reqhp,"-")(1)
				if reqhp2="" then reqhp2 = UserHp2
			reqhp3 = split(reqhp,"-")(2)
				if reqhp3="" then reqhp3 = UserHp3
		end if
	end if
comment = cbeasongmaster.FOneItem.fcomment
shopname = cbeasongmaster.FOneItem.fshopname
shopIpkumDivName = cbeasongmaster.FOneItem.shopIpkumDivName

set ojumun = new cupchebeasong_list
	ojumun.frectorderno = orderno
	ojumun.fshopbeasong_input()
%>

<style>
.txtOutput {min-height:36px; padding:12px 10px 0; font-size:13px; color:#888;}
.myOrderView .cartGroup .pdtWrap .pdtCont {min-height:7.51rem;}
.myOrderView .cartGroup div.pdtWrap div.pdtCont {padding-bottom:0;}
@media all and (min-width:480px){
	.txtOutput {min-height:54px; padding:18px 10px 0; font-size:20px;}
}
</style>
<script type="text/javascript">

// 폼전송
function frmsubmit(){
	if(frminfo.reqname.value==''){
		alert('받으시는분을 입력 하세요');
		frminfo.reqname.focus();
		return;
	}
	if (frminfo.reqhp1.value==''){
		alert('휴대전화 번호를 입력 하세요');
		frminfo.reqhp1.focus();
		return;
	}
	if (frminfo.reqhp2.value==''){
		alert('휴대전화 번호를 입력 하세요');
		frminfo.reqhp2.focus();
		return;
	}
	if (frminfo.reqhp3.value==''){
		alert('휴대전화 번호를 입력 하세요');
		frminfo.reqhp3.focus();
		return;
	}

	if(frminfo.txZip.value=="") {
		alert('우편번호를 입력하세요.');
		return;
	}
	if (frminfo.txAddr1.value==''){
		alert('주소를 입력 하세요');
		frminfo.txAddr1.focus();
		return;
	}
	/*
	if (frminfo.txAddr2.value==''){
		alert('주소를 입력 하세요');
		frminfo.txAddr2.focus();
		return;
	}
	*/

	frminfo.action='<%= M_SSLUrl %>/my10x10/order/myshoporder_process.asp';
	frminfo.submit();
}

</script>
</head>
</head>
<body class="default-font body-popup">
	<header class="tenten-header header-popup">
		<div class="title-wrap">
			<h1>주문 내역 확인</h1>
			<% '<button type="button" class="btn-close" onclick="">닫기</button> %>
		</div>
	</header>

	<!-- contents -->
	<div id="content" class="content">

		<form name="frminfo" method="post" style="margin:0px;">
		<input type="hidden" name="mode" value="addressedit">
		<input type="hidden" name="orderno" value="<%= orderNo %>">
		<input type="hidden" name="certNo" value="<%= certNo %>">

		<div class="userInfo userInfoEidt inner10">
			<fieldset>
			<legend>배송지 정보</legend>
				<dl class="infoInput">
					<dt><label for="receiver">주문매장</label></dt>
					<dd><div class="txtOutput default-font"><%=shopname%></div></dd>
				</dl>
				<dl class="infoInput">
					<dt><label for="receiver">주문번호</label></dt>
					<dd>
						<div class="txtOutput default-font"><%= orderNo %></div>
					</dd>
				</dl>
				<dl class="infoInput">
					<dt><label for="receiver">출고 상태</label></dt>
					<dd><div class="txtOutput default-font"><span class="color-red"><%= shopIpkumDivName %></span></div></dd>
				</dl>

				<%
				' 통보 이전 상태 라면
				if cbeasongmaster.FOneItem.fIpkumDiv < 5 then
				%>
					<dl class="infoInput">
						<dt><label for="receiver">*받으시는 분</label></dt>
						<dd><input type="text" id="receiver" maxlength=32 value="<%=reqname%>" name="reqname" style="width:100%;" /></dd>
					</dl>
					<dl class="infoInput">
						<dt>전화번호</dt>
						<dd>
							<p>
								<span><input type="number" title="전화번호 앞자리" name="reqphone1" value="<%=reqphone1%>" maxlength=4 class="ct" style="width:100%;" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span style="width:30%;"><input type="number" title="전화번호 가운데자리" name="reqphone2" value="<%=reqphone2%>" maxlength=4 class="ct" style="width:100%;" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span style="width:30%;"><input type="number" title="전화번호 뒷자리" name="reqphone3" value="<%=reqphone3%>" maxlength=4 class="ct" style="width:100%;" /></span>
							</p>
						</dd>
					</dl>
					<dl class="infoInput">
						<dt>*휴대전화</dt>
						<dd>
							<p>
								<span><input type="number" title="휴대전화 앞자리" name="reqhp1" value="<%= reqhp1 %>" maxlength=4 style="width:100%;" class="ct" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span style="width:30%;"><input type="number" title="휴대전화 가운데자리" name="reqhp2" value="<%= reqhp2 %>" maxlength=4 class="ct" style="width:100%;" /></span>
								<span>&nbsp;-&nbsp;</span>
								<span style="width:30%;"><input type="number" title="휴대전화 뒷자리" name="reqhp3" value="<%= reqhp3 %>" maxlength=4 class="ct" style="width:100%;" /></span>
							</p>
						</dd>
					</dl>
					<dl class="infoInput">
						<dt><label for="receiver">이메일</label></dt>
						<dd>
							<p>
								<span><input type="text" title="이메일 앞자리" name="buyemail1" value="<%= buyemail1 %>" maxlength="32" class="ct" style="width:100%;" /></span>
								<span>&nbsp;@&nbsp;</span>
								<span style="width:50%;"><input type="text" title="이메일 가운데자리" name="buyemail2" value="<%= buyemail2 %>" maxlength="80" class="ct" style="width:100%;" /></span>
							</p>
						</dd>
					</dl>
					<dl class="infoInput">
						<dt>*주소</dt>
						<dd>
							<p>
								<span style="width:25%;"><input type="text" title="우편번호" name="txZip" value="<%= reqzipcode %>" maxlength="5" readonly="readonly" class="ct" style="width:100%;" /></span>
								&nbsp;<span class="button btS1 btGry cBk1"><a href="" onclick="searchZipKakao('searchZipWrap','frminfo'); return false;">우편번호 찾기</a></span>
							</p>
							<p id="searchZipWrap" style="display:none;border:1px solid;width:100%;height:300px;margin:5px 0;position:relative">
								<img src="//fiximage.10x10.co.kr/m/2019/common/btn_delete.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-36px;z-index:1;width:35px;height:35px;" onclick="foldDaumPostcode('searchZipWrap')" alt="접기 버튼">
							</p>
							<style>
								.inp-box {display:block; padding:0.4rem 0.6rem; font-size:13px; color:#888; border-radius:0.2rem; border:1px solid #cbcbcb; width:100%;}
							</style>										
							<p class="tPad05">
								<textarea name="txAddr1" title="기본 주소" ReadOnly class="inp-box" ><%= reqzipaddr %></textarea>
							</p>							
							<p class="tPad05">
								<input type="text" name="txAddr2" value="<%= reqaddress %>" title="상세 주소" style="width:100%;" />
							</p>
						</dd>
					</dl>
					<dl class="infoInput">
						<dt><label for="notication">배송 메시지</label></dt>
						<dd><input type="text" id="notication" name="comment" value="<%= comment %>" style="width:100%;" /></dd>
					</dl>
					<div class="btnWrap">
						<span class="button btB1 btRed cWh1 w100p">
							<button type="button" onclick="frmsubmit(); return false;">
								<% if cbeasongmaster.FOneItem.fIpkumDiv < 2 then %>
									저장
								<% else %>
									수정
								<% end if %>
							</button>
						</span>
					</div>

				<%
				' 배송 통보후
				else
				%>
					<dl class="infoInput">
						<dt><label for="receiver">*받으시는 분</label></dt>
						<div class="txtOutput default-font"><%= reqname %></div>
					</dl>
					<dl class="infoInput">
						<dt>전화번호</dt>
						<div class="txtOutput default-font"><%= reqphone %></div>
					</dl>
					<dl class="infoInput">
						<dt>*휴대전화</dt>
						<div class="txtOutput default-font"><%= reqhp %></div>
					</dl>
					<dl class="infoInput">
						<dt><label for="receiver">이메일</label></dt>
						<div class="txtOutput default-font"><%= buyemail %></div>
					</dl>
					<dl class="infoInput">
						<dt>*주소</dt>
						<div class="txtOutput default-font">[<%= reqzipcode %>]&nbsp;<%= reqzipaddr %>&nbsp;<%= reqaddress %></div>
					</dl>
					<dl class="infoInput">
						<dt><label for="notication">배송 메시지</label></dt>
						<div class="txtOutput default-font"><%= nl2br(comment) %></div>
					</dl>
				<% end if %>
			</fieldset>
		</div>
		</form>

		<!-- 주문상품 -->
		<% if ojumun.FTotalCount>0 then %>
			<div class="myOrderView inner10">
				<div class="cartGroup">
					<div class="groupCont">
						<ul>
							<% for i=0 to ojumun.FTotalCount-1 %>
							<li>
								<div class="box3">
									<div class="pdtWrap">
										<div class="pPhoto">
											<% if ojumun.FItemList(i).FImageBasic<>"" and not isnull(ojumun.FItemList(i).FImageBasic) then %>
												<img src="<%=getThumbImgFromURL(ojumun.FItemList(i).FImageBasic,286,286,"true","false")%>" alt="<%= ojumun.FItemList(i).fitemname %>" />
											<% end if %>
										</div>
										<div class="pdtCont">
											<p class="pBrand">[<%= ojumun.FItemList(i).Fbrandname %>]</p>
											<p class="pName"><%= ojumun.FItemList(i).fitemname %></p>
											
											<% if ojumun.FItemList(i).fitemoptionname<>"" and not isnull(ojumun.FItemList(i).fitemoptionname) then %>
												<p class="pOption"><%= ojumun.FItemList(i).fitemoptionname %></p>
											<% end if %>
										</div>
									</div>
									<div class="pdtInfo">
										<dl class="pPrice">
											<dt>판매가</dt>
											<dd>
												<% if ojumun.FItemList(i).fsellprice < ojumun.FItemList(i).frealsellprice then %>
													<span><%= FormatNumber(ojumun.FItemList(i).fsellprice,0) %>원</span>
													<span class="cRd1 cpPrice"><%= FormatNumber(ojumun.FItemList(i).frealsellprice,0) %>원</span>
												<% else %>
													<span><%= FormatNumber(ojumun.FItemList(i).fsellprice,0) %>원</span>
												<% end if %>
											</dd>
										</dl>
										<dl class="pPrice">
											<dt>소계금액(<%= ojumun.FItemList(i).fitemno %>개)</dt>
											<dd>
												<% if ojumun.FItemList(i).fsellprice < ojumun.FItemList(i).frealsellprice then %>
													<span><%= FormatNumber(ojumun.FItemList(i).fsellprice*ojumun.FItemList(i).fitemno,0) %>원</span>
													<span class="cRd1 cpPrice"><%= FormatNumber(ojumun.FItemList(i).frealsellprice*ojumun.FItemList(i).fitemno,0) %>원</span>
												<% else %>
													<span><%= FormatNumber(ojumun.FItemList(i).fsellprice*ojumun.FItemList(i).fitemno,0) %>원</span>
												<% end if %>
											</dd>
										</dl>
										<dl class="pPrice">
											<dt>출고상태</dt>
											<dd><span class="cBk1"><%= ojumun.FItemList(i).shopNormalUpcheDeliverState %></span>
										</dd>
										</dl>

										<% if ojumun.FItemList(i).GetDeliveryName<>"" then %>
											<dl class="pPrice">
												<dt>택배정보</dt>
												<dd>
													<a href="<%= ojumun.FItemList(i).GetDeliveryName %><%= ojumun.FItemList(i).Fsongjangno %>" onfocus="this.blur()" target="_blink">
													<%= ojumun.FItemList(i).GetDeliveryName %> : <%= ojumun.FItemList(i).Fsongjangno %></a>
												</dd>
											</dl>
										<% end if %>
									</div>
								</div>
							</li>
							<% next %>
						</ul>
					</div>
				</div>
			</div>
		<% end if %>
	</div>
	<!-- //contents -->
	<form name="tranFrmApi" id="tranFrmApi" method="post">
		<input type="hidden" name="tzip" id="tzip">
		<input type="hidden" name="taddr1" id="taddr1">
		<input type="hidden" name="taddr2" id="taddr2">
		<input type="hidden" name="extraAddr" id="extraAddr">
	</form>
	<!-- #include virtual="/lib/inc/incFooter.asp" -->
</body>
</html>

<%
set cjumunmaster = nothing
set cbeasongmaster = nothing
set ojumun = nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->