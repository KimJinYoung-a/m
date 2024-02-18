<script>
(function($){
    // diary story 2019 happy together 2019-09-13 이종화
    
	var json_data = '/category/act_happytogether_diaryitems.asp';
    var _data = {};
    var _totalLength;
    var _totalPage; 
    var _sPoint = 0;
    var _ePoint = 9;
    var defaultPageSize = 10;
    var fnDiary = {
        el : function(){
            return $("#diaryitemsadd");
        },
        getDiaryData : function(){
            // 비동기로 Data를 전역 변수에 저장함
            $.ajaxSetup({
                async : false
            });
            $.getJSON(json_data, function (data, status, xhr) {
                if (status == 'success') {
                    if (data != ''){
                        console.log('Data OK');
                        var _list = data.diaryitems;
                        _data = _list;
                        _totalLength = _list.length;
                        _totalPage = parseInt(_totalLength/defaultPageSize);
                    }else{
                        console.log('JSON data not Loaded.');
                    }
                } else {
                    console.log('JSON data not Loaded.' + status);
                }
            });
        },
        getSubHtml : function(v, n){
            var subhtml;
            var s = v.brandname;
            var im = v.itemname;

            subhtml = '<li class="deal-item">';
            <% if isapp then %>
            subhtml = subhtml + '<a href="" onclick="fnGoDiaryItemsPrd('+n+','+ v.itemid +');return false;">';
            <% else %>
            subhtml = subhtml + '<a href="/category/category_itemprd.asp?itemid='+ v.itemid +'&gaparam=diarystory_related_'+ v.index +'" onclick=fnAmplitudeEventMultiPropertiesAction("click_diarystory_items","number|itemid","'+n+'|'+v.itemid+'");>';
            <% end if %>
            subhtml = subhtml + '<div class="thumbnail"><img src="'+ v.basicimage +'" alt="" /></div>';
            subhtml = subhtml + '<div class="desc">';
            subhtml = subhtml + '<span class="brand">'+ s.toUpperCase() +'</span>';
            subhtml = subhtml + '<p class="name">'+ im +'</p>';
            subhtml = subhtml + '<div class="price">'
            subhtml = subhtml + '<div class="unit"><b class="sum">'+ v.totalprice +'<span class="won">원</span></b>';
            if(v.saleyn ==='Y'){
            subhtml = subhtml + ' <b class="discount color-red">'+ v.totalsaleper +'</b></div>';
            }
            subhtml = subhtml + '</div>';
            subhtml = subhtml + '</div>';
            subhtml = subhtml + '</a>';
            subhtml = subhtml + '</li>';

            return subhtml;
        },
        setDataToHtml : function(startPoint , endPoint){
            // 저장된 전역 변수 Data를 HTML 바인딩 시킴
            var addEl = new Array();
            var sPoint = startPoint;
            var ePoint = endPoint;

            $.each(_data,function(index){
                if(index >= sPoint && index <= ePoint){
                    addEl += fnDiary.getSubHtml(_data[index], index);
                }
            });

            fnDiary.el().append(addEl);
        },
        getNextPageHtml : function(s, e){
            return fnDiary.setDataToHtml(s, e);
        }
    }

    // init 
    fnDiary.getDiaryData();

    // first bind
    $(document).ajaxStop(function(){
        fnDiary.setDataToHtml(_sPoint, _ePoint);    
    });

    // button action
    $(document).on('click', function(event){
        var currentPage = parseInt($("#diaryitemsadd").attr('rel'));
        var startPoint = _sPoint;
        var endPoint = _ePoint;

        // nextView
        if($(event.target).attr('id') == 'diarymorebutton'){
            if (currentPage < _totalPage){
                startPoint = parseInt((currentPage*defaultPageSize)); 
                endPoint = parseInt((currentPage+1)*defaultPageSize)-1; 
                $("#diaryitemsadd").attr('rel',currentPage+1);

                fnDiary.getNextPageHtml(startPoint, endPoint);
            }else{
                $("#diarymorebutton").hide();
            }
            fnAmplitudeEventMultiPropertiesAction("click_diarystory_items_more","itemid","<%=itemid%>");
        }
    });
}(jQuery));

function fnGoDiaryItemsPrd(n,i) {
    fnAmplitudeEventMultiPropertiesAction("click_diarystory_items","number|itemid",""+n+"|"+i+"",function(bool){if(bool) {fnAPPpopupAutoUrl("/category/category_itemprd.asp?itemid="+i+"&gaparam=diarystory_related_"+n+"");}});
    return false;
}
</script>

<div class="dairy-prd">
    <h3>
        <span>다꾸력을 높이는 데코 아이템</span>
        하루의 기록을 특별하게! 함께 구매하면 좋을 환상의 짝꿍들
    </h3>
    <div class="items type-big">
        <ul id="diaryitemsadd" rel="1"></ul>
    </div>
    <div class="btnAreaV16a btn-moreV18">
        <p><button type="button" class="btnV16a btn-line-blue" id="diarymorebutton">더보기<span class="down-open"></span></button></p>
    </div>
</div>