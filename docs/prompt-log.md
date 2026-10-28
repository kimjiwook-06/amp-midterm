# prompt-log — 실제 작업 기록

작성일: 2026-10-28. 사용 도구: Codex, imagegen, Flutter, Playwright.

앱 콘셉트와 세 가지 핵심 설계 결정은 작성자가 제시하거나 확인했다. 코드 구현, 문서 초안, 이미지 제작과 검증에는 AI의 도움을 받았다. 아래는 작업 중 요청과 판단을 한국어로 요약한 기록이다.

| ID | 요청 / 실제 맥락 | AI 결과·반론 | 사용자 판단 / 처리 | 이유 |
|---|---|---|---|---|
| L1 | 사용자가 과제 스크린샷과 ‘어디 뒀지?’ 콘셉트 제공. 데모+코드 우선, 발표 제외 | UI-only와 GET 제약을 추출 | 프로젝트 구현 진행 | 실제 AI/영구 저장은 감점 항목 |
| L2 | 템플릿 링크 문의에 사용자가 xide-projext/mid-project-template 제공 | AGENTS·README·API 경계·문서 형식 확인 | 해당 템플릿 기반으로 구성 | 제공된 제출 형식 준수 |
| L3 | 확인 필수, 복수 후보, 마지막 기록 위치라는 세 결정을 검토 | 반론: 확인 단계가 수고를 늘린다. 개선: 기본 선택+불확실 항목 강조 | 작성자가 세 결정에 동의함 | 확인 부담을 줄이면서 사용자가 최종 판단하도록 구성 |
| L4 | 사용자 콘셉트를 충족하기 위해 AI가 자체 비판 수행 | 후보 하나만 단정하면 간단하지만 틀린 후보를 숨길 수 있음. 실시간 위치 표현은 기록 사진과 충돌 | L3의 복수 후보·마지막 기록 위치 결정을 코드에 반영 | P01/P06, 사용자 통제 |
| L5 | 사진 장면 생성 | 내장 imagegen으로 서랍·이어폰·케이블·열쇠·노트 예시 제작 | assets/drawer.png에 복사, 위치 좌표 검토 | 개인정보 없는 명료한 시연 장면 |
| L6 | 컴파일·위젯·실제 브라우저 검증 | 체크박스 내부 수정 버튼이 접근성 트리에서 독립 버튼으로 노출되지 않음을 발견 | 버튼을 체크박스 밖의 Row로 이동 | 키보드·보조기술·자동화 접근성 개선 |

## 기록 범위
L3은 AI가 제안한 설계에 대한 작성자의 확인이며, L4는 AI가 추가로 검토한 반론이다. 별도의 반론 요청 문장을 직접 입력한 기록은 없다. 셀프 논증의 상세한 재반론 문장은 이 과정을 바탕으로 AI와 정리한 초안이다.

## imagegen 프롬프트 / 출처
내장 도구 사용(유료 API 코드 없음). 생성 결과는 `assets/drawer.png`.
Prompt: “Use case: photorealistic-natural. Asset type: example scene photo bundled in a Korean lost-item finder Flutter UI. A single clean overhead photograph of an open light oak desk drawer with cream fabric organizer dividers. Clearly visible objects: black wireless earbuds inside an open black oval charging case at center-left; coiled white USB cable at center-right; silver keys with a sage green fabric keyring in bottom-right; dark blue small notebook in top-right. Natural warm daylight, quiet premium home organization editorial photograph, real textures, restrained neutral palette, straight top-down view, whole drawer edges visible. No text, labels, logos, hands or UI. Landscape 3:2 composition. Objects well separated so an app can place bounding boxes.”
최종 생성 시 좌표 힌트도 제공했고, 코드 좌표는 완성 이미지를 보고 맞췄다. 생성 이미지는 실제 사용자 촬영물이 아니다.
