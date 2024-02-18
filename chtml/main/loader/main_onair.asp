<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM
Dim gubun
Dim ctitle , cper , cnum
Dim image , itemname , itemid , startdate , enddate 
Dim cgubun , sellCash , orgPrice , sailYN , couponYn , couponvalue , LimitYn
Dim ndate , refip

gubun = requestCheckVar(request("gubun"),1)

refip = request.ServerVariables("HTTP_REFERER")

If Not(isNumeric(gubun)) then
	Call Alert_Return("잘못된 상품번호입니다.")
	response.End
End If 

if (InStr(refip,"10x10.co.kr")<1) then
	response.write "not valid Referer"
    response.end
end if

If hour(now) >=0 and hour(now) < 8 Then
	ndate = Replace(Date()-1,"-","")
Else
	ndate = Replace(Date(),"-","")		
End If 

sFolder = "/chtml/main/xml/onair/" & ndate &"/"
mainFile = "main_onair_"&gubun&".xml"

sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일

on Error Resume Next
Set oFile = CreateObject("ADODB.Stream")
With oFile
	.Charset = "UTF-8"
	.Type=2
	.mode=3
	.Open
	.loadfromfile sMainXmlUrl
	fileCont=.readtext
	.Close
End With
Set oFile = Nothing

If fileCont<>"" Then
	'// XML 파싱
	Set xmlDOM = Server.CreateObject("MSXML2.DomDocument.3.0")
	xmlDOM.async = False
	xmlDOM.LoadXML fileCont

	'// 하위 항목이 여러개일 때
	Dim cTmpl, tplNodes
	Set cTmpl = xmlDOM.getElementsByTagName("item")
	Set xmlDOM = Nothing

%>
	
	<script src="/lib/js/swiper-2.1.min.js"></script>
	<script>
	$(function() {
		mySwiper3= new Swiper('.swiper3',{
			loop:true,
			resizeReInit:true,
			calculateHeight:true
		});
		$('.goodsSwiper .arrow-left').on('click', function(e){
			e.preventDefault()
			mySwiper3.swipePrev()
		})
		$('.goodsSwiper .arrow-right').on('click', function(e){
			e.preventDefault()
			mySwiper3.swipeNext()
		})
	});
	</script>
	<script>
	<!--
	function jsDownCoupon(stype,idx){
	<% IF IsUserLoginOK THEN %>
	var frm;
		frm = document.frmC;
		//frm.target = "iframecoupon";
		frm.action = "/shoppingtoday/couponshop_process.asp";
		frm.stype.value = stype;
		frm.idx.value = idx;
		frm.submit();
	<%ELSE%>
		if(confirm("로그인하시겠습니까?")) {
			location.href="/login/login.asp?backpath=<%=Server.URLEncode(CurrURLQ())%>";
		}
	<%END IF%>
	}
	//-->
	</script>
	<form name="frmC" method="post">
	<input type="hidden" name="stype" value="">
	<input type="hidden" name="idx" value="">
	</form>
	<div class="themeGoods">
		<div class="goodsSwiper">
			<div class="swiper-container swiper3">
				<div class="swiper-wrapper">
<%
	For each tplNodes in cTmpl
		image				= tplNodes.getElementsByTagName("basicimage").item(0).text
		itemname			= tplNodes.getElementsByTagName("itemname").item(0).text
		itemid				= tplNodes.getElementsByTagName("itemid").item(0).text
		startdate			= CDate(replace(tplNodes.getElementsByTagName("startdate").item(0).text, ",", "-"))
		enddate			= CDate(replace(tplNodes.getElementsByTagName("enddate").item(0).text, ",", "-"))
		ctitle					= tplNodes.getElementsByTagName("ctitle").item(0).text
		cper					= tplNodes.getElementsByTagName("cper").item(0).text
		cnum				= tplNodes.getElementsByTagName("cnum").item(0).text

		cgubun				= tplNodes.getElementsByTagName("cgubun").item(0).text
		sellCash			= tplNodes.getElementsByTagName("sellCash").item(0).text
		orgPrice			= tplNodes.getElementsByTagName("orgPrice").item(0).text
		sailYN				= tplNodes.getElementsByTagName("sailYN").item(0).text
		couponYn			= tplNodes.getElementsByTagName("itemcouponYn").item(0).text
		couponvalue		= tplNodes.getElementsByTagName("itemcouponvalue").item(0).text
		LimitYn				= tplNodes.getElementsByTagName("LimitYn").item(0).text


%>
					<div class="swiper-slide">
						<a href="/category/category_itemPrd.asp?itemid=<%=itemid%>">
							<div class="thumbNail"><img src="<%=image%>" alt="<%=itemname%>" /></div>
							<strong class="name"><%=itemname%></strong>
							<% If (sailYN = "Y" Or couponYn = "Y" ) And couponvalue>0 then%>
							<span class="price"> <%=formatNumber(sellCash,0)%>원</span>
							<% Else %>
							<span class="price"> <%=formatNumber(orgPrice,0)%>원</span>
							<% End If %>
						</a>
					</div>
<%
	Next
%>
				</div>
			</div>
			<a class="btnArrow arrow-left" href="">이전</a>
			<a class="btnArrow arrow-right" href="">다음</a>
		</div>
		<% If ctitle <> "" And cper <> "" And cnum <>"" Then %>
		<div class="couponDown">
			<a href="javascript:<% If cgubun = "I" Then %>jsDownCoupon('prd','<%=cnum%>');<% Else %>jsDownCoupon('event','<%=cnum%>');<% End If %>">
				<span class="name">
					<span>DOWNLOAD</span>
					<strong><%=ctitle%></strong>
				</span>
				<strong class="rate"><%=cper%>% <img src="http://fiximage.10x10.co.kr/m/2013/common/btn_download.gif" alt="<%=ctitle%>"/></a></strong>
			</a>
		</div>
		<% End If %>
	</div>
<%
	Set cTmpl = Nothing
End If
on Error Goto 0
%>