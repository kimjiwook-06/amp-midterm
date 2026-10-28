const {chromium}=require('playwright');
const fs=require('fs');
(async()=>{
 const browser=await chromium.launch({channel:'chrome',headless:true});
 const context=await browser.newContext({viewport:{width:1440,height:1000},recordVideo:{dir:'docs/영상/raw',size:{width:1440,height:1000}}});
 const page=await context.newPage();const errors=[];page.on('pageerror',e=>errors.push(e.message));
 await page.goto('http://localhost:8080');await page.waitForTimeout(1800);
 await page.locator('flt-semantics-placeholder').evaluate(e=>e.click());
 await page.getByRole('button',{name:/무선 이어폰/}).waitFor();
 const wait=ms=>page.waitForTimeout(ms);
 const shot=name=>page.screenshot({path:`docs/screenshots/${name}.png`});
 await wait(3500);await shot('05_v2_wide');
 await page.getByRole('button',{name:'말로 찾기 미리보기'}).click();await wait(3000);await shot('voice');
 await page.getByRole('button',{name:'이 문장으로 찾아보기'}).click();await wait(2800);await shot('search_result');
 await page.getByRole('button',{name:/무선 이어폰/}).click();await wait(3800);await shot('detail_wide');
 await page.getByRole('tab',{name:'물품 정보'}).click();await wait(2300);
 await page.getByRole('tab',{name:'위치',exact:true}).click();await wait(1300);
 await page.getByRole('button',{name:'찾았어요!'}).click();await wait(3000);await shot('04_v2_c');
 await page.getByRole('button',{name:'다른 물건 찾기'}).click();await wait(800);
 await page.getByRole('button',{name:'사진으로 새 기록'}).click();await wait(2300);await shot('capture');
 await page.getByRole('button',{name:'이 사진으로 분석하기'}).click();await wait(500);await shot('analyzing');await wait(3000);await shot('review');
 await page.getByRole('button',{name:'다이어리 이름 수정'}).click();await wait(1800);
 await page.getByRole('textbox').fill('작은 노트');await page.getByRole('button',{name:'수정 적용'}).click();await wait(2600);await shot('review_corrected');
 await page.getByRole('button',{name:'4개 확인하고 기록하기'}).click();await wait(3000);await shot('saved');
 await page.getByRole('button',{name:'홈으로 돌아가기'}).click();await wait(800);
 for(const [label,file] of [['로딩','loading'],['오류','error'],['빈 기록','empty'],['정상','normal']]){
  await page.getByRole('button',{name:'데모 장면 선택'}).click();await page.getByRole('button',{name:label,exact:true}).click();await page.mouse.wheel(0,600);await wait(2000);await shot(file);await page.mouse.wheel(0,-1500);await wait(400);
 }
 await page.setViewportSize({width:390,height:844});await wait(2200);await shot('02_v2_a');
 await wait(2000);
 await context.close();await browser.close();
 fs.writeFileSync('docs/evidence/browser-qa.json',JSON.stringify({date:'2026-10-28',errors,checks:['real GET','voice mock','search result','Navigator push/pop','TabBar','BottomSheet','analysis loading','rename','mock save','loading/error/empty','390px mobile']},null,2));
 if(errors.length)process.exitCode=1;
})();
