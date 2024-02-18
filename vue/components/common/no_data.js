Vue.component('No-Data',{
    template : `
            <!-- 결과 없음 -->
            <div class="no_data">
                <figure class="img"></figure>
                <p class="txt">
                    <strong v-html="mainCopy"></strong>
                    <span v-html="subCopy"></span>
                </p>
                <button @click="click_return_button" class="btn_type2 btn_blk" v-if="backUrlButtonDisplayFlag">돌아가기<i class="i_refresh2"></i></button>
            </div>
    `,
    props : {
        backUrlButtonDisplayFlag : {type : Boolean , default : true}, // 돌아가기 버튼 유무
        mainCopy : { type : String, default : '아쉽게도 검색결과가 없어요' }, // 메인 카피
        subCopy : { type : String, default : '상품이 품절되었을 경우 검색이 지원되지<br>않을 수 있으니 참고해주세요 :)' }, // 서브 카피
    },
    methods : {
        click_return_button() { // 돌아가기 버튼 클릭
            this.$emit('click_return_button');
        }
    }
})