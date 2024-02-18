<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<%
Response.AddHeader "Cache-Control","no-cache"
Response.AddHeader "Expires","0"
Response.AddHeader "Pragma","no-cache"
%>
<%
'####################################################
' Description : 마이텐바이텐 - 반품 완료페이지
' History : 2018.10.16 원승현 생성
'####################################################
%>
<!-- #include virtual="/apps/appcom/wish/web2014/login/checkUserGuestlogin.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbHelper.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #include virtual="/apps/appcom/wish/web2014/lib/util/pageformlib.asp" -->
<!-- #include virtual="/lib/classes/ordercls/sp_myordercls.asp" -->
<!-- #include virtual="/lib/classes/cscenter/cs_aslistcls.asp" -->
<%
'해더 타이틀
strHeadTitleName = "반품/환불"

Dim csAsId
csAsId  = requestCheckVar(request("CsAsId"),11)

Dim orderserial
orderserial = requestCheckVar(request("idx"),11)

dim userid
userid = getEncLoginUserID()

dim mycsdetail, iscanceled

set mycsdetail = new CCSASList
mycsdetail.FRectUserID = userid
mycsdetail.FRectCsAsID = CsAsID

if (CsAsID<>"") then
    ''mycsdetail.GetOneCSASMaster
    ''2015/07/15 수정.. 두번 쿼리?..
    if IsUserLoginOK() then
        mycsdetail.FRectUserID = getEncLoginUserID()
        mycsdetail.GetOneCSASMaster
    elseif IsGuestLoginOK() then
        mycsdetail.FRectOrderserial = GetGuestLoginOrderserial()
        mycsdetail.GetOneCSASMaster
    end if

    iscanceled = "N"
    if (mycsdetail.FResultCount < 1) then
    	iscanceled = "Y"
    end if
end if

dim mycsdetailitem
set mycsdetailitem = new CCSASList
mycsdetailitem.FRectUserID = userid
mycsdetailitem.FRectCsAsID = CsAsID
mycsdetailitem.FRectOrderserial = mycsdetail.FoneItem.ForderSerial
if (CsAsID<>"") then
	mycsdetailitem.GetCsDetailList
end if

dim returnmakerididx
returnmakerididx = 0

dim OReturnAddr, vIsPacked
vIsPacked = fnExistPojang(mycsdetail.FoneItem.ForderSerial,"")

dim isNaverPay
isNaverPay = (fnGetPgGubun(mycsdetail.FoneItem.Forderserial)="NP")

Dim beasongpaysum, itemcostsum, itemcount, itemtotalcount, packpaysum, i, detailDeliveryName, detailSongjangNo, detailDeliveryTel
beasongpaysum = 0
itemcostsum = 0
itemcount = 0
itemtotalcount = 0
packpaysum = 0

if mycsdetailitem.FResultCount > 0 then
    for i=0 to mycsdetailitem.FResultCount-1
        if mycsdetailitem.FItemList(i).Fitemid = 0 then
            beasongpaysum = beasongpaysum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
        elseif mycsdetailitem.FItemList(i).Fitemid = 100 then
            packpaysum = packpaysum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
        else
            itemcostsum = itemcostsum + mycsdetailitem.FItemList(i).FItemCost * mycsdetailitem.FItemList(i).Fconfirmitemno
            itemcount = itemcount + 1
            itemtotalcount = itemtotalcount + mycsdetailitem.FItemList(i).Fconfirmitemno
            returnmakerididx = i
            if Not IsNull(mycsdetailitem.FitemList(i).FsongjangNo) then
                detailDeliveryName	= mycsdetailitem.FitemList(i).FDeliveryName
                detailSongjangNo	= mycsdetailitem.FitemList(i).FsongjangNo
                detailDeliveryTel	= mycsdetailitem.FitemList(i).FDeliveryTel
            end if
        end if
    next
end if

%>
<!-- #include virtual="/apps/appCom/wish/web2014/lib/head.asp" -->
<meta name="format-detection" content="telephone=no" />
<title>10x10: 반품/환불</title>
<script type='text/javascript'>

function pop_ReturnInfo(){
	fnOpenModal("/my10x10/orderpopup/act_popReturnInfo.asp");
}
</script>
</head>
<body class="default-font body-sub body-1depth bg-grey">
	<form name="frmsearch" method="post" action="myorder_return_step1.asp" style="margin:0px;">
	<input type="hidden" name="page" value="1">
	</form>
	<div id="content" class="content">
		<div class="returnWrap">
            <div class="retFinMsg">
                <strong>반품 접수가 완료되었습니다.</strong>
                <% if mycsdetail.FOneItem.Fdivcd = "A004" then %>
                    <p class="tMar0-8r">택배사로 직접 연락 후, 업체로 상품을 보내주세요.</p>
                <% end if %>
                <% if mycsdetail.FOneItem.Fdivcd = "A010" then %>
                    <p class="tMar0-8r">반품하실 상품을, 받으신 상태로 포장해주세요.<br>택배기사님이 2~3일 후 방문 예정입니다.</p>
                <% end if %>
            </div>

			<ol class="returnStep">
				<li class="on"><em class="num">1</em>주문선택</li>
				<li class="on"><em class="num">2</em>상품선택</li>
				<li class="on"><em class="num">3</em>정보확인</li>
				<li class="on"><em class="num">4</em>접수완료</li>
			</ol>

            <% if mycsdetail.FOneItem.Fdivcd = "A004" then %>
				<div class="returnGrp showHideV16a">
					<div class="grpTitV16a tglBtnV16a">
						<h2>업체 배송상품 안내</h2>
					</div>
					<div class="tglContV16a">
						<div class="returnNoti2">
							<ul>
								<li>반품하실 상품은 <span class="cRd1V16a">[업체 개별 배송]</span> 상품으로, 반품 접수 후, <span class="cRd1V16a">직접 반품</span>을 해주셔야 합니다.</li>
								<li>택배 접수는 착불 반송으로 접수하시면 됩니다.</li>
							</ul>
						</div>
						<div class="grpCont">
							<dl class="infoArray">
								<dt>1) 반품 접수</dt>
								<dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
							</dl>
							<dl class="infoArray">
								<dt>2) 택배 발송</dt>
								<dd>해당 택배사로 직접 연락 후 업체로 상품을 보내주세요.</dd>
							</dl>
							<dl class="infoArray">
								<dt>3) 반품 진행</dt>
								<dd>택배 발송 후 [내가 신청한 서비스]에 보내신 송장번호를 입력하세요.</dd>
							</dl>
							<dl class="infoArray">
								<dt>4) 반품 완료</dt>
								<dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
							</dl>
						</div>
					</div>
				</div>
                <%
                    set OReturnAddr = new CCSReturnAddress
                    if mycsdetailitem.FItemList(returnmakerididx).Fisupchebeasong = "Y" then
                        if mycsdetailitem.FItemList(returnmakerididx).FMakerid <> "" then
                            OReturnAddr.FRectMakerid = mycsdetailitem.FItemList(returnmakerididx).FMakerid
                            OReturnAddr.GetReturnAddress
                        end if
                    end if
                %>
                <% if (OReturnAddr.FResultCount>0) then %>
                    <div class="returnGrp" id="grpReturn3">
                        <div class="grpTitV16a" style="border-top-color:#ff3131;">
                            <h2>택배사 / 반품 주소지</h2>
                        </div>
                        <div class="grpCont">
                            <dl class="infoArray">
                                <dt>택배사</dt>
                                <dd><%=detailDeliveryName%>&nbsp;<%=detailSongjangNo%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>택배사 대표번호</dt>
                                <dd><a href="tel:<%=detailDeliveryTel%>"><%=detailDeliveryTel%></a></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매 업체명</dt>
                                <dd><%=OReturnAddr.Freturnname%></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>판매업체 연락처</dt>
                                <dd><%= OReturnAddr.Freturnphone %></dd>
                            </dl>
                            <dl class="infoArray">
                                <dt>반품 주소지</dt>
                                <dd>[<%= OReturnAddr.Freturnzipcode %>] <%= OReturnAddr.Freturnzipaddr %> &nbsp;<%= OReturnAddr.Freturnetcaddr %></dd>
                            </dl>
                        </div>
                    </div>
                <% end if %>
            <% elseif mycsdetail.FOneItem.Fdivcd = "A010" then %>
				<div class="returnGrp showHideV16a">
					<div class="grpTitV16a tglBtnV16a">
						<h2>텐바이텐 배송상품 안내</h2>
					</div>
					<div class="tglContV16a">
						<div class="returnNoti2">
							<ul>
								<li>반품 접수를 하시면, <span class="cRd1V16a">택배 기사님이 2~3일 후 방문</span> 드립니다.</li>
							</ul>
						</div>
						<div class="grpCont">
							<dl class="infoArray">
								<dt>1) 반품 접수</dt>
								<dd>반품 신청 후, 반품하실 상품을 받으신 상태로 포장해주세요.</dd>
							</dl>
							<dl class="infoArray">
								<dt>2) 기사 방문</dt>
								<dd>반품 접수 후 2~3일 내에 택배 기사님이 방문하여 상품을 회수합니다.</dd>
							</dl>
							<dl class="infoArray">
								<dt>3) 반품 완료</dt>
								<dd>반품된 상품을 확인 후 결제 취소 또는 환불을 해드립니다.</dd>
							</dl>
						</div>
					</div>
				</div><!-- //returnGrp -->
            <% else %>

            <% end if %>

			<div class="inner10" style="padding:1.5rem 10px 0;">
				<div class="btnWrap">
					<p><span class="button btB1 btRed cWh1 w100p"><a href="" onclick="fnAPPpopupBrowserURL('내가 신청한 서비스','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/order/order_csdetail.asp?CsAsID=<%=CsAsID%>','right','','sc');return false;">확인</a></span></p>
                    <%' for dev msg : 확인 클릭시 주문건 상세로 이동 %>
				</div>
			</div>

            <div class="btn-return-list"><a href="" onclick="fnAPPpopupBrowserURL('내가 신청한 서비스','<%=wwwUrl%>/apps/appCom/wish/web2014/my10x10/order/order_cslist.asp','right','','sc'); return false;"><span>나의 반품 내역 보기</span></a></div>
		</div>
	</div>
    <!-- #include virtual="/apps/appCom/wish/web2014/lib/incFooter.asp" -->
</body>
</html>
<%
set mycsdetail = Nothing
set mycsdetailitem = Nothing
%>
<!-- #include virtual="/lib/db/dbclose.asp" -->