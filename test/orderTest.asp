<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Test</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Popper JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <style>
        .card-area {margin: 80px 0px 0px 20px;}
        .card-area .card {display: inline-block;width: 140px;margin: 8px;}
        .card-area .card h4 {font-size: 1rem;}
        .card-area .card .card-text {font-size: 0.7rem;min-height: 70px;}
        .card-area .card .btn {padding: .175rem .35rem;font-size: 0.7rem;}
        .alert {margin: 80px 15px 15px 15px;width: 95%;}
        .alert strong {display: inline-block;width: 90px;}
        .input-group {margin: 15px;width: 95%;}
        .input-group-prepend {width: 150px;}
        .input-group-prepend .input-group-text {min-width: 100%;font-size: 0.9rem;font-weight: bold;}
        .input-group-prepend .input-group-text.info {background: #0072B5;color: white;}
        .form-control {font-size: 0.9rem;}
        span.form-control {background: #9BB7D4;color: black;}
    </style>
</head>
<body>
<!-- #include virtual="/login/checkBaguniLogin.asp" -->
<!-- #include virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #include virtual="/lib/db/dbhelper.asp" -->
<!-- #include virtual="/lib/classes/ordercls/shoppingbagDBcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_couponcls.asp" -->
<!-- #include virtual="/lib/classes/shopping/sp_itemcouponcls.asp" -->
<%
    Class TestClass
        Public FItemCouponCount '// 상품쿠폰 갯수
        Public FItemCouponList() '// 상품쿠폰 리스트
        Public FBonusCouponCount '// 보너스쿠폰 갯수
        Public FBonusCouponList() '// 보너스쿠폰 리스트

        Private Sub Class_Initialize()
            redim FItemCouponList(0)
            redim FBonusCouponList(0)
        End Sub
        Private Sub Class_Terminate()
        End Sub

        '// 상품쿠폰 리스트 조회
        Function getItemCouponList()
            dim sqlStr, i
            sqlStr = " SELECT DISTINCT top 100 c.itemcouponidx, c.userid, c.couponidx, c.issuedno "
            sqlStr = sqlStr + " , c.itemcoupontype, c.itemcouponvalue, c.itemcouponstartdate "
            sqlStr = sqlStr + " , c.itemcouponexpiredate, c.itemcouponname, c.itemcouponimage "
            sqlStr = sqlStr + " , c.regdate, c.usedyn, c.orderserial "
            sqlStr = sqlStr + " , ISNULL(STUFF(( "
            sqlStr = sqlStr + "     SELECT ',' + CAST(d.itemid as VARCHAR(10)) "
            sqlStr = sqlStr + "     FROM db_item.dbo.tbl_item_coupon_detail d "
            sqlStr = sqlStr + "     WHERE d.itemcouponidx = c.itemcouponidx FOR XML PATH('') "
            sqlStr = sqlStr + " ),1,1,''),'') as itemidList "
            sqlStr = sqlStr + " FROM [db_item].[dbo].tbl_user_item_coupon c "
            sqlStr = sqlStr + " WHERE c.userid='" + GetLoginUserID + "'"
            ' sqlStr = sqlStr + " AND Exists("
            ' sqlStr = sqlStr + "     SELECT 1 FROM db_my10x10.dbo.tbl_my_baguni b "
            ' sqlStr = sqlStr + "     JOIN [db_item].[dbo].tbl_item_coupon_detail d on b.itemid=d.itemid "
            ' sqlStr = sqlStr + "         AND d.itemcouponidx=c.itemcouponidx "
            ' sqlStr = sqlStr + "     WHERE b.isLoginUser='Y'  and b.userKey='" + GetLoginUserID + "'"
            ' sqlStr = sqlStr + " ) "
            sqlStr = sqlStr + " ORDER BY c.itemcoupontype asc, c.itemcouponvalue desc, c.couponidx DESC "

            rsget.Open sqlStr, dbget, 1

            FItemCouponCount  = rsget.RecordCount

            ReDim FItemCouponList(FItemCouponCount)

            if not rsget.Eof then
                do until rsget.eof
                    set FItemCouponList(i) = new CUserItemCouponItem
                    FItemCouponList(i).Fcouponidx           = rsget("couponidx")
                    FItemCouponList(i).Fuserid              = rsget("userid")
                    FItemCouponList(i).Fitemcouponidx       = rsget("itemcouponidx")
                    FItemCouponList(i).Fissuedno            = rsget("issuedno")
                    FItemCouponList(i).Fitemcoupontype      = rsget("itemcoupontype")
                    FItemCouponList(i).Fitemcouponvalue     = rsget("itemcouponvalue")
                    FItemCouponList(i).Fitemcouponstartdate = rsget("itemcouponstartdate")
                    FItemCouponList(i).Fitemcouponexpiredate= rsget("itemcouponexpiredate")
                    FItemCouponList(i).Fitemcouponname      = db2html(rsget("itemcouponname"))
                    FItemCouponList(i).Fitemcouponimage     = rsget("itemcouponimage")
                    FItemCouponList(i).Fregdate             = rsget("regdate")
                    FItemCouponList(i).Fusedyn              = rsget("usedyn")
                    FItemCouponList(i).Forderserial         = rsget("orderserial")
                    FItemCouponList(i).FitemidList         = rsget("itemidList")

                    i=i+1
                    rsget.moveNext
                loop
            end if
            rsget.close
        End Function

        '// 보너스쿠폰 리스트 조회
        Function getBonusCouponList()
            dim sqlStr, i
            sqlStr = " SELECT top 100 * "
            sqlStr = sqlStr + " , (CASE WHEN targetcpntype='C' THEN db_item.[dbo].[getCateCodeFullDepthName](targetCpnSource) ELSE NULL end ) targetcatename "
            sqlStr = sqlStr + " , (CASE WHEN targetcpntype='B' THEN (select socname from db_user.[dbo].tbl_user_c where userid=targetCpnSource) ELSE NULL end ) targetbrandname "
            sqlStr = sqlStr + " FROM [db_user].[dbo].tbl_user_coupon "
            sqlStr = sqlStr + " where userid='" + GetLoginUserID + "'"
            ' sqlStr = sqlStr + " and deleteyn = 'N'"
            ' sqlStr = sqlStr + " and startdate <= getdate()"
            ' sqlStr = sqlStr + " and expiredate >= getdate()"
            ' sqlStr = sqlStr + " and isusing = 'N'"
            sqlStr = sqlStr + " and notvalid10x10 = 'N'"
            sqlStr = sqlStr + " order by idx DESC"

            rsget.Open sqlStr, dbget, 1

            FBonusCouponCount  = rsget.RecordCount

            ReDim FBonusCouponList(FBonusCouponCount)

            if  Not rsget.EOF  then
                i = 0
                do until rsget.eof
                    set FBonusCouponList(i) = new CCouponItem
                    FBonusCouponList(i).Fidx         = rsget("idx")
                    FBonusCouponList(i).fmasteridx   = rsget("masteridx")
                    FBonusCouponList(i).Fuserid      = rsget("userid")
                    FBonusCouponList(i).Fcoupontype  = rsget("coupontype")
                    FBonusCouponList(i).Fcouponvalue = rsget("couponvalue")
                    FBonusCouponList(i).Fcouponname  = db2html(rsget("couponname"))
                    FBonusCouponList(i).Fcouponimage = "http://www.10x10.co.kr/my10x10/images/" + rsget("couponimage")
                    FBonusCouponList(i).Fregdate     = rsget("regdate")
                    FBonusCouponList(i).Fstartdate   = rsget("startdate")
                    FBonusCouponList(i).Fexpiredate  = rsget("expiredate")
                    FBonusCouponList(i).Fisusing     = rsget("isusing")
                    FBonusCouponList(i).Fdeleteyn    = rsget("deleteyn")

                    FBonusCouponList(i).Fminbuyprice = rsget("minbuyprice")
                    FBonusCouponList(i).Ftargetitemlist = rsget("targetitemlist")
                    FBonusCouponList(i).Fcouponmeaipprice = rsget("couponmeaipprice")
                    FBonusCouponList(i).Fvalidsitename = rsget("validsitename")

                    ''2018/01/22 추가됨.
                    FBonusCouponList(i).Ftargetcpntype     = rsget("targetcpntype")
                    FBonusCouponList(i).Ftargetcpnsource   = rsget("targetcpnsource")
                    FBonusCouponList(i).Ftargetcatename    = rsget("targetcatename")
                    FBonusCouponList(i).Ftargetbrandname   = db2html(rsget("targetbrandname"))

                    '// 2018 회원등급 개편 2018/07/24 mxCpnDiscount
                    FBonusCouponList(i).FmxCpnDiscount     = rsget("mxCpnDiscount")
                    if isNULL(FBonusCouponList(i).FmxCpnDiscount) then FBonusCouponList(i).FmxCpnDiscount=0

                    i=i+1
                    rsget.moveNext
                loop
            end if
            rsget.close
        End Function
    End Class

    If GetLoginUserID <> "dlwjseh" Then
        Response.Redirect "/"
    End If

    dim oshoppingbag
    set oshoppingbag = new CShoppingBag
        oshoppingbag.FRectUserID = GetLoginUserID
        oshoppingbag.FRectSessionID = GetGuestSessionKey
        oShoppingBag.FRectSiteName  = "10x10"
        oshoppingbag.GetShoppingBagDataDB_Checked

    ' 보너스 쿠폰 리스트
    Dim tc
    Set tc = new TestClass
    tc.getBonusCouponList()
    tc.getItemCouponList()

    'P_GOODS
    Dim vMobilePrdtnm
    vMobilePrdtnm = "test"
    If oshoppingbag.FShoppingBagItemCount > 1 Then
        vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,12,"Y") & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
        vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName & " 외" & oshoppingbag.FShoppingBagItemCount-1 & "건"
    Else
        vMobilePrdtnm = chrbyte(oshoppingbag.FItemList(0).FItemName,24,"Y")
        vMobilePrdtnm_tmp = oshoppingbag.FItemList(0).FItemName
    End IF

    vMobilePrdtnm = Replace(vMobilePrdtnm, chr(34), "")		'특수문자 "
    vMobilePrdtnm = Replace(vMobilePrdtnm, chr(39), "")		' 특수문자 '
    vMobilePrdtnm = replace(vMobilePrdtnm,"frame","")

    dim ii
    ii = 0
    Dim vItemCnt : vItemCnt = 0
%>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-top">
        <a class="navbar-brand" href="/">10x10</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div id="collapsibleNavbar" class="collapse navbar-collapse">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item"><a class="nav-link" href="/inipay/ShoppingBag.asp">장바구니</a></li>
                <li class="nav-item"><a class="nav-link" href="#buy">구매자</a></li>
                <li class="nav-item"><a class="nav-link" href="#delivery">배송지</a></li>
                <li class="nav-item"><a class="nav-link" href="#discount">할인</a></li>
                <li class="nav-item"><a class="nav-link" href="#pay">결제</a></li>
                <li class="nav-item"><a class="nav-link" href="#etc">기타</a></li>
            </ul>
            <button id="submitButton" class="btn btn-success my-2 my-sm-0" type="button">Submit</button>
        </div>
    </nav>
    <div class="card-area">
        <% For i=0 to oshoppingbag.FShoppingBagItemCount - 1 %>
            <div class="card" id="card_<%=oshoppingbag.FItemList(i).FItemID%>" data-id="<%=oshoppingbag.FItemList(i).FItemID%>"
                data-price="<%=oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa%>">
                <img class="card-img-top" src="<%= replace(oshoppingbag.FItemList(i).FImageList,"http://","https://") %>" alt="<%= replace(oshoppingbag.FItemList(i).FItemName,"""","") %>" style="width:100%">
                <div class="card-body">
                    <h4 class="card-title"><%= FormatNumber(oshoppingbag.FItemList(i).GetCouponAssignPrice*oshoppingbag.FItemList(i).FItemEa,0) %>원</h4>
                    <p class="card-text"><%= oshoppingbag.FItemList(i).FItemName %> | <%= oshoppingbag.FItemList(i).FItemEa %>개</p>
                    <a href="/category/category_itemPrd.asp?itemid=<%= oshoppingbag.FItemList(i).FItemID %>" target="_blank" class="btn btn-primary">See Product</a>
                </div>
            </div>
        <% Next %>
    </div>
    <form name="order" method="post">
        <!-- 구매자 -->
        <div id="buy">
            <div class="alert alert-warning">
                <strong>① 구매자</strong>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">주문자</span></div>
                <input type="text" name="buyname" value="이전도" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰1</span></div>
                <input type="text" name="buyhp1" value="010" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰2</span></div>
                <input type="text" name="buyhp2" value="4133" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰3</span></div>
                <input type="text" name="buyhp3" value="8327" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호1</span></div>
                <input type="text" name="buyphone1" value="010" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호2</span></div>
                <input type="text" name="buyphone2" value="4133" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호3</span></div>
                <input type="text" name="buyphone3" value="8327" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">이메일</span></div>
                <input type="text" name="buyemail" value="dlwjseh3@gmail.com" class="form-control">
            </div>
        </div>

        <!-- 배송지 -->
        <div id="delivery">
            <div class="alert alert-info">
                <strong>② 배송지</strong>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">받는사람</span></div>
                <input type="text" name="reqname" value="이전도" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">우편번호</span></div>
                <input type="text" name="txZip" value="01392" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">주소1</span></div>
                <input type="text" name="txAddr1" value="경기도 양주시 고덕로139번길 361-21 (덕계동, 현대아파트)" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">주소2</span></div>
                <input type="text" name="txAddr2" value="101동 1502호" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰1</span></div>
                <input type="text" name="reqhp1" value="010" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰2</span></div>
                <input type="text" name="reqhp2" value="4133" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">핸드폰3</span></div>
                <input type="text" name="reqhp3" value="8327" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호1</span></div>
                <input type="text" name="reqphone1" value="010" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호2</span></div>
                <input type="text" name="reqphone2" value="4133" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전화번호3</span></div>
                <input type="text" name="reqphone3" value="8327" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">요청사항</span></div>
                <input type="text" name="comment" value="배송 전 연락 바랍니다." class="form-control">
            </div>
        </div>

        <!-- 할인 -->
        <div id="discount">
            <div class="alert alert-danger">
                <strong>③ 할인</strong> - 마일리지, 쿠폰, 예치금 등
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">마일리지 금액</span></div>
                <input type="text" id="mileage" name="spendmileage" value="0" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">보너스쿠폰</span></div>
                <select id="bonusCouponList" class="form-control">
                    <option value="">보너스쿠폰 선택</option>
                    <% For i=0 to tc.FBonusCouponCount - 1 %>
                        <option value="<%=tc.FBonusCouponList(i).Fidx%>|<%=tc.FBonusCouponList(i).Fcouponvalue%>|<%=tc.FBonusCouponList(i).Fcoupontype%>"><%= tc.FBonusCouponList(i).Fcouponname %></option>
                    <% Next %>
                </select>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">보너스쿠폰 idx</span></div>
                <input type="text" name="sailcoupon" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">보너스쿠폰 금액</span></div>
                <input type="text" id="bonusCoupon" name="couponmoney" value="0" class="form-control">
            </div>
            <div class="input-group">
                <% For ii=0 to tc.FItemCouponCount - 1 %>
                    <div class="form-check-inline">
                        <label class="form-check-label">
                            <input type="checkbox" class="form-check-input itemCoupon" data-idx="<%= tc.FItemCouponList(ii).Fitemcouponidx %>"
                                data-type="<%= tc.FItemCouponList(ii).Fitemcoupontype %>" data-value="<%= tc.FItemCouponList(ii).Fitemcouponvalue %>"
                                data-itemid="<%=tc.FItemCouponList(ii).FitemidList%>">
                            <%= tc.FItemCouponList(ii).Fitemcouponname %>
                        </label>
                    </div>
                <% 
                if i mod 10 = 0 then
                    Response.Flush		' 버퍼리플래쉬
                end if
                
                Next 
                %>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">상품쿠폰 idxs</span></div>
                <input type="text" name="checkitemcouponlist" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">상품쿠폰 금액</span></div>
                <input type="text" id="itemCoupon" name="itemcouponmoney" value="0" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">예치금 금액</span></div>
                <input type="text" id="tenCash" name="spendtencash" value="0" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">기프트카드 금액</span></div>
                <input type="text" id="giftCard" name="spendgiftmoney" value="0" class="form-control">
            </div>
        </div>

        <!-- 결제 -->
        <div id="pay">
            <div class="alert alert-success">
                <strong>④ 결제</strong>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">P_GOODS</span></div>
                <input type="text" name="P_GOODS" value="<%= chrbyte(vMobilePrdtnm,8,"N") %>" class="form-control" readonly>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">결제방법</span></div>
                <input type="text" name="Tn_paymethod" value="100" class="form-control"
                    placeholder="100&110&190: 신용카드, 400: 모바일, 800: 카카오, 980: 토스, 차이: 990, 네이버:900, PAYCO: 950, 무통장:7, 0원:000">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text info">총 주문금액</span></div>
                <span class="form-control"><strong id="totalPrice"><%= oshoppingbag.GetTotalItemOrgPrice %></strong> 원</span>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text info">배송비</span></div>
                <span class="form-control"><strong id="deliveryPrice"><%= oshoppingbag.GetOrgBeasongPrice %></strong> 원</span>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text info">할인금액</span></div>
                <span class="form-control"><strong id="salePrice">0</strong> 원</span>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">결제금액</span></div>
                <input type="text" name="price" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">입금자명</span></div>
                <input type="text" name="acctname" class="form-control"
                    placeholder="무통장일 경우">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">입금 은행</span></div>
                <input type="text" name="acctno" class="form-control"
                    placeholder="11: 농협, 06:국민, 20:우리, 25:신한, 81:하나, 03:기업, 39:경남, 32:부산, 31:대구, 71:우체국, 07:수협">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">현금영수증 구분</span></div>
                <input type="text" name="useopt" value="0" class="form-control"
                    placeholder="0:소득공제용, 1:지출증빙용">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">현금영수증 추가정보</span></div>
                <input type="text" name="cashReceipt_ssn" class="form-control"
                    placeholder="사업자 번호 or 현금영수증 카드 번호 or 휴대폰 번호">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">환불 은행</span></div>
                <input type="text" name="rebankname" class="form-control" placeholder="ex) 신한">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">환불 계좌번호</span></div>
                <input type="text" name="encaccount" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">환불 예금주</span></div>
                <input type="text" name="rebankownername" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전자보증보험 연도</span></div>
                <input type="text" name="insureBdYYYY" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전자보증보험 월</span></div>
                <input type="text" name="insureBdMM" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전자보증보험 일</span></div>
                <input type="text" name="insureBdDD" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">전자보증보험 동의</span></div>
                <input type="text" name="agreeInsure" value="Y" class="form-control">
            </div>
        </div>

        <!-- 기타 -->
        <div id="etc">
            <div class="alert alert-dark">
                <strong>⑤ 기타</strong>
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyername</span></div>
                <input type="text" name="buyername" value="이전도" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyertel</span></div>
                <input type="text" name="buyertel" value="010-41338327" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyeremail</span></div>
                <input type="text" name="buyeremail" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">emsprice</span></div>
                <input type="text" name="emsprice" value="0" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">cardcode</span></div>
                <input type="text" name="cardcode" value="" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">ini_onlycardcode</span></div>
                <input type="text" name="ini_onlycardcode" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">cardquota</span></div>
                <input type="text" name="cardquota" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">rbankcode</span></div>
                <input type="text" name="rbankcode" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">reqsign</span></div>
                <input type="text" name="reqsign" value="DONE" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">gift_code</span></div>
                <input type="text" name="gift_code" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyZip</span></div>
                <input type="text" name="buyZip" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyAddr1</span></div>
                <input type="text" name="buyAddr1" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">buyAddr2</span></div>
                <input type="text" name="buyAddr2" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">fixprice</span></div>
                <input type="text" name="fixprice" value="21301" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">fixpriceTenItm</span></div>
                <input type="text" name="fixpriceTenItm" value="25060" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">ordersheetyn</span></div>
                <input type="text" name="ordersheetyn" value="Y" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">itemcouponOrsailcoupon</span></div>
                <input type="text" name="itemcouponOrsailcoupon" value="S" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">isCyberAcct</span></div>
                <input type="text" name="isCyberAcct" value="Y" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">CST_PLATFORM</span></div>
                <input type="text" name="CST_PLATFORM" value="<%= Chkiif(application("Svr_Info")="Dev", "test", "") %>" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">quotabase</span></div>
                <input type="text" name="quotabase" value="선택:일시불:2개월:3개월:4개월:5개월:6개월:7개월:8개월:9개월:10개월:11개월:12개월:18개월" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">sid</span></div>
                <input type="text" name="sid" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">ini_logoimage_url</span></div>
                <input type="text" name="ini_logoimage_url" value="/fiximage/web2008/shoppingbag/logo2004.gif" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">availitemcouponlist</span></div>
                <input type="text" name="availitemcouponlist" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">clickcontrol</span></div>
                <input type="text" name="clickcontrol" value="enable" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">encrypted</span></div>
                <input type="text" name="encrypted" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">sessionkey</span></div>
                <input type="text" name="sessionkey" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">giftkind_code</span></div>
                <input type="text" name="giftkind_code" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">rdDlvOpt</span></div>
                <input type="text" name="rdDlvOpt" value="P" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">mid</span></div>
                <input type="text" name="mid" value="teenxteen9" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">gopaymethod</span></div>
                <input type="text" name="gopaymethod" value="onlycard" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">quotainterest</span></div>
                <input type="text" name="quotainterest" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">paymethod</span></div>
                <input type="text" name="paymethod" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">version</span></div>
                <input type="text" name="version" value="4110" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">jumundiv</span></div>
                <input type="text" name="jumundiv" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">nointerest</span></div>
                <input type="text" name="nointerest" value="no" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">goodname</span></div>
                <input type="text" name="goodname" value="10x10상품" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">comment_etc</span></div>
                <input type="text" name="comment_etc" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">uid</span></div>
                <input type="text" name="uid" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">acceptmethod</span></div>
                <input type="text" name="acceptmethod" value="VERIFY:NOSELF" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">LGD_PAYKEY</span></div>
                <input type="text" name="LGD_PAYKEY" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">currency</span></div>
                <input type="text" name="currency" value="WON" class="form-control">
            </div>
            <div class="input-group">
                <div class="input-group-prepend"><span class="input-group-text">gift_kind_option</span></div>
                <input type="text" name="gift_kind_option" class="form-control">
            </div>
        </div>
    </form>

    <script>
        const frm = document.order;

        // 상품 배열
        const itemIdArr = [];
        document.querySelectorAll('.card').forEach(c => itemIdArr.push(c.dataset.id));

        // Input들 focus이동 편하게
        const inputArr = [];
        const tempInputArr = document.querySelectorAll('input[type=text]');
        for( let i=0 ; i<tempInputArr.length ; i++ ) {
            inputArr.push(tempInputArr[i]);
        }
        const moveInput = function(e) {
            const i = inputArr.indexOf(e.target);
            if( e.keyCode === 13 || e.keyCode === 40 ) {
                if( inputArr[i+1] !== undefined ) {
                    inputArr[i+1].focus();
                } else {
                    inputArr[0].focus();
                }
            } else if( e.keyCode === 38 ) {
                if( inputArr[i-1] !== undefined ) {
                    inputArr[i-1].focus();
                } else {
                    inputArr[inputArr.length - 1].focus();
                }
            }
        }
        inputArr.forEach(i => i.addEventListener('keydown', moveInput));

        // 할인 금액 계산
        const mileage = document.getElementById('mileage');
        const bonusCoupon = document.getElementById('bonusCoupon');
        const itemCoupon = document.getElementById('itemCoupon');
        const tenCash = document.getElementById('tenCash');
        const giftCard = document.getElementById('giftCard');
        const totalPrice = document.getElementById('totalPrice');
        const deliveryPrice = document.getElementById('deliveryPrice');
        const salePrice = document.getElementById('salePrice');
        const calculateSalePrice = function() {
            document.getElementById('salePrice').innerText = Number(mileage.value) + Number(bonusCoupon.value)
                + Number(itemCoupon.value) + Number(tenCash.value) + Number(giftCard.value);
        }

        // 결제금액 계산
        const calculatePayPrice = function() {
            calculateSalePrice();
            frm.price.value = Number(totalPrice.innerText) + Number(deliveryPrice.innerText) - Number(salePrice.innerText);
        }
        calculatePayPrice();

        // 보너스쿠폰 변경
        document.getElementById('bonusCouponList').addEventListener('change', e => {
            if( e.target.value === '' ) {
                frm.sailcoupon.value = '';
                frm.couponmoney.value = 0;
                calculatePayPrice();
                return;
            }

            const arr = e.target.value.split('|');
            const couponType = Number(arr[2]);
            let couponValue = Number(arr[1]);
            frm.sailcoupon.value = arr[0]; // 보너스쿠폰 idx

            if( couponType === 1 ) { // %
                couponValue = Math.round(Number(totalPrice.innerText)*(couponValue/100));
            }
            frm.couponmoney.value = couponValue; // 보너스쿠폰 금액
            calculatePayPrice();
        });
        // 상품쿠폰 변경
        const itemCouponCheckbox = document.querySelectorAll('.itemCoupon');
        // 상품쿠폰 할인금액 계산
        const calculateItemCouponPrice = function(el) {
            if( el.dataset.type === '1' ) { // %할인
                const thisItemIdArr = el.dataset.itemid === '' ? [] : el.dataset.itemid.split(',');
                let totalPrice = 0;

                thisItemIdArr.forEach(id => {
                    if( itemIdArr.indexOf(id) > -1 ) {
                        totalPrice += Number(document.getElementById('card_' + id).dataset.price);
                    }
                });
                return totalPrice * (el.dataset.value/100);
            } else {
                return Number(el.dataset.value);
            }
        }
        const checkItemCoupon = function(e) {
            const el = e.target;
            const currentItemCouponIdxs = frm.checkitemcouponlist.value === '' ? [] : frm.checkitemcouponlist.value.split(','); // 현재 선택한 쿠폰idx 리스트
            const discount = calculateItemCouponPrice(el);

            if( el.checked ) {
                currentItemCouponIdxs.push(el.dataset.idx);
                frm.itemcouponmoney.value = Number(frm.itemcouponmoney.value) + discount;
            } else {
                const indexOf = currentItemCouponIdxs.indexOf(el.dataset.idx);
                if( indexOf > -1 ) {
                    currentItemCouponIdxs.splice(indexOf, 1);
                }
                frm.itemcouponmoney.value = Number(frm.itemcouponmoney.value) - discount;
            }

            frm.checkitemcouponlist.value = currentItemCouponIdxs.join(',');
            calculatePayPrice();
        }
        itemCouponCheckbox.forEach(i => {
            i.addEventListener('click', checkItemCoupon);

            // 상품쿠폰 현재 상품 중에 상품이 있으면 강조 표시
            const thisItemIdArr = i.dataset.itemid === '' ? [] : i.dataset.itemid.split(',');
            let isExistItem = false;
            thisItemIdArr.forEach(id => {
                if( itemIdArr.indexOf(id) > -1 ) {
                    isExistItem = true;
                }
            });
            i.parentElement.style['font-weight'] = isExistItem ? 'bold' : '';
        });

        // 보너스쿠폰 금액 변경
        frm.couponmoney.addEventListener('blur', () => {calculatePayPrice();});
        // 상품쿠폰 금액 변경
        frm.itemcouponmoney.addEventListener('blur', () => {calculatePayPrice();});

        // 주문 실행
        document.getElementById('submitButton').addEventListener('click', e => {
            frm.action = '/inipay/card/ordertemp_ini.asp';
            frm.submit();
        });
    </script>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->