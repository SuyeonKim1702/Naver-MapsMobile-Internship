# Naver-MapsMobile-Internship
### 기간 : 2021.01.18 ~ 2021.04.02

- 네이버 map ios 어플리케이션의 스마트 어라운드, 대중교통 탭 구현
- 사내 보안 규정에 따라, 네트워킹, 서비스 로직을 제외한 view 단의 코드만을 게시함
- 코드 리뷰를 통해 올바른 코드 작성법에 대해 이해하고, 읽기 쉬운 코드의 중요성에 대해 고찰
- 내 코드에 대해 의심하고, 비판적으로 바라보는 습관을 가지게 됨


### MVC 디자인 패턴 적용
  - model과 viewController 사이에 dataProvider를 두어, dataProvider에서 데이터의 가공을 처리하도록 함
     - vc와 model의 직접적 접근 방지
     - vc의 역할 축소 
  - 반복되는 subView의 경우 customView로 분리해, 재사용성을 높이고자 함
 
### OOP에 대한 학습 및 적용을 통한 클린코드 지향
   - 10-200룰(함수 <= 10줄, 클래스,구조체 <= 200줄) 적용을 통해 SRP(단일 책임 원칙)을 지키려고 함 : 코드 분리에 대한 기준 정립
   - enum 값들을 판단하는 분기문, switch문이 분산되어 있는 것을 한데 모으고, enum의 잦은 변경이 예상될 경우 독립된 protocol로 분리하고자 함 : OCP(개방폐쇄원칙) 적용에 대한 연습

### 타이머 기능 
   - 대중교통 탭의 api를 15초마다 호출
   - view의 생명주기를 활용해, viewDidAppear가 호출되면 타이머가 시작되고, viewDidDisappear가 호출되면 타이머가 멈추도록 구현함
   - 앱의 background/foreground 상태를 고려해서 background 상태로 넘어가면 타이머를 멈추고, 다시 foreground 상태가 되면 타이머가 작동하도록 구현함

### 화면 회전
   - UITraitCollection에 포함된 size class를 활용
   - 회전을 했을 때, height가 compact인 기종에 대해서는 미니뷰를 띄워주도록 함

### 이미지 리사이징 
- 테이블뷰에서 여러장의 이미지를 뿌려주는 과정에서 과도한 메모리가 사용됨
- 이미지 리사이징을 통해 이미지뷰의 크기만큼만 이미지 버퍼를 위한 공간을 마련
- UIGraphicsImageRenderer 대신에 UIGraphicsImageRenderer를 사용
   - 시스템에서 자동으로 적절한 render format을 선택하도록 함 -> 색 공간에 필요한 메모리 절약

```
    func resizeImage(size: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0

        let renderer = UIGraphicsImageRenderer(size: size)
        let outputImage = renderer.image { _ in
            self.draw(in: scaledImageRect)
        }
        return outputImage
    }
```

### 스크린 샷

