# py3o-whl

py3o.fusionは、LibreOffice文書(Weriter)で作成したひな型ファイルをPDF帳票に変換できるPDF帳票作成サーバーです。  
また、IVSにも対応しているため、`IPAmj明朝`フォント等を使い、異体字を含む住所や氏名も正しい字形で表示できます。  

> 「IPAフォント」は、IPAの登録商標です。  
>   
> 本リポジトリを取得した場合、[「IPAフォントライセンスv1.0」](https://moji.or.jp/ipafont/license/)に同意したものと見なします。  
> [IPAフォントライセンスv1.0 - https://moji.or.jp/ipafont/license/](https://moji.or.jp/ipafont/license/)  
 

## インストール

**クローンの取得**

```bash
git clone --depth 1 https://github.com/jp-one/py3o-whl.git
```

**コンテナの起動**

```bash
cd py3o-whl/.devcontainer
docker-compose -p py3o-whl -f docker-compose.yml -f py3o-ports.yml up
```

## 起動確認

http://localhost:8765/

# 参考リンク

https://orus.io/xcg/docker/py3o  
https://orus.io/florent.aide/py3o.fusion  
https://orus.io/florent.aide/py3o.renderserver  
https://orus.io/florent.aide/py3o.renderers.pyuno  
https://orus.io/florent.aide/py3o.renderers.juno  
https://orus.io/florent.aide/py3o.renderclient  
https://orus.io/florent.aide/py3o.template  
https://orus.io/florent.aide/py3o.formats  
https://orus.io/florent.aide/py3o.types  
https://moji.or.jp/  
