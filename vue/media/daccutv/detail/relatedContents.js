Vue.component('related-contents', {
    template: '\
    <div class="related-cnt"\
        v-if="relatedContents.length > 0"\
    >\
        <h3>이런 컨텐츠도 추천 드려요!</h3>\
        <!-- 동영상 리스트 ( 상하 : type1 / 좌우 : type2 ) -->\
        <div class="vod-list type2">\
            <ul>\
                <!-- for dev msg : 새 글 <span class="badge">NEW</span> -->\
                <li>\
                    <a href="./detail.asp">\
                        <div class="thm"><img src="//fiximage.10x10.co.kr/m/2019/platform/@img_690x400_01.jpg" alt=""><span class="badge">NEW</span></div>\
                        <div class="desc">\
                            <b class="headline">텐텐탐구생활 ep.2 \'텐텐문방구 브이로그\' 텐텐크리에이터 평범한소미가 텐텐사장님 딸이 되었다고???</b>\
                            <span class="subcopy">TongTongTV</span>\
                        </div>\
                    </a>\
                </li>\
                <li>\
                    <a href="./detail.asp">\
                        <div class="thm"><img src="//fiximage.10x10.co.kr/m/2019/platform/@img_690x400_02.jpg" alt=""></div>\
                        <div class="desc">\
                            <b class="headline">젤리펜과 수성 볼펜 서열 정리합니다</b>\
                            <span class="subcopy">TongTongTV</span>\
                        </div>\
                    </a>\
                </li>\
                <li>\
                    <a href="./detail.asp">\
                        <div class="thm"><img src="//fiximage.10x10.co.kr/m/2019/platform/@img_690x400_03.jpg" alt=""></div>\
                        <div class="desc">\
                            <b class="headline">젤리펜과 수성 볼펜 서열 정리합니다</b>\
                            <span class="subcopy">TongTongTV</span>\
                        </div>\
                    </a>\
                </li>\
            </ul>\
            <div class="tf-loader"></div>\
        </div>\
    </div>\
    ',
    props: {
        relatedContents: {
            type: Array,
            default: []
        }
    }
})

