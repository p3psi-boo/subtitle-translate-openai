bool debug = true;

string apiKey = '';
string baseUrl = 'https://api.siliconflow.cn/v1';
string model = 'Qwen/Qwen1.5-14B-Chat';

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

JsonValue parseJSON(string content) {
  JsonReader reader;
  JsonValue data;
  reader.parse(content, data);
  return data;
}



string Translate(string text, string &in srcLang, string &in dstLang) {
  if (debug) {
    HostOpenConsole();
  }

  string systemMessage = "You are a professional, authentic machine translation engine.";
  string userMessage = "Translate the following text from " + srcLang + " to " + dstLang + ":\n\n" + text;
  
  string headers = "Content-Type: application/json\nAuthorization: Bearer " + apiKey + "\n";

  string body = "{\"model\":\"" + model + "\",\"messages\":[{\"role\":\"system\",\"content\":\"You are a professional, authentic machine translation engine..\"},{\"role\":\"user\",\"content\":\"Translate the following text from " + srcLang + " to " + dstLang + ": " + text + "\"}]}";

  string url = baseUrl + '/chat/completions';

  uintptr response = HostOpenHTTP(url, 'PotPlayer', headers, body, true);
  if (response == 0) {
    return '翻译请求失败';
  }

  string content = HostGetContentHTTP(response);

  if (debug) {
    HostPrintUTF8(content);
  }

  JsonValue data = parseJSON(content);

  if (data.isObject() && data['choices'].isArray()) {
    string translatedText = data['choices'][0]['message']['content'].asString();

    if (debug) {
      HostPrintUTF8(srcLang + '=>' + dstLang);
      HostPrintUTF8(text + '\n=>\n' + translatedText);
    }

    srcLang = 'UTF8';
    dstLang = 'UTF8';
    HostCloseHTTP(response);
    return translatedText;
  }

  HostCloseHTTP(response);
  return '';
}
