<%@ codepage="65001" language="VBScript" %>
<% option Explicit %>
<!-- #include virtual="/lib/util/commlib.asp" -->
<%
response.charset = "utf-8"
Dim sFolder, mainFile
Dim fso, sMainXmlUrl, oFile, fileCont
Dim xmlDOM, CtrlDate
Dim mainIdx, mainTitle, mainTitleYn, mainUseTime, mainIconCd, mainExtCd, mainModiDate, mainSdt, mainEdt, mainPreOpen, selFullTime, strTime
Dim selDate
Dim itemid , itemname ,  sellcash , orgPrice ,  makerid , brandname , sellyn , saleyn , limityn , limitno , limitsold 
Dim couponYn , couponvalue , coupontype , imagebasic , itemdiv , ldv , label , templdv
Dim gaParam : gaParam = "&gaparam=todaymain_B"

selDate = replace(date,"-","")

sFolder = "/chtml/main/xml/chance/" & Replace(Date(),"-","") &"/"
CtrlDate = Date()
mainFile = "sub_chance.xml"

if (application("Svr_Info")="137" or application("Svr_Info")="082" or application("Svr_Info")="Dev") then
	Set fso = CreateObject("Scripting.FileSystemObject")
	if not(fso.FileExists(server.MapPath(sFolder & "sub_chance.xml"))) or dateDiff("h",Application("chk_main_chance_update"),now())>0 then
		if selDate=replace(date,"-","") then
			Server.Execute("/chtml/make_main_chance.asp")
			Application("chk_main_chance_update")=now
		end if
	end if
	set fso = Nothing
end If

on Error Resume Next
fileCont = ""
'서브 파일 로드
sMainXmlUrl = server.MapPath(sFolder & mainFile)	'// 접수 파일
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
on Error Goto 0

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
	<section class="chanceV15">
		<h2><span>CHANCE</span></h2>
		<p class="fs12 cGy2 tMar05">오직 하루만 진행하는 투데이 찬스!</p>
<%
	
	Dim i : i = 0
	For each tplNodes in cTmpl

		itemid			= tplNodes.getElementsByTagName("itemid").item(0).text
		itemname		= tplNodes.getElementsByTagName("itemname").item(0).text
		sellcash		= tplNodes.getElementsByTagName("sellcash").item(0).text
		orgPrice		= tplNodes.getElementsByTagName("orgPrice").item(0).text
		makerid			= tplNodes.getElementsByTagName("makerid").item(0).text
		brandname		= tplNodes.getElementsByTagName("brandname").item(0).text
		sellyn			= tplNodes.getElementsByTagName("sellyn").item(0).text
		saleyn			= tplNodes.getElementsByTagName("saleyn").item(0).text
		limityn			= tplNodes.getElementsByTagName("limityn").item(0).text
		limitno			= tplNodes.getElementsByTagName("limitno").item(0).text
		limitsold		= tplNodes.getElementsByTagName("limitsold").item(0).text
		couponYn		= tplNodes.getElementsByTagName("itemcouponyn").item(0).text
		couponvalue		= tplNodes.getElementsByTagName("ItemCouponvalue").item(0).text
		coupontype		= tplNodes.getElementsByTagName("itemcoupontype").item(0).text
		imagebasic		= tplNodes.getElementsByTagName("imagebasic").item(0).text
		itemdiv			= tplNodes.getElementsByTagName("itemdiv").item(0).text
		ldv				= tplNodes.getElementsByTagName("ldv").item(0).text
		label			= tplNodes.getElementsByTagName("label").item(0).text
		templdv			= tplNodes.getElementsByTagName("templdv").item(0).Text

		If label <> "5" Then '//today가 아닌것
%>
		<div id="view<%=i+1%>" style="display:none" class="chancePdt">
			<p class="timeLimit"><span><%=cInt(datediff("h", now() , Date()+1))%>시간 남음</span></p>
			<a href="" onclick="fnAPPpopupProduct_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/category/category_itemPrd.asp?itemid=<%=itemid%>&ldv=<%=templdv%><%=gaParam%>');return false;">
				<div class="pPhoto"><p><span><em>품절</em></span></p><img src="<%=imagebasic%>" alt="<%=itemname%>" /></div>
				<div class="pdtCont">
					<p class="pName">[<%=brandname%>] <%=itemname%></p>
					<% IF saleyn = "Y" or couponYn = "Y" Then %>
						<% IF (saleyn="Y") and (OrgPrice-SellCash>0) THEN %>
						<p class="pPrice"><%=FormatNumber(SellCash,0)%> 원
							<span class="cRd1">
							<%
								If OrgPrice = 0 Then
									Response.Write "[0%] "
								Else
									Response.Write "[" & CLng((OrgPrice-SellCash)/OrgPrice*100) & "%]"
								End If
							%>
							</span>
						</p>
						<% end if %>
						<% if couponYn = "Y" Then %>
						<p class="pPrice">
							<%If coupontype = "1" Then
								response.write formatNumber(sellCash - CLng(couponvalue*sellCash/100),0)
							ElseIf coupontype = "2" Then
								response.write formatNumber(sellCash - couponvalue,0)
							ElseIf coupontype = "3" Then
								response.write formatNumber(sellCash,0)
							Else
								response.write formatNumber(sellCash,0)
							End If%>원 <span class="cGr1">[<%If coupontype = "1" Then
								response.write CStr(couponvalue) & "%"
							ElseIf coupontype = "2" Then
								response.write formatNumber(couponvalue,0) & "원 할인"
							ElseIf coupontype = "3" Then
								response.write "무료배송"
							Else
								response.write couponvalue
							End If %>]</span>
						</p>
						<% end if %>
					<% Else %>
						<p class="pPrice"><%=formatNumber(orgPrice,0)%>원</p>
					<% End If %>
				</div>
			</a>
			<a href="javascript:chancechgimg('<%=i+1%>');" class="btnRefresh"><img src="http://fiximage.10x10.co.kr/m/2015/today/btn_refresh.png" alt="refresh" /></a>
			<a href="#" class="btnMore" onclick="fnAPPpopupChance_URL('http://m.10x10.co.kr/apps/appCom/wish/web2014/chance/index.asp?gaparam=todaymain_B');return false;"><span>찬스! 더보기</span></a>
		</div>
<%
		i = i + 1
		End If 
	Next
	Set cTmpl = Nothing
%>
	</section>
<%
End If
'//랜덤 view
Dim renview

randomize
renview=int(Rnd*i)+1

%>
<script>
$(function(){
	$("#view<%=renview%>").css("display","block");
});

//'새로고침 
function getRandomInt(j){
	return Math.floor(Math.random()*100)%j;
}

function chancechgimg(v){
	var rndno = new Array(1,2,3,4,5,6,7,8,9);
	var arr_length = rndno.length;

	count = getRandomInt(arr_length);

	if (count == v || count == 0)
	{
		rndno[count] = rndno[arr_length--];
		chancechgimg(v);
	}else{
		$("#view"+v).css("display","none");
		$("#view"+count).css("display","block");
	}

}
</script>