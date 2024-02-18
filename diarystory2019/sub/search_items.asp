<%
    '// data
    dim imglink
    dim ArrDesign , ArrContents , ArrKeyword , ArrColorCode
    dim SortMet , page , CurrPage
    dim tmp , iTmp , ctmp, ktmp , ptmp
    dim ListDiv , limited 
    dim PageSize : PageSize = 12
    Dim sArrDesign,sarrcontents,sarrkeyword,sarrColorCode
    Dim PrdBrandList, i
    dim gaParam : gaParam = "&gaparam=diarystory_"
    '//amplitude용 값
    dim vAmplitudeDesign, vAmplitudeDateType, vAmplitudeTermType, vAmplitudeScheduleTerm, vAmplitudTheme, vAmplitudeOption, vAmplitudeCoverMaterial, vAmplitudeBinder, vAmplitudeColor

    If ListDiv = "" Then ListDiv = "item"
    if limited = "" then limited = "X"
    IF SortMet = "" Then SortMet = "newitem"
    IF CurrPage = "" then CurrPage = 1
	if page = "" then page = 1

    '// 옵션 처리
    ArrDesign = requestcheckvar(request("arrds"),100)
	ArrContents = requestcheckvar(request("arrcont"),100)
	ArrKeyword = requestcheckvar(request("arrkey"),100)
	ArrColorCode = requestcheckvar(request("iccd"),100)
   
    ' response.write ArrDesign &"</br>"
    ' response.write ArrContents &"</br>"
    ' response.write ArrKeyword &"</br>"
    ' response.write ArrColorCode &"</br>"
    ' response.end

    ArrDesign = Split(ArrDesign,",")
	ArrContents = Split(ArrContents,",")
	ArrKeyword = Split(ArrKeyword,",")
	ArrColorCode = Split(ArrColorCode,",")

	For iTmp =0 to Ubound(ArrDesign)-1
		IF ArrDesign(iTmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrDesign(iTmp),2) &","
            '//amplitude전송용 데이터
            Select Case ArrDesign(iTmp)
                Case "10"
                    vAmplitudeDesign  = vAmplitudeDesign & "심플" &","
                Case "20"
                    vAmplitudeDesign  = vAmplitudeDesign & "일러스트" &","
                Case "30"
                    vAmplitudeDesign  = vAmplitudeDesign & "패턴" &","
                Case "40"
                    vAmplitudeDesign  = vAmplitudeDesign & "포토" &","
            end select                
		End IF
	Next
	ArrDesign = tmp

	tmp = ""
	For cTmp =0 to Ubound(ArrContents)-1
		IF ArrContents(cTmp)<>"" Then
			tmp  = tmp & "'" & requestcheckvar(ArrContents(cTmp),10) & "'" &","
            '//amplitude전송용 데이터
            Select Case ArrContents(cTmp)
                Case "2019 날짜형"
                    vAmplitudeDateType = vAmplitudeDateType & "2019 날짜형" &","
                Case "만년형"
                    vAmplitudeDateType = vAmplitudeDateType & "만년형" &","                                
                Case "분기별"
                    vAmplitudeTermType = vAmplitudeTermType & "분기별" &","                    
                Case "6개월"
                    vAmplitudeTermType = vAmplitudeTermType & "6개월" &","
                Case "1년"
                    vAmplitudeTermType = vAmplitudeTermType & "1년" &","
                Case "1년 이상"
                    vAmplitudeTermType = vAmplitudeTermType & "1년 이상" &","
                Case "연간스케줄"
                    vAmplitudeScheduleTerm = vAmplitudeScheduleTerm & "연간스케줄" &","
                Case "먼슬리"
                    vAmplitudeScheduleTerm = vAmplitudeScheduleTerm & "먼슬리" &","
                Case "위클리"
                    vAmplitudeScheduleTerm = vAmplitudeScheduleTerm & "위클리" &","
                Case "일스케줄"
                    vAmplitudeScheduleTerm = vAmplitudeScheduleTerm & "일스케줄" &","                    
                Case "다이어리"
                    vAmplitudTheme = vAmplitudTheme & "다이어리" &","                    
                Case "스터디"
                    vAmplitudTheme = vAmplitudTheme & "스터디" &","                    
                Case "가계부"
                    vAmplitudTheme = vAmplitudTheme & "가계부" &","                    
                Case "자기계발"
                    vAmplitudTheme = vAmplitudTheme & "자기계발" &","                                                                                
                Case "포켓"
                    vAmplitudeOption = vAmplitudeOption & "포켓" &","                    
                Case "밴드"
                    vAmplitudeOption = vAmplitudeOption & "밴드" &","                                                            
                Case "펜홀더"
                    vAmplitudeOption = vAmplitudeOption & "펜홀더" &","                                                                                
            end select               
		End IF
	Next
	ArrContents = tmp

	tmp = ""
	For ktmp =0 to Ubound(ArrKeyword)-1
		IF ArrKeyword(ktmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrKeyword(ktmp),2) &","
            '//amplitude전송용 데이터
            Select Case ArrKeyword(ktmp)
                Case "50"
                    vAmplitudeCoverMaterial = vAmplitudeCoverMaterial & "소프트커버" &","
                Case "51"
                    vAmplitudeCoverMaterial = vAmplitudeCoverMaterial & "하드커버" &","
                Case "52"
                    vAmplitudeCoverMaterial = vAmplitudeCoverMaterial & "가죽" &","
                Case "53"
                    vAmplitudeCoverMaterial = vAmplitudeCoverMaterial & "PVC" &","
                Case "54"
                    vAmplitudeCoverMaterial = vAmplitudeCoverMaterial & "패브릭" &","
                Case "55"
                    vAmplitudeBinder = vAmplitudeBinder & "양장/무선" &","
                Case "56"
                    vAmplitudeBinder = vAmplitudeBinder & "스프링" &","
                Case "60"
                    vAmplitudeBinder = vAmplitudeBinder & "바인더(2공~6공)" &","                    
            end select               
		End IF
	Next
	ArrKeyword = tmp

	tmp = ""
	For ptmp =0 to Ubound(ArrColorCode)-1
		IF ArrColorCode(ptmp)<>"" Then
			tmp  = tmp & requestcheckvar(ArrColorCode(ptmp),2) &","
            vAmplitudeColor = "Y"
		End IF
	Next
	ArrColorCode = tmp
    
	sArrDesign =""
	sarrcontents =""
	sarrkeyword =""
	sarrColorCode =""
	IF ArrDesign <> "" THEN sArrDesign =  left(ArrDesign,(len(ArrDesign)-1))
	IF arrcontents <> "" THEN sarrcontents =  left(arrcontents,(len(arrcontents)-1))
	IF arrkeyword <> "" THEN
		If arrColorCode = "" then
		    sarrkeyword =  left(arrkeyword,(len(arrkeyword)-1))
		else
		    sarrkeyword =  arrkeyword & left(arrColorCode,(len(arrColorCode)-1))
		End If
	else
		If arrColorCode <> "" then
		    sarrkeyword =  left(arrColorCode,(len(arrColorCode)-1))
		End If
	End If
    '// 옵션 처리

    if vAmplitudeDesign <> "" then vAmplitudeDesign = left(vAmplitudeDesign,Len(vAmplitudeDesign)-1)
    if vAmplitudeDateType <> "" then vAmplitudeDateType = left(vAmplitudeDateType,Len(vAmplitudeDateType)-1)
    if vAmplitudeTermType <> "" then vAmplitudeTermType = left(vAmplitudeTermType,Len(vAmplitudeTermType)-1)
    if vAmplitudeScheduleTerm <> "" then vAmplitudeScheduleTerm = left(vAmplitudeScheduleTerm,Len(vAmplitudeScheduleTerm)-1)
    if vAmplitudTheme <> "" then vAmplitudTheme = left(vAmplitudTheme,Len(vAmplitudTheme)-1)
    if vAmplitudeOption <> "" then vAmplitudeOption = left(vAmplitudeOption,Len(vAmplitudeOption)-1)
    if vAmplitudeCoverMaterial <> "" then vAmplitudeCoverMaterial = left(vAmplitudeCoverMaterial,Len(vAmplitudeCoverMaterial)-1)
    if vAmplitudeBinder <> "" then vAmplitudeBinder = left(vAmplitudeBinder,Len(vAmplitudeBinder)-1)

	set PrdBrandList = new cdiary_list
		PrdBrandList.FPageSize = PageSize
		PrdBrandList.FCurrPage = CurrPage
		PrdBrandList.frectdesign = sArrDesign
		PrdBrandList.frectcontents = sarrcontents
		PrdBrandList.frectkeyword = sarrkeyword
		PrdBrandList.fmdpick = ""
		PrdBrandList.frectlimited = limited
		PrdBrandList.ftectSortMet = SortMet
		PrdBrandList.getDiaryItemLIst
%>
<style>
.no-diary {text-align:center;}
.no-diary > div {width:40%; margin:0 auto;}
.no-diary a {display:inline-block; margin-top:1rem;}
</style>
<script type="text/javascript">
// options names in searching 
var tempSearchMessage = new Array();
var vPg=1, vScrl=true;

$(function() {
    fnAmplitudeEventMultiPropertiesAction('view_diary_search','','');
    fnAmplitudeEventMultiPropertiesAction('click_diary_search_result_setfilter'
    ,'diary_design|diary_date_type|diary_term_type|diary_schedule_term|diary_theme|diary_option|cover_material|diary_binder|color'
    ,'<%=vAmplitudeDesign%>|<%=vAmplitudeDateType%>|<%=vAmplitudeTermType%>|<%=vAmplitudeScheduleTerm%>|<%=vAmplitudTheme%>|<%=vAmplitudeOption%>|<%=vAmplitudeCoverMaterial%>|<%=vAmplitudeBinder%>|<%=vAmplitudeColor%>');

    $( ".filter-list" ).hide();
	$(".btn-finder").on("click", function(){
        $(this).hide();
        $('.search-head').addClass('on');
        $( ".filter-list" ).show();
		return false;
    });

    $(".filter-list .icon").on("click", function(){
        fndiarystory.unfold();
        return false;
    });

	$(".filter-list button").on("click", function(){
        fndiarystory.unfold();
        return false;
    });

    var fndiarystory = {
        findtodiary : function(){
            var nm  = document.getElementsByName('design');
			var cm  = document.getElementsByName('contents');
            var km  = document.getElementsByName('keyword');
            var ic  = document.getElementsByName('chkIcd');
		
			document.frm_search.arrds.value = "";
			document.frm_search.arrcont.value = "";
            document.frm_search.arrkey.value = "";
            document.frm_search.iccd.value = "";
	
			for (var i=0;i<nm.length;i++){
				if (nm[i].checked){
					document.frm_search.arrds.value = document.frm_search.arrds.value  + nm[i].value + ",";
				}
            }
		
			for (var i=0;i<cm.length;i++){
				if (cm[i].checked){
					document.frm_search.arrcont.value = document.frm_search.arrcont.value  + cm[i].value + ",";
				}
            }
	
			for (var i=0;i<km.length;i++){
				if (km[i].checked){
					document.frm_search.arrkey.value = document.frm_search.arrkey.value  + km[i].value + ",";
				}
            }

            for (var i=0;i<ic.length;i++){
				if (ic[i].checked){
					document.frm_search.iccd.value = document.frm_search.iccd.value  + ic[i].value + ",";
				}
            }
            
			document.frm_search.action = "<%=chkiif(isapp,"/apps/appcom/wish/web2014/diarystory2019/search.asp","/diarystory2019/search.asp")%>";
			document.frm_search.submit();
        },
        unfold : function(){
            $('html,body').animate({ scrollTop : window.top },300);
            $(".btn-finder").show();
            $('.search-head').removeClass('on');
            $('.filter-list').hide();
        }
    }

    $('.btn-block').click(function(){
        if($(this).parents('div').hasClass('filter-list')){
            fndiarystory.findtodiary();
        }
    });

    /* multi select */
	$(".filter ul li").on("click", function(){
		$(this).find('label').toggleClass("on")
		if ($(this).find('label').hasClass("on")){
			$(this).find('.checkel').prop('checked', true);
		}else{
			$(this).find('.checkel').prop('checked', false);
		}
		return false;
    });
    
    /* multi select class state */
    $('.filter ul li').each(function(){
        if($(this).find('.checkel').prop('checked')){
            $(this).find('label').addClass('on');
            tempSearchMessage.push($(this).find('label').text());
            $('.btn-all').addClass('checked');
        }else{
            $(this).find('label').removeClass('on');
        }
    });

    $('.btn-all').click(function(){
        location.replace("<%=chkiif(isapp,"/apps/appcom/wish/web2014/diarystory2019/search.asp","/diarystory2019/search.asp")%>");
    });

    /* selected options text */
    if(tempSearchMessage != ""){
        $('.search-head').find('.btn-finder').html(tempSearchMessage.splice(0,5)+'<span class="icon"></span>');
        $('.search-head').removeClass('on');
    }

    // 스크롤시 추가페이지 접수
	$(window).scroll(function() {
		if ($(window).scrollTop() >= ($(document).height()-$(window).height())-512){
			if(vScrl) {
				vScrl = false;
				vPg++;
				$.ajax({
					url: "/diarystory2019/inc/ajax_search_list.asp?cpg="+vPg,
					data: $("#frm_search").serialize(),
					cache: false,
					success: function(message) {
						if(message!="") {
							$("#diaryMoreList").append(message);
							vScrl=true;
						} 
					}
					,error: function(err) {
						alert(err.responseText);
						$(window).unbind("scroll");
					}
				});
			}
		}
	});

	// 로딩중 표시
	$("#lyLoading").ajaxStart(function(){
		$(this).show();
	}).ajaxStop(function(){
		$(this).hide();
	});
});
</script>
<section class="search-head">
    <h2>다이어리 찾기</h2>
    <button class="btn-all"><span class="icon"></span>모든 다이어리 보기</button>
    <button class="btn btn-block btn-finder">찾으시는 디자인을 선택해주세요<span class="icon"></span></button>
</section>

<%' 내가 원하는 다이어리찾기 %>
<div class="filter-list">
    <form name="frm_search" id="frm_search" method="post" style="margin:0px;">
    <input type="hidden" name="arrds" value="<%=trim(requestcheckvar(request("arrds"),100))%>">
    <input type="hidden" name="arrcont" value="<%=trim(requestcheckvar(request("arrcont"),100))%>">
    <input type="hidden" name="arrkey" value="<%=trim(requestcheckvar(request("arrkey"),100))%>">
    <input type="hidden" name="limited" value="<%=limited%>">
    <input type="hidden" name="iccd" value="<%=trim(requestcheckvar(request("iccd"),100))%>">
    <div class="inner">
        <p class="tit">내가 원하는 다이어리 찾기</p>
        <p class="sub">디자인을 선택 후 아래의 ‘찾기’ 버튼을 눌러주세요. </p>
        <span class="icon"></span>
        <div class="filter filter1">
            <p>디자인</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optS1" name="design" value="10" <%= getchecked(ArrDesign,10) %>/> <label for="optS1">심플</label></li>
                <li><input type="checkbox" class="checkel" id="optS2" name="design" value="20" <%= getchecked(ArrDesign,20) %>/> <label for="optS2">일러스트</label></li>
                <li><input type="checkbox" class="checkel" id="optS3" name="design" value="30" <%= getchecked(ArrDesign,30) %>/> <label for="optS3">패턴</label></li>
                <li><input type="checkbox" class="checkel" id="optS4" name="design" value="40" <%= getchecked(ArrDesign,40) %>/> <label for="optS4">포토</label></li>
            </ul>
        </div>
        <div class="filter filter2">
            <p>날짜</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt1-1" name="contents" value="'2019 날짜형'" <%= getchecked(arrcontents,"'2019 날짜형'") %>/> <label for="optCt1-1">2019 날짜형</label></li>
                <li><input type="checkbox" class="checkel" id="optCt1-2" name="contents" value="'만년형'" <%= getchecked(arrcontents,"'만년형'") %> /> <label for="optCt1-2">만년형</label></li>
            </ul>
        </div>
        <div class="filter filter3">
            <p>기간</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt2-1" name="contents" value="'분기별'" <%= getchecked(arrcontents,"'분기별'") %>/> <label for="optCt2-1">분기별</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-2" name="contents" value="'6개월'" <%= getchecked(arrcontents,"'6개월'") %>/> <label for="optCt2-2">6개월</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-3" name="contents" value="'1년'" <%= getchecked(arrcontents,"'1년'") %>/> <label for="optCt2-3">1년</label></li>
                <li><input type="checkbox" class="checkel" id="optCt2-4" name="contents" value="'1년 이상'" <%= getchecked(arrcontents,"'1년 이상'") %>/> <label for="optCt2-4">1년 이상</label></li>
            </ul>
        </div>
        <div class="filter filter3">
            <p>내지 구성</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt3-1" name="contents" value="'연간스케줄'" <%= getchecked(arrcontents,"'연간스케줄'") %>/> <label for="optCt3-1">연간스케줄</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-2" name="contents" value="'먼슬리'" <%= getchecked(arrcontents,"'먼슬리'") %>/> <label for="optCt3-2">먼슬리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-3" name="contents" value="'위클리'" <%= getchecked(arrcontents,"'위클리'") %>/> <label for="optCt3-3">위클리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt3-4" name="contents" value="'일스케줄'" <%= getchecked(arrcontents,"'일스케줄'") %>/> <label for="optCt3-4">일스케줄</label></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>테마</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt4-1" name="contents" value="'다이어리'" <%= getchecked(arrcontents,"'다이어리'") %>/> <label for="optCt4-1">다이어리</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-2" name="contents" value="'스터디'" <%= getchecked(arrcontents,"'스터디'") %>/> <label for="optCt4-2">스터디</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-3" name="contents" value="'가계부'" <%= getchecked(arrcontents,"'가계부'") %>/> <label for="optCt4-3">가계부</label></li>
                <li><input type="checkbox" class="checkel" id="optCt4-4" name="contents" value="'자기계발'" <%= getchecked(arrcontents,"'자기계발'") %>/> <label for="optCt4-4">자기계발</label></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>옵션</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCt5-1" name="contents" value="'포켓'" <%= getchecked(arrcontents,"'포켓'") %>/> <label for="optCt5-1">포켓</label></li>
                <li><input type="checkbox" class="checkel" id="optCt5-2" name="contents" value="'밴드'" <%= getchecked(arrcontents,"'밴드'") %>/> <label for="optCt5-2">밴드</label></li>
                <li><input type="checkbox" class="checkel" id="optCt5-3" name="contents" value="'펜홀더'" <%= getchecked(arrcontents,"'펜홀더'") %>/> <label for="optCt5-3">펜홀더</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter4">
            <p>커버 재질</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCv1-1" name="keyword" value="50" <%= getchecked(arrkeyword,"50") %>/> <label for="optCv1-1">소프트커버</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-2" name="keyword" value="51" <%= getchecked(arrkeyword,"51") %>/> <label for="optCv1-2">하드커버</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-3" name="keyword" value="52" <%= getchecked(arrkeyword,"52") %>/> <label for="optCv1-3">가죽</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-4" name="keyword" value="53" <%= getchecked(arrkeyword,"53") %>/> <label for="optCv1-4">PVC</label></li>
                <li><input type="checkbox" class="checkel" id="optCv1-5" name="keyword" value="54" <%= getchecked(arrkeyword,"54") %>/> <label for="optCv1-5">패브릭</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter5">
            <p>제본</p>
            <ul class="option-list">
                <li><input type="checkbox" class="checkel" id="optCv2-1" name="keyword" value="55" <%= getchecked(arrkeyword,"55") %>/> <label for="optCv2-1">양장/무선</label></li>
                <li><input type="checkbox" class="checkel" id="optCv2-2" name="keyword" value="56" <%= getchecked(arrkeyword,"56") %>/> <label for="optCv2-2">스프링</label></li>
                <li><input type="checkbox" class="checkel" id="optCv2-3" name="keyword" value="60" <%= getchecked(arrkeyword,"60") %>/> <label for="optCv2-3">바인더(2공~6공)</label></li>
                <li></li>
            </ul>
        </div>
        <div class="filter filter6">
            <p>색상</p>
            <ul class="option-list colorchips">
                <li class="wine"><input type="checkbox" class="checkel" id="wine" name="chkIcd" value="28" <%= getchecked(arrColorCode,"28") %>/><label for="wine">Wine</label></li>
                <li class="red"><input type="checkbox" class="checkel" id="red" name="chkIcd" value="2" <%= getchecked(arrColorCode,"2") %>/><label for="red">Red</label></li>
                <li class="orange"><input type="checkbox" class="checkel" id="orange" name="chkIcd" value="16" <%= getchecked(arrColorCode,"16") %>/><label for="orange">Orange</label></li>
                <li class="brown"><input type="checkbox" class="checkel" id="brown" name="chkIcd" value="24" <%= getchecked(arrColorCode,"24") %>/><label for="brown">Brown</label></li>
                <li class="camel"><input type="checkbox" class="checkel" id="camel" name="chkIcd" value="29" <%= getchecked(arrColorCode,"29") %>/><label for="camel">Camel</label></li>
                <li class="green"><input type="checkbox" class="checkel" id="green" name="chkIcd" value="19" <%= getchecked(arrColorCode,"19") %>/><label for="green">Green</label></li>
                <li class="khaki"><input type="checkbox" class="checkel" id="khaki" name="chkIcd" value="31" <%= getchecked(arrColorCode,"31") %>/><label for="khaki">Khaki</label></li>
                <li class="beige"><input type="checkbox" class="checkel" id="beige" name="chkIcd" value="18" <%= getchecked(arrColorCode,"18") %>/><label for="beige">Beige</label></li>
                <li class="yellow"><input type="checkbox" class="checkel" id="yellow" name="chkIcd" value="17" <%= getchecked(arrColorCode,"17") %>/><label for="yellow">Yellow</label></li>
                <li class="ivory"><input type="checkbox" class="checkel" id="ivory" name="chkIcd" value="30" <%= getchecked(arrColorCode,"30") %>/><label for="ivory">Ivory</label></li>
                <li class="mint"><input type="checkbox" class="checkel" id="mint" name="chkIcd" value="32" <%= getchecked(arrColorCode,"32") %>/><label for="mint">Mint</label></li>
                <li class="skyblue"><input type="checkbox" class="checkel" id="skyblue" name="chkIcd" value="20" <%= getchecked(arrColorCode,"20") %>/><label for="skyblue">Sky Blue</label></li>
                <li class="blue"><input type="checkbox" class="checkel" id="blue" name="chkIcd" value="21" <%= getchecked(arrColorCode,"21") %>/><label for="blue">Blue</label></li>
                <li class="navy"><input type="checkbox" class="checkel" id="navy" name="chkIcd" value="33" <%= getchecked(arrColorCode,"33") %>/><label for="navy">Navy</label></li>
                <li class="violet"><input type="checkbox" class="checkel" id="violet" name="chkIcd" value="22" <%= getchecked(arrColorCode,"22") %>/><label for="violet">Violet</label></li>
                <li class="lightgrey"><input type="checkbox" class="checkel" id="lightgrey" name="chkIcd" value="25" <%= getchecked(arrColorCode,"25") %>/><label for="lightgrey">Light Grey</label></li>
                <li class="white"><input type="checkbox" class="checkel" id="white" name="chkIcd" value="7" <%= getchecked(arrColorCode,"7") %>/><label for="white">White</label></li>
                <li class="pink"><input type="checkbox" class="checkel" id="pink" name="chkIcd" value="23" <%= getchecked(arrColorCode,"23") %>/><label for="pink">Pink</label></li>
                <li class="babypink"><input type="checkbox" class="checkel" id="babypink" name="chkIcd" value="35" <%= getchecked(arrColorCode,"35") %>/><label for="babypink">Baby Pink</label></li>
                <li class="lilac"><input type="checkbox" class="checkel" id="lilac" name="chkIcd" value="34" <%= getchecked(arrColorCode,"34") %>/><label for="lilac">Lilac</label></li>
                <li class="charcoal"><input type="checkbox" class="checkel" id="charcoal" name="chkIcd" value="36" <%= getchecked(arrColorCode,"36") %>/><label for="charcoal">Charcoal</label></li>
                <li class="black"><input type="checkbox" class="checkel" id="black" name="chkIcd" value="8" <%= getchecked(arrColorCode,"8") %>/><label for="black">Black</label></li>
                <li class="silver"><input type="checkbox" class="checkel" id="silver" name="chkIcd" value="26" <%= getchecked(arrColorCode,"26") %>/><label for="silver">Silver</label></li>
                <li class="gold"><input type="checkbox" class="checkel" id="gold" name="chkIcd" value="27" <%= getchecked(arrColorCode,"27") %>/><label for="gold">Gold</label></li>
                <li class="hologram"><input type="checkbox" class="checkel" id="hologram" name="chkIcd" value="58" <%= getchecked(arrColorCode,"58") %>/><label for="hologram">Hologram</label></li>
            </ul>
        </div>
        <div id="lyLoading" style="display:none;position:relative;text-align:center; padding:0; margin-top:-20px;"><img src="http://fiximage.10x10.co.kr/icons/loading16.gif" style="width:16px;height:16px;" /></div>
    </div>
    <button class="btn btn-block">다이어리 찾기</button>
    <form>
</div>
<%' 내가 원하는 다이어리찾기 : for dev msg : brand 가 추가 됐습니다.%>

<%' 검색결과 %>
<div class="diary-list">
    <% If PrdBrandList.FResultCount > 0 Then %>
    <div class="items type-grid">
        <ul id="diaryMoreList">
        <%
            Dim tempimg, tempimg2 , diaryItemBedge
            For i = 0 To PrdBrandList.FResultCount - 1

                If ListDiv = "item" Then
                    tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg
                    tempimg2 = PrdBrandList.FItemList(i).FDiaryBasicImg2
                End If
                If ListDiv = "list" Then
                    tempimg = PrdBrandList.FItemList(i).FDiaryBasicImg2
                End If

                IF application("Svr_Info") = "Dev" THEN
                    tempimg = left(tempimg,7)&mid(tempimg,12)
                    tempimg2 = left(PrdBrandList.FItemList(i).FDiaryBasicImg2,7)&mid(PrdBrandList.FItemList(i).FDiaryBasicImg2,12)''마우스오버 활용컷
                end if

                diaryItemBedge = ""

                if PrdBrandList.FItemList(i).FNewYN = "1" then 
                    diaryItemBedge = "<span class=""label new""></span>"
                end if 

                if PrdBrandList.FItemList(i).FmdpickYN = "o" then 
                    diaryItemBedge = "<span class=""label best""></span>"
                end if 
                
        %>
            <li <%'=chkiif(PrdBrandList.FItemList(i).IsSoldOut,"class='soldOut'","") %>> 
            <% If isapp Then %>                                        
                <a href="" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_search_item','item_index|itemid|brand_name','<%=i+1%>|<%=PrdBrandList.FItemList(i).FItemid%>|<%=replace(PrdBrandList.FItemList(i).FBrandName,"'","")%>',function(bool){if(bool) {fnAPPpopupAutoUrl('/category/category_itemprd.asp?itemid=<%=PrdBrandList.FItemList(i).FItemid%><%=gaParam&"list_"&i+1%>');}});return false;">                    
            <% Else %>                        
                <a href="/category/category_itemprd.asp?itemid=<%=PrdBrandList.FItemList(i).FItemid%><%=gaParam&"list_"&i+1%>" onclick="fnAmplitudeEventMultiPropertiesAction('click_diary_search_item','item_index|itemid|brand_name','<%=i+1%>|<%=PrdBrandList.FItemList(i).FItemid%>|<%=replace(PrdBrandList.FItemList(i).FBrandName,"'","") %>')">
            <% End if %>                               
                    <div class="thumbnail">
                        <% if PrdBrandList.FItemList(i).IsSoldOut then %>
                            <span class="soldOutMask"></span>
                        <% end if %>
                        <img src="<%=tempimg %>" alt="<%= PrdBrandList.FItemList(i).FItemName %>" />
                        <%=diaryItemBedge%>
                    </div>
                    <div class="desc">
                        <p class="brand"><%= PrdBrandList.FItemList(i).Fsocname %></p>
                        <p class="name">
                            <% If PrdBrandList.FItemList(i).isSaleItem Or PrdBrandList.FItemList(i).isLimitItem Then %>
                                <%= chrbyte(PrdBrandList.FItemList(i).FItemName,30,"Y") %>
                            <% Else %>
                                <%= PrdBrandList.FItemList(i).FItemName %>
                            <% End If %>
                        </p>
                        <% if PrdBrandList.FItemList(i).IsSaleItem or PrdBrandList.FItemList(i).isCouponItem Then %>
                            <% IF PrdBrandList.FItemList(i).IsSaleItem then %>
                                <div class="price">
                                    <div class="unit">
                                        <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0)%><span class="won">원</span></b>
                                        <b class="discount color-red"><%=PrdBrandList.FItemList(i).getSalePro%></b>
                                    </div>
                                </div>
                            <% End If %>
                            <% IF PrdBrandList.FItemList(i).IsCouponItem Then %>
                                <div class="price">
                                    <div class="unit">
                                        <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).GetCouponAssignPrice,0)%><span class="won">원</span></b>
                                        <b class="discount color-green"><%=PrdBrandList.FItemList(i).GetCouponDiscountStr%></b>
                                    </div>
                                </div>
                            <% end if %>
                        <% else %>
                            <span class="price">
                                <div class="unit">
                                    <b class="sum"><%=FormatNumber(PrdBrandList.FItemList(i).getRealPrice,0) & chkIIF(PrdBrandList.FItemList(i).IsMileShopitem,"Point","<span class='won'>원</span>")%></b>
                                </div>
                            </span>
                        <% end if %>
                    </div>
                </a>
            </li>
        <%
            Next
        %>
        </ul>
    </div>
    <% else %>
    <div class="no-diary">
        <div><img src="http://fiximage.10x10.co.kr/web2018/diary2019/m/txt_no_data.png" alt="진행중인 이벤트가 없습니다"></div>
        <a href="" javascript="location.replace("<%=chkiif(isapp,"/apps/appcom/wish/web2014/diarystory2019/search.asp","/diarystory2019/search.asp")%>");return false;"><img src="http://fiximage.10x10.co.kr/web2018/diary2019/btn_all.png" alt="전체보기"></a>
    </div>
    <% end if %>    
</div>
<%' 검색결과 %>
<%
	Set PrdBrandList = Nothing
%>