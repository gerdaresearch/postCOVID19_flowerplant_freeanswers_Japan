#----2022年8月花と植物、環境　消費行動調査　コロナ禍後の花・植物経験 自由回答 ワードクラウド(n=600)

#1．下準備
#ワーキングディレクトリ指定
setwd("~/your_working_directory") #working directory

#ファイル確認
file.exists("PostCovid_flowerPlant experiences_text_Japan2022.txt")  


#２．形態素、頻度表
#（１）ライブラリ読み込み
library(RMeCab)
library(dplyr)


#（２）文字コード確認　
#文字化けある場合、システムのコードとテキストと齟齬がないか、またはソフトのアップデートとコードの対応をチェック
Sys.setlocale(category ="LC_ALL",locale ="" )
#Default forR4.2.1＝UTF-8 (previously CP932--Japanese_Japan.932）)

#修正確認・表示
RMeCabC("RとRMeCabを最新版にアップデート、文字化け修正", mypref =1)


#（３）頻度表作成　形態素単位
#Frequency table 頻度表作成　
#Term 形態素（単語）、Info1　品詞大分類、Info2 品詞細分類、Freq 頻度
freq0 <- RMeCabFreq("PostCovid_flowerPlant experiences_text_Japan2022.txt")

freq0 %>% head() 

#品詞限定抽出　引数　type=1は、形態素解析（指定しないとデフォルトは単語単位解析）
freq0 <- docDF("PostCovid_flowerPlant experiences_text_Japan2022.txt", type=1, pos =c("名詞","形容詞","動詞"), minFreq = 2) 
freq0

#語彙表並べ替え、頻度上位確認　
library(magrittr)

#並べ替えは dplyrのarrange() 、%<>%はDF操作・上書き保存演算子（magrittrパッケージ）
#並べ替え　頻度順 列名がファイル名になっているので、Freqに変えて上書き保存
freq0 %<>% rename(FREQ = PostCovid_flowerPlant experiences_text_Japan2022.txt) %>% arrange(FREQ) 
freq0


#変更結果の末尾確認
#（４）共起関係
#共起語 第1引数 テキストファイル名、第2引数 ノード 第3引数 span　前後の語数
res <- collocate("PostCovid_flowerPlant experiences_text_Japan2022.txt", node ="癒す", span =3)

#（５）出力最後の１５行表示
res %>% tail(15)
freq0 %>% tail()

#形態素検索　任意
freq0 %>% filter(TERM == "癒す")
#癒す（原形）の語は33回出ていることがわかる



#３．ワードクラウド作成
#（１）ライブラリ読み込み
install.packages("wordcloud")
library(wordcloud)
library(devtools)
devtools::install_github("lchiffon/wordcloud2")
library(wordcloud2)

#（２）品詞限定
freq2 <- freq0 %>% filter(POS1 %in% c("名詞","形容詞","動詞"), POS2 %in%
                                   c("一般","自立"))
#ストップワード（「ない」「なし」など）は省いて、描画（わからないは「わかる」「ない」になっているため）
freq3 <- freq2 %>% filter(!TERM %in% c("ある","特に","ない","なし","くだ","さる","のる","する","できる","いる","わかる","思う","言う","なる","無い"))

#（３）プロット　出力
wordcloud(freq3$TERM, freq3$FREQ, min.freq=2, scale =c(6,1), family ="JP1", colors = brewer.pal(8,"Set1"), random.order= F, shape ="circle" ) 
#random.orderqをFALSEにしない場合、毎回違う結果のワードクラウドが表示される


wordcloud(freq3$TERM, freq3$FREQ, min.freq=2, scale =c(5,1), family ="JP2", colors = brewer.pal(8,"Dark2"), random.order = F, shape = "star")

