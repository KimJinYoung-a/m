<%@  codepage="65001" language="VBScript" %>
<% option Explicit %>
<% response.Charset="UTF-8" %>
<!-- #include virtual="/lib/db/dbopen.asp" -->
<!-- #INCLUDE Virtual="/lib/util/commlib.asp" -->
<!-- #include virtual="/lib/util/md5.asp"-->
<!-- #include virtual="/lib/inc_const.asp" -->
<!-- #INCLUDE Virtual="/lib/chkDevice.asp" -->
<%
	Dim sqlStr1 , sqlStr2 , sqlStr3
	Dim contents_pidx : contents_pidx = requestCheckVar(request("pidx"),10)
	dim userid : userid = getEncLoginUserID()

	Dim vPidx , vCidx , vContents , vVideourl
	Dim cTitlename
	Dim arrListItem
    Dim sqlHtml , icnt

	If contents_pidx = "" Then
		Call Alert_Return("PIDX가 없습니다..")
		response.End
	End If 

    strHeadTitleName = "PLAY"

	'// contents data
	sqlStr1 = "SELECT  l.pidx , l.cidx , l.contents , l.videourl"
	sqlStr1 = sqlStr1 & "	FROM db_sitemaster.dbo.tbl_playlist AS l "
	sqlStr1 = sqlStr1 & "	WHERE pidx = '"& contents_pidx &"'"
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr1,dbget,adOpenForwardOnly, adLockReadOnly
        if Not(rsget.EOF or rsget.BOF) Then
            vPidx		= rsget("pidx")
            vCidx		= rsget("cidx")
            vContents   = rsget("contents")
            vVideourl	= rsget("videourl")		
        end if
    rsget.Close

	'// contents titlename
	sqlStr2 = "SELECT titlename FROM db_sitemaster.dbo.tbl_playcontents WHERE cidx = "& vCidx  &""
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr2,dbget,adOpenForwardOnly, adLockReadOnly
        if Not(rsget.EOF or rsget.BOF) Then
            cTitlename		= rsget("titlename")
        end if
    rsget.Close

	'// 더 살펴 보기 DATA
	sqlStr3 = "EXEC db_sitemaster.dbo.usp_WWW_Play_PlayList_Items_Get "& vPidx &" , '"& userid &"'"
	rsget.CursorLocation = adUseClient
    rsget.Open sqlStr3,dbget,1
        IF Not (rsget.EOF OR rsget.BOF) THEN
            arrListItem = rsget.GetRows
        END If
    rsget.close
%>
<!-- #include virtual="/lib/inc/head.asp" -->
<script type="text/javascript">
$(function(){
    /* others */
    var othersSwiper = new Swiper(".others", {
        slidesPerView:"auto",
        freeMode:true
    });
    $(".btn-wish").on("click", function(e){
        if ( $(this).hasClass("on")) {
            $(this).removeClass("on");
        } else {
            $(this).addClass("on");
        }
    });
});
</script>  
</head>
<body class="default-font body-sub playV18 detail-play">
    <!-- #include virtual="/lib/inc/incHeader.asp" -->
	<div id="content" class="content">
		<div class="detail-cont">
            <div class="play-contents">
                <div class="type-film">
                    <div class="topic">
                        <div class="vod-area">
                            <iframe src="<%=replace(vVideourl,"youtu.be/","www.youtube.com/embed/")%>" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        </div>
                        <div class="play-title">
                            <h2><%=nl2br(vContents)%></h2>
                            <div class="label">
                                <em><%=cTitlename%></em>
                            </div>
                        </div>
                    </div>
                    <!-- 관련상품 -->
                    <div class="others swiper-container">
                        <ul class="swiper-wrapper">
                            <%
                                dim itemid , itemlistimage , mywish , evalcnt , favcount , itemname
                                If isArray(arrListItem) Then
                                    For icnt = 0 to ubound(arrListItem,2)

                                        itemid			=	arrListItem(0,icnt)
                                        itemlistimage	=	arrListItem(1,icnt)
                                        mywish			=	arrListItem(2,icnt)
                                        evalcnt			=	arrListItem(3,icnt)
                                        favcount		=	arrListItem(4,icnt)
                                        itemname		=	arrListItem(5,icnt)

                                        sqlHtml = sqlHtml & "<li class='swiper-slide'>"
                                        sqlHtml = sqlHtml & "<div class='thumbnail'><a href='/category/category_itemprd.asp?itemid="& itemid&"'><img src='"& getThumbImgFromURL("http://webimage.10x10.co.kr/image/list/" & GetImageSubFolderByItemid(itemid) & "/" & itemlistimage ,100,100,"true","false") &"' alt='Animal Series' /></a></div>"
                                        sqlHtml = sqlHtml & "<button type='button' class='btn-wish "& chkiif(mywish=1,"on","") &"' onclick=''>위시등록</button>"
                                        sqlHtml = sqlHtml & "</li>"

                                    Next
                                    response.write sqlHtml
				                End If
                            %>
                        </ul>
                    </div>
                </div>
            </div>
		</div>
	</div>
</body>
</html>
<!-- #include virtual="/lib/db/dbclose.asp" -->