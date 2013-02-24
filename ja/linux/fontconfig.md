<link href="http://skkzsh.github.com/style_sheet/markdown/markdown.css" rel="stylesheet" title="markdown"></link>

<link href="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="http://google-code-prettify.googlecode.com/svn/trunk/src/prettify.js"></script>
<script type="text/javascript">
$(function(){
    $('pre').css({
        'background-color': '#f6f6f6',
        'border': '1px dotted #ccc',
        'padding': '0.8em'
    });
    $('pre code').addClass('prettyprint');
    prettyPrint();
});
</script>

# Ubuntuでデスクトップ環境を変えても, Operaのフォントを綺麗なままに

- プラットフォーム: Ubuntu 12.04
- Operaのバージョン: 12.14

## 問題点

デフォルトのデスクトップ環境であるUnityでは, フォントはTakaoゴシックで比較的綺麗.
しかし, ウィンドウ・マネージャをFluxboxに変えると, Operaのフォントが汚くなる.

## 解決法

解決法は以下の2通り.

### その1

アドレスバーに"[opera:config](opera:config)"と入力してEnterを押す.
"`fontconfig`"と検索して, 項目にチェック.

### その2

`~/.opera/operaprefs.ini`に以下を追記.

    [Fonts]
    Prefer Fontconfig Settings=1

---
[[Home](../index.html)]
_Last Change: 2013/02/25 06:41:47 JST_
