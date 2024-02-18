/**
 * 페이징 컴포넌트
 * 마크업 같을때 사용 *  
 */

Vue.component('comment-paging', {
    template: '\
    <div class="paging pagingV15a"\
    v-if="slotProps.pagingData.totalcount != 0"\
    >\
        <span class="arrow prevBtn"\
            v-if="slotProps.isPreArrowButton"\
            @click="slotProps.handleClickPreArrow"\
        ><a>prev</a></span>\
        <span\
            v-for="i in slotProps.pageIdx"\
            :class="[slotProps.dispPageNumber(i) == slotProps.pagingData.currpage ? \'current\' : \'\']"\
        >\
            <a\
                @click="slotProps.handleClickPageNumber( slotProps.dispPageNumber(i) )"\
            >{{ slotProps.dispPageNumber(i) }}</a></span>\
        <span class="arrow nextBtn"\
            v-if="slotProps.isNextArrowButton"\
            @click="slotProps.handleClickNextArrow"\
        ><a>next</a></span>\
    </div>\
    ',
    props: {
        slotProps: {
            type: Object,
            default: function(){
                return {}
            }
        }
    }
})
