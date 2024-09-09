/*
  real time subtitle translate for PotPlayer using Tencent Machine Translation API
  https://github.com/BlackGlory/subtitle-translate-tmt
  https://cloud.tencent.com/product/tmt
*/

// string GetTitle()                             -> get title for UI
// string GetVersion                            -> get version for manage
// string GetDesc()                              -> get detail information
// string GetLoginTitle()                          -> get title for login dialog
// string GetLoginDesc()                          -> get desc for login dialog
// string GetUserText()                            -> get user text for login dialog
// string GetPasswordText()                          -> get password text for login dialog
// string ServerLogin(string User, string Pass)                -> login
// string ServerLogout()                          -> logout
// array<string> GetSrcLangs()                         -> get source language
// array<string> GetDstLangs()                         -> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang)   -> do translate !!

bool debug = false;

string apiKey = '';
string baseUrl = 'https://api.openai.com/v1';

// 移除不再需要的腾讯API相关变量和函数
// 删除 secretId, secretKey, DstLangTable, SrcLangTable 等

string GetTitle() {
  return
    '{$CP936=OpenAI API 翻译$}'
    '{$CP0=OpenAI API Translate$}';
}

string GetUserText() {
  return 'BaseURL:';
}

string GetPasswordText() {
  return 'API Key:';
}

string ServerLogin(string username, string password) {
  if (username.empty() || password.empty()) return 'fail';

  baseUrl = username;
  apiKey = password;
  return '200 ok';
}

void ServerLogout() {
  apiKey = '';
}

array<string> GetSrcLangs() {
  return {'auto', 'zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'ru', 'pt'};
}

array<string> GetDstLangs() {
  return {'zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'ru', 'pt'};
}

string Translate(string text, string &in srcLang, string &in dstLang) {
  if (debug) {
    HostOpenConsole();
  }

  string systemMessage = "You are a professional, authentic machine translation engine.";
  string userMessage = "Translate the following text from " + srcLang + " to " + dstLang + ":\n\n" + text;
  
  dictionary headers = {
    {'Content-Type', 'application/json'},
    {'Authorization', 'Bearer ' + apiKey}
  };

  dictionary body = {
    {'model', 'gpt-3.5-turbo'},
    {'messages', '[{"role": "system", "content": "' + systemMessage + '"}, {"role": "user", "content": "' + userMessage + '"}]'},
    {'temperature', '0.7'}
  };

  string jsonBody = JSON::stringify(body);
  
  string url = baseUrl + '/chat/completions';
  string response = HostUrlGetString(url, 'POST', jsonBody, headers);
  
  if (debug) {
    HostPrintUTF8(response);
  }

  JsonValue data = parseJSON(response);

  if (data.isObject() && data['choices'].isArray() && data['choices'].length() > 0) {
    string translatedText = data['choices'][0]['message']['content'].asString();

    if (debug) {
      HostPrintUTF8(srcLang + '=>' + dstLang);
      HostPrintUTF8(text + '\n=>\n' + translatedText);
    }

    srcLang = 'UTF8';
    dstLang = 'UTF8';
    return translatedText;
  }

  return '';
}
