# subtitle-translate-openai

使用 OpenAI Chat Completions API 为 PotPlayer 翻译实时字幕。基于 (BlackGlory/subtitle-translate-tmt)[https://github.com/BlackGlory/subtitle-translate-tmt/] 修改。Prompt 参考了[沉浸式翻译](https://immersivetranslate.com/)。

## 必要条件

- PotPlayer 版本 >= 1.7.20977

## 安装

1. [下载](https://github.com/p3psi-boo/subtitle-translate-openai/archive/master.zip)
2. 解压缩
3. 复制文件 `SubtitleTranslate - openai.as` 和 `SubtitleTranslate - openai.ico` 到 `C:\Program Files\DAUM\PotPlayer\Extension\Subtitle\Translate` 文件夹
4. 运行/重启 PotPlayer
5. 菜单->字幕->实时字幕翻译->实时字幕翻译设置->OPENAI 翻译->帐户设置, 填写你的 BaseURL（默认为[硅基流动](https://docs.siliconflow.cn/)的 API） 和 API Key。模型名请修改源文件 `model` 变量（第 5 行）。
6. 配置 PotPlayer 关于实时字幕翻译设置的其他选项, 播放带有字幕文本的视频, 测试效果
