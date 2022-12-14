
# ๐ป ํ๋ก์ ํธ ๋งค๋์ 

> ํ๋ก์ ํธ ๊ธฐ๊ฐ 2022-07-04 ~

![Sep-05-2022 07-43-07](https://user-images.githubusercontent.com/70807352/188336308-df730dc4-3681-4630-b3b3-cfeff788729f.gif)![Sep-05-2022 07-44-29](https://user-images.githubusercontent.com/70807352/188336335-55e9835f-ea31-40a9-ba3b-e7679c6666e5.gif)![Sep-05-2022 07-45-06](https://user-images.githubusercontent.com/70807352/188336343-db4dcd16-46ec-4e33-b489-e4df7e845957.gif)



### iPad app 
[๋ฐ๋ก๊ฐ๊ธฐ](https://github.com/Kim-TaeHyun-A/ios-project-manager)
 

# Unit Test
์ถํ ๊ธฐ๋ฅ ์ถ๊ฐ ์ ๊ธฐ์กด ์ฝ๋๋ ๋์ผํ ๊ฒฐ๊ณผ๋ฅผ ๋ณด์ด๋ ๊ฒ์ ๋ณด์ฅํ๊ธฐ ์ํด์๋ ์ ๋๋ก ๊ตฌํ๋ ๊ฒ์ธ์ง ํ์ธํ๊ธฐ ์ํด์ Unit Test๋ฅผ ์์ฑํ๋ค.

BehaviorRelay๋ฅผ ์ฌ์ฉํ๋ ๋ฉ์๋๋ฅผ ํ์คํธํ๋๋ฐ, ๋ชจ๋  ๊ตฌ๋์์๊ฒ ๋ณ๊ฒฝ ์ฌํญ์ ์๋ฆฌ๋ ํน์ง ๋๋ฌธ์ ์ํ๋ ๋ถ๋ถ๋ง ํ์คํธ ์งํ์ด ๋ถ๊ฐ๋ฅํ๋ค.
์ด๋ฅผ ํด๊ฒฐํ๊ธฐ ์ํด์ testDouble์ ๋ง๋ค๊ณ  ์ค์  ํ์๋ค๊ณผ์ ์์กด์ฑ์ ๋ถ๋ฆฌํ๋ค.
๊ธฐ์กด์ protocol์ ์ ์ธํ์ง ์์ ๋ถ๋ถ์ protocolํ ์ํค๋ฉด์ Mock, Stub์ ๋ง๋ค ์ ์์๋ค.

Stub์ ์ฌ์ฉํด์ state verification์ ์งํํ ๊ฒฝ์ฐ ํ ํ์ ํ์คํธํ  ๋ ์ฐ์์ ์ผ๋ก ์์กดํ๋ ๋ชจ๋  ํ์์ ๋ํ testDouble์ ์์ฑํ๋ ๋ฌธ์ ๊ฐ ์๊ฒผ๋ค.
์ด๋ฅผ ํด๊ฒฐํ๊ธฐ ์ํด Mock ๊ฐ์ฒด๋ฅผ ๋ง๋ค๊ณ  behavior verification์ ์งํํ๋ค.

```swift
// state verification with Stub
class ProjectUsecaseTestsWithStub: XCTestCase {
    var sut: ProjectUseCaseProtocol!
    var stubPersistentManager: StubPersistentManager!
    var stubNetworkManager: StubNetworkManager!
    var stubHistoryManager: StubHistoryManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        stubPersistentManager = StubPersistentManager()
        stubNetworkManager = StubNetworkManager()
        stubHistoryManager = StubHistoryManager()
        
        sut = DefaultProjectUseCase(
            projectRepository: PersistentRepository(
                projectEntities: BehaviorRelay<[ProjectEntity]>(value: []),
                persistentManager: stubPersistentManager
            ),
            networkRepository: NetworkRepository(networkManger: stubNetworkManager),
            historyRepository: HistoryRepository(historyManager: stubHistoryManager)
        )
    }
    ...
}
```

```swift
// behavior verification with Mock
final class ProjectUsecaseTestsWithMock: XCTestCase {
    var sut: ProjectUseCaseProtocol!
    var mockPersistentRepository: MockPersistentRepository!
    var mockNetworkRepository: MockNetworkRepository!
    var mockHistoryRepository: MockHistoryRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockPersistentRepository = MockPersistentRepository()
        mockNetworkRepository = MockNetworkRepository()
        mockHistoryRepository = MockHistoryRepository()
        
        sut = DefaultProjectUseCase(
            projectRepository: mockPersistentRepository,
            networkRepository: mockNetworkRepository,
            historyRepository: mockHistoryRepository
        )
    }
    ...
}
```

```swift
// behavior verification with Mock
final class MainVCViewModelTests: XCTestCase {
    var sut: MainVCViewModelProtocol!
    var mockProjectUseCase: MockProjectUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockProjectUseCase = MockProjectUseCase()
        sut = MainVCViewModel(projectUseCase: mockProjectUseCase)
    }
 ...   
}

```

# VC ์ญํ  ๋ถ๋ฆฌ

MVVM ํจํด์์ VC๋ ๋ค๋ฅธ view์ ๋์ผํ ์ญํ ์ ํ๋ค. ๋ค๋ฅธ ๋ทฐ๋ก ํ ๋นํ  ์ ์์ ์ญํ ์ ๋ถ๋ฆฌํด์ ์ฝ๋๋์ 100์ค ์ ๋ ์ค์ด๋ฉด์ ๊ธฐ์กด์ VC์ ์ญํ ์ ๊ฐ์ํ์์ผฐ๋ค.

* ์ 
<img width="284" alt="image" src="https://user-images.githubusercontent.com/70807352/185928816-8691e22f-ac13-4cfe-85bf-e7194ccb4a82.png">

* ํ
<img width="235" alt="image" src="https://user-images.githubusercontent.com/70807352/185928472-4f374118-747c-4549-93c3-7cf1ed0e675e.png">

# input & ouput protocol
MVVM์์๋ view์ ๋ฐ์ํ๋ Input์ viewModel์์ ๊ฐ๊ณตํ์ ๋ด๋ถ์์ output์ ๋ง๋๋ ํํ์ด๋ค. ์ด๋ฅผ ํจ๊ณผ์ ์ผ๋ก ๋ํ๋ด๊ธฐ ์ํด protocol์ ์ฌ์ฉํ๊ณ , ์ด ๋๋ถ์ testDouble ๊ตฌํ์ด ๊ฐ๋ฅํ๋ค.

```swift
protocol DetailViewModelInputProtocol {
    func read()
    func update(_ content: ProjectEntity)
}

protocol DetailViewModelOutputProtocol {
    var content: ProjectEntity { get }
    var currentProjectEntity: ProjectEntity? { get }
}

protocol DetailViewModelProtocol: DetailViewModelInputProtocol, DetailViewModelOutputProtocol { }

final class DetailViewModel: DetailViewModelProtocol {
    private let projectUseCase: ProjectUseCaseProtocol
    
    // MARK: - Output
    
    var content: ProjectEntity
    var currentProjectEntity: ProjectEntity?
    
    init(projectUseCase: ProjectUseCaseProtocol, content: ProjectEntity) {
        self.projectUseCase = projectUseCase
        self.content = content
    }
    
    private func updateHistory(by content: ProjectEntity) {
        let historyEntity = HistoryEntity(editedType: .edit,
                                          title: content.title,
                                          date: Date().timeIntervalSince1970)
        
        projectUseCase.createHistory(historyEntity: historyEntity)
    }
}

// MARK: - Input

extension DetailViewModel {
    func read() {
        currentProjectEntity = projectUseCase.read(projectEntityID: content.id)
    }
    
    func update(_ content: ProjectEntity) {
        projectUseCase.update(projectEntity: content)
        updateHistory(by: content)
    }
}

```
