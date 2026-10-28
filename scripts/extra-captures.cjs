const {chromium}=require('playwright');
const fs=require('fs');
(async()=>{
const b=await chromium.launch({channel:'chrome',headless:true});
const p=await b.newPage({viewport:{width:390,height:844}});
await p.goto('http://localhost:8080');await p.waitForTimeout(1800);await p.locator('flt-semantics-placeholder').evaluate(e=>e.click());
await p.screenshot({path:'docs/screenshots/02_v2_a.png'});
await p.getByRole('tab',{name:'내 기록'}).click();await p.waitForTimeout(500);
await p.getByRole('button',{name:/무선 이어폰/}).click();await p.waitForTimeout(600);await p.screenshot({path:'docs/screenshots/03_v2_b.png'});
await p.setViewportSize({width:1440,height:1000});await p.goto('http://localhost:8080');await p.waitForTimeout(1300);await p.locator('flt-semantics-placeholder').evaluate(e=>e.click());
await p.getByRole('checkbox',{name:'검은색 물건'}).click();await p.waitForTimeout(600);await p.screenshot({path:'docs/screenshots/multi_result.png'});
const concepts=[['i1_before','01 / 자동 확정 대안','AI가 4개 물건을 찾았어요','다이어리 · 확정됨','자동으로 저장했어요','문제: 잘못된 이름을 확인할 기회가 없음'],['i2_before','02 / 단일 후보 대안','검은색 물건을 찾았어요','무선 이어폰','이 물건이 맞아요','문제: 다른 후보를 비교할 수 없음'],['i3_before','03 / 실시간 단정 대안','지금 여기 있어요','책상 첫 번째 서랍','바로 찾으러 가기','문제: 오래된 사진도 현재 위치로 오해']];
await p.setViewportSize({width:700,height:560});
for(const [file,kicker,title,card,button,note] of concepts){await p.setContent(`<html lang="ko"><meta charset="utf-8"><style>body{font-family:'Malgun Gothic',sans-serif;background:#f3f4f0;color:#283b32;margin:0;padding:42px}small{letter-spacing:2px;color:#6a786e}.frame{background:white;border:1px solid #ddd;border-radius:20px;padding:28px;margin:24px 0}h1{font-size:28px}button{background:#dce0da;border:0;border-radius:10px;padding:16px;width:100%;margin-top:26px}footer{color:#8b5425;font-size:14px}</style><small>비교용 기획 대안 · 실제 과거 화면 아님</small><h1>${title}</h1><p>${kicker}</p><div class="frame"><h2>${card}</h2><p>사진과 물건 정보</p><button>${button}</button></div><footer>${note}</footer></html>`);await p.screenshot({path:`docs/screenshots/${file}.png`});}
await b.close();
})();

