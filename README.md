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
  
<img src="https://user-images.githubusercontent.com/26514249/196032891-4963685d-be9d-46fc-83eb-a7129d550fee.jpeg" width="30%"/>

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
 
<img src="https://user-images.githubusercontent.com/26514249/196033079-0752ec80-8205-4c6a-87de-3788a876ff09.jpeg" width="30%"/>

## 本の貸りる・返却画面
- バーコードをスキャンするだけで、本を借りる・返却が可能（OpenDB　APIで本情報を取得できた場合のみ）
- タブを開いた時の初期状態として、カメラ起動、借りるボタンが選択されている
- このアプリの1番の目的が本を借りる・返却なので、この行為がすばやく行えるように

<img src="https://user-images.githubusercontent.com/26514249/196033113-f27294e0-6e18-4d77-ab36-f48a4e7d321a.jpeg" width="30%"/>

## 借りている本一覧画面
- 自分が借りている本のみが表示
- 自分が借りている本のみなので，TableViewCellをスワイプすることで返す操作のみ可能

<img src="https://user-images.githubusercontent.com/26514249/196033186-523357a6-be45-4681-93ce-f924fe6b7be7.jpeg" width="30%"/>

## 本登録画面
- 本の登録が可能
- 本の登録にmoduleが多いので，ScrollViewで対応
- タイトル，著者，出版社をTextFieldから入力することが可能
  - OpenDB API上には，以下のISBNコードが登録されていない本が存在するため
- 本のサムネイル画像をカメラやフォトライブラリからアップロードすることが可能
- 本のISBNコードを入力することや，本のISBNバーコードを読み取ることで，OpenDB APIを使用して，本のタイトル，著者，出版社，本のサムネイルを取得することが可能
- 本の登録をすると，FirestoreやFireStorageに本情報がアップロードされる

<img src="https://user-images.githubusercontent.com/26514249/196033222-0488a8aa-a9ad-4bfd-8418-7ea61a206056.jpeg" width="30%"/>
