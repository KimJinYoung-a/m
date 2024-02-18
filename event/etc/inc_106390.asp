<%@ codepage="65001" language="VBScript" %>
<% Option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<!-- #include virtual="/lib/util/md5.asp" -->
<!-- #include virtual="/lib/util/functions.asp" -->
<%
'####################################################
' Description : 19주년 브랜드 페이지
' History : 2020-10-07 원승현
'####################################################
dim currentDate
dim aType : aType = Request.Cookies("sale2020")("atype")
dim vDisp : vDisp = Request.Cookies("sale2020")("disp")
dim dateGubun : dateGubun = Request.Cookies("sale2020")("dategubun")
dim eCode, vQuery

currentDate = date()
if atype="" then atype="si"

IF application("Svr_Info") = "Dev" THEN
	eCode   =  103237
Else
	eCode   =  106390
End If
%>
<style>
.mEvt106390 {position:relative; overflow:hidden; background:#faeae1;}
.mEvt106390 .brand-wrap {position:relative; overflow:hidden; padding:0 3%;}
.mEvt106390 .brand-list {position:relative; display:flex; flex-wrap:wrap; margin-top:-.85rem;}
.mEvt106390 .brand-list::after {content:' '; display:block; clear:both;}
.mEvt106390 .brand-list li {width:33.3%; float:left; padding:0 1px; margin-top:.85rem;}
.mEvt106390 .brand-item {position:relative; text-align:center; border-top:2px solid #f7ccb4;}
.mEvt106390 .brand-item .per {font-family:'CoreSansCRegular', 'AppleSDGothicNeo-Medium', 'NotoSansKRMedium'; font-size:1.07rem; background:#ff694d; color:#fffdfa; padding:.35em 0 .3em;}
.mEvt106390 .brand-item a {display:block; position:absolute; left:0; top:0; width:100%; height:100%;}
.mEvt106390 .bot {margin-top:5rem;}
</style>
<script>
    $(function() {
        var brandCategory = [
            {
                cateName: 'design',
                brandInfo: [
                    <%
                        vQuery = "select makerid, socname, socname_kor, frontcategory, maxsalepercent, orderby "
                        vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_brandMaxSalePercent] WITH(NOLOCK) WHERE frontcategory='design' ORDER BY orderby"
                        rsget.CursorLocation = adUseClient
                        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
                        If Not(rsget.bof or rsget.eof) Then
                            Do Until rsget.eof
                    %>
                                <% If rsget("maxsalepercent") > 0 Then %>
                                    <% If Trim(rsget("socname_kor"))="드롱기" Then %>
                                        {
                                            brandName: '드롱기',
                                            brandId: 'ipcltd',
                                            imgName: 'ipcltd1',
                                            salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                        },
                                    <% ElseIf Trim(rsget("socname_kor"))="브라운" Then %>
                                        {
                                            brandName: '브라운',
                                            brandId: 'ipcltd',
                                            imgName: 'ipcltd2',
                                            salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                        },
                                    <% Else %>
                                        {
                                            brandName: '<%=rsget("socname_kor")%>',
                                            brandId: '<%=rsget("makerid")%>',
                                            salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                        },
                                    <% End If %>
                                <% End If %>
                    <%
                            rsget.movenext
                            Loop
                        End If
                        rsget.close
                    %>
                ]
            },
            {
                cateName: 'living',
                brandInfo: [
                    <%
                        vQuery = "select makerid, socname, socname_kor, frontcategory, maxsalepercent, orderby "
                        vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_brandMaxSalePercent] WITH(NOLOCK) WHERE frontcategory='living' ORDER BY orderby"
                        rsget.CursorLocation = adUseClient
                        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
                        If Not(rsget.bof or rsget.eof) Then
                            Do Until rsget.eof
                    %>
                                <% If rsget("maxsalepercent") > 0 Then %>                    
                                    {
                                        brandName: '<%=rsget("socname_kor")%>',
                                        brandId: '<%=rsget("makerid")%>',
                                        salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                    },
                                <% End If %>
                    <%
                            rsget.movenext
                            Loop
                        End If
                        rsget.close
                    %>
                ]
            },
            {
                cateName: 'life',
                brandInfo: [
                    <%
                        vQuery = "select makerid, socname, socname_kor, frontcategory, maxsalepercent, orderby "
                        vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_brandMaxSalePercent] WITH(NOLOCK) WHERE frontcategory='life' ORDER BY orderby"
                        rsget.CursorLocation = adUseClient
                        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
                        If Not(rsget.bof or rsget.eof) Then
                            Do Until rsget.eof
                    %>
                                <% If rsget("maxsalepercent") > 0 Then %>                                        
                                    {
                                        brandName: '<%=rsget("socname_kor")%>',
                                        brandId: '<%=rsget("makerid")%>',
                                        salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                    },
                                <% End If %>                                    
                    <%
                            rsget.movenext
                            Loop
                        End If
                        rsget.close
                    %>
                ]
            },
            {
                cateName: 'fashion',
                brandInfo: [
                    <%
                        vQuery = "select makerid, socname, socname_kor, frontcategory, maxsalepercent, orderby "
                        vQuery = vQuery & " FROM [db_temp].[dbo].[tbl_brandMaxSalePercent] WITH(NOLOCK) WHERE frontcategory='fashion' ORDER BY orderby"
                        rsget.CursorLocation = adUseClient
                        rsget.Open vQuery,dbget,adOpenForwardOnly,adLockReadOnly
                        If Not(rsget.bof or rsget.eof) Then
                            Do Until rsget.eof
                    %>
                                <% If rsget("maxsalepercent") > 0 Then %>                                                            
                                    {
                                        brandName: '<%=rsget("socname_kor")%>',
                                        brandId: '<%=rsget("makerid")%>',
                                        salePer: <%=Formatnumber(rsget("maxsalepercent"),0)%>
                                    },
                                <% End If %>                                                                        
                    <%
                            rsget.movenext
                            Loop
                        End If
                        rsget.close
                    %>
                ]
            },
        ];
        function renderBrands() {
            brandCategory.forEach(function(cate, i) {
                var $rootEl = $("#"+cate.cateName);
                var itemEle = tmpEl = ""
                $rootEl.empty();
                cate.brandInfo.forEach(function(brand, i) {
                    var imgName;
                    if (brand.imgName) {
                        imgName = brand.imgName;
                    } else {
                        imgName = brand.brandId;
                    }
                    <%'// for dev msg : <a> 브랜드 링크 M/A 분기 부탁드려요!%>
                    var tmpEl = '\
                                    <li>\
                                        <div class="brand-item">\
                                            <img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/' + imgName + '.jpg" alt="' + brand.brandName + '">\
                                            <div class="per">~'+ brand.salePer +'%</div>\
                                            <% If isApp="1" Then %><a href="" onclick="fnAPPpopupBrand(\'' + brand.brandId + '\'); return false;" class="mApp"></a><% Else %><a href="/street/street_brand.asp?makerid=' + brand.brandId + '" class="mWeb"></a><% End If %></div></li>\
                                ';
                    itemEle += tmpEl;
                });
                $rootEl.append(itemEle);
            });
        }
        renderBrands();
    });
</script>
<%' <!-- 19주년 참여 브랜드 106390 --> %>
<%' <!-- for dev msg : id 속성값들은 임의로 넣어뒀으니 바꾸셔도 됩니다 --> %>
<div class="mEvt106390">
    <h2><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/tit_brands.jpg" alt="19주년 프렌즈 세일"></h2>
    <section id="">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/tit_design.png" alt="Design"></h3>
        <div class="brand-wrap">
            <%' <!-- for dev msg : 디자인 파트 브랜드 리스트 (20개) --> %>
            <ul id="design" class="brand-list"></ul>
        </div>
    </section>
    <section id="">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/tit_living.png" alt="Living"></h3>
        <div class="brand-wrap">
            <%' <!-- for dev msg : 리빙 파트 브랜드 리스트 (20개) --> %>
            <ul id="living" class="brand-list"></ul>
        </div>
    </section>
    <section id="">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/tit_life.png" alt="Life"></h3>
        <div class="brand-wrap">
            <%'<!-- for dev msg : 라이프 파트 브랜드 리스트 (15개) -->%>
            <ul id="life" class="brand-list"></ul>
        </div>
    </section>
    <section id="">
        <h3><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/tit_fashion.png" alt="Fashion"></h3>
        <div class="brand-wrap">
            <%'<!-- for dev msg : 패션 파트 브랜드 리스트 (20개) -->%>
            <ul id="fashion" class="brand-list"></ul>
        </div>
    </section>
    <p class="bot"><img src="//webimage.10x10.co.kr/fixevent/event/2020/19th/106390/m/txt_bot.jpg" alt="19th"></p>
</div>
<%'<!-- //19주년 참여 브랜드 --> %>
<!-- #include virtual="/lib/db/dbclose.asp" -->