# 설명

mock 데이터를 활용한 CJ ONSTYLE의 리스트와 상세페이지 구현

* Deployment target : 16.0
* 외부 라이브러리는 사용하지 않았습니다
  
# 디자인패턴 및 설명

* Ribs style로 구현되었으며 크게 Router / ViewController / ViewModel / Builder / Component 로 구현되어 있습니다.
* Coordinator에서 Router의 관리, listener를 활용한 Child -> Parent로 데이터 전달하도록 했습니다.
* ViewModelType은 자식으로 받은 요청을 viewModel로 전달하여 처리할 기능을 명시합니다.
