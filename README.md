# BookManager
- 研究室の本を管理するアプリ
- Book2ManagerやBook２の改善版
- MVPアーキテクチャで設計
- FireBaseを利用して本やユーザの管理
- UnitTestでテストを行う

## ログイン画面
- ユーザを選択してログイン
- ユーザはFireStoreで管理
- 研究室内でのみ使用するアプリケーションかつプライバシーに関するデータではないため，パスワードなどは設けない
  - 利便性を重視
<img width="229" alt="image" src="https://user-images.githubusercontent.com/26514249/194714530-f122e654-06be-4d42-b9a9-3c0aee1f024d.png">

## 本一覧画面
- 本のサムネイル画像はFireStorageで管理
- 本の情報（タイトルや著名，出版社，サムネイル画像のURL，本の貸し借りの状態）はFireStoreで管理
- 単語をSearchBarに入力することで表示する本を絞ることが可能
- 借りられている本のみを表示することが可能
- 更新ボタンで最新データをfetchし，表示することが可能
- TableViewCell（本）をスワイプすると，以下のいずれかの操作を行うことが可能
  - その本は借りられていないので借りる
  - その本は自分が借りているので返す
  - その本は他のユーザが借りているため，借りることができず，誰が借りているかのみわかる
<img width="229" alt="image" src="https://user-images.githubusercontent.com/26514249/194714636-744f65eb-5fbb-47bf-a0cf-19702fc7ca36.png">

## 本の貸りる・返却画面
- バーコードをスキャンするだけで、本を借りる・返却が可能（OpenDB　APIで本情報を取得できた場合のみ）
- タブを開いた時の初期状態として、カメラ起動、借りるボタンが選択されている
- このアプリの1番の目的が本を借りる・返却なので、この行為がすばやく行えるように
<img width="209" alt="image" src="https://user-images.githubusercontent.com/26514249/195969462-11fcbe9d-33d4-4cdb-a382-c387b97d7801.png">

## 借りている本一覧画面
- 自分が借りている本のみが表示
- 自分が借りている本のみなので，TableViewCellをスワイプすることで返す操作のみ可能
<img width="229" alt="image" src="https://user-images.githubusercontent.com/26514249/194715084-15c5bba9-f788-4083-9dd9-d3d9b385013b.png">

## 本登録画面
- 本の登録が可能
- 本の登録にmoduleが多いので，ScrollViewで対応
- タイトル，著者，出版社をTextFieldから入力することが可能
  - OpenDB API上には，以下のISBNコードが登録されていない本が存在するため
- 本のサムネイル画像をカメラやフォトライブラリからアップロードすることが可能
- 本のISBNコードを入力することや，本のISBNバーコードを読み取ることで，OpenDB APIを使用して，本のタイトル，著者，出版社，本のサムネイルを取得することが可能
- 本の登録をすると，FirestoreやFireStorageに本情報がアップロードされる
<img width="181" alt="image" src="https://user-images.githubusercontent.com/26514249/194715173-09e40749-d367-4bd9-978c-92d6a388b12b.png">
