## bitwig-studio-japanese-font
An auto-install script for fonts that support Japanese in Bitwig Studio.

Bitwig Studio用日本語フォントの生成およびインストールを自動で実行するスクリプトです。

### 実行環境
fontforgeがインストールされている事を前提とします。
homebrewでのインストール例
```
brew install fontforge
mkdir -p /Users/masafumi/Library/Python/2.7/lib/python/site-packages
echo 'import site; site.addsitedir("/usr/local/lib/python2.7/site-packages")' >> ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
```

### インストール
Terminal.appでスクリプトを実行してください。
```
./install-jp.sh
```
以下のファイルがインストールされます。
```
/Applications/Bitwig Studio.app/Contents/PlugIns/JavaVM.plugin/Contents/Home/lib/ext/bitwig-japanese-fonts.zip
```

### アンインストール
```
./install-jp.sh uninstall
```

### 不要ファイルの削除
本ディレクトリ中のダウンロードまたは自動で生成されるファイルを削除します。
```
./install-jp.sh clean
```

### Notes
 - Bitwig Studioブラウザで音楽ライブラリ等、日本語ファイル名の表示を目的としています。
 - 本スクリプトはBitwig Studioで使用されているSourceSans ProフォントにMgen+フォントをマージしインストールします。
 - 日本語表示可能な箇所はSourceSans Pro使用されている箇所に限定されます。
 - Bitwig Studioで使用されているフォントを抽出しマージしていますので、既存の表示には影響はないはずです...充分には検証はしていません。
 - 本フォント使用に関連する障害その他一切の責任は使用者が追うものとします。
 - 本スクリプトの改定、配布は自由に行ってください。筆者への連絡不要です。
 - 生成されたフォントのライセンスについては以下を参照下さい。
   - SourceSans Pro https://github.com/adobe-fonts/source-sans-pro
   - Mgen+ (ムゲンプラス) http://jikasei.me/font/mgenplus

