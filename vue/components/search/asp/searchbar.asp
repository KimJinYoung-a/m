<!-- #include virtual="/html/lib/inc/head.asp" -->
<script>
$(function(){
    // 입력 키워드 텍스트
    var kwd_lists = '';
    function getUserkwd () {
        $($('.srchbar .kwd_inner span')).each(function () {
            kwd_lists += ( $(this).text() + ' ' );
        });
    }

    // 입력 키워드 삭제
    $('.btn_del').click(function (e) {
        $(this).parent('span').remove();
    });

    // 입력 키워드 클릭시 수정
    $('.kwd_inner span').click(function (e) {
        getUserkwd();
        $('.kwd_list, .btn_add_kwd').hide();
        $('.srch_input').show();
        $('.srch_input').val(kwd_lists).focus();
    });

    // '이 안에서 검색' 버튼
    $('.btn_add_kwd').click(function (e) { 
        e.preventDefault();
        $('.mdl_add_kwd .srch_input').focus();
    });
});
</script>
</head>
<body>
    <!-- 검색바 (srchbar_wrap) -->
    <div class="srchbar_wrap">
        <div class="srchbar">
            <input type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input" style="display:none;">
            <div class="kwd_list">
                <div class="kwd_inner">
                    <span>스누핑<button class="btn_del"><i class="i_close"></i></button></span>
                    <span>우드스탁<button class="btn_del"><i class="i_close"></i></button></span>
                    <span>친구들<button class="btn_del"><i class="i_close"></i></button></span>
                    <span>절친들<button class="btn_del"><i class="i_close"></i></button></span>
                </div>
            </div>
            <button class="btn_add_kwd">이 안에서 검색</button>
            <p class="bbl_ten bbl_t">혹시, <em>스누피 snoopy</em> 찾으셨나요?</p>
        </div>
    </div>

    <!--<div class="srchbar_wrap">
        <div class="srchbar">
            <input type="search" title="검색어 입력" placeholder="검색어를 입력해주세요" class="srch_input" style="display:none;">
        </div>
    </div>-->
    <!-- // 검색바 (srchbar_wrap) -->
    </body>
</html>