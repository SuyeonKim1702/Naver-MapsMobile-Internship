# Naver-MapsMobile-Internship
### 기간 : 2021.01.18 ~ 2021.04.02

- 네이버 map ios 어플리케이션의 스마트 어라운드, 대중교통 탭 구현
- 사내 보안 규정에 따라, 네트워킹, 서비스 로직을 제외한 view 단의 코드만을 게시함

- 코드 리뷰를 통해 올바른 코드 작성법에 대해 이해하고, 읽기 쉬운 코드의 중요성에 대해 고찰
- MVC 디자인 패턴 적용
- OOP에 대한 학습 및 적용을 통해 클린코드를 지향하려고 함
- 내 코드에 대해 의심하고, 비판적으로 바라보는 습관을 가지게 됨


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

