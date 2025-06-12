class PersianToEnglishConverter {
  // Persian to English mapping dictionary
  static const Map<String, String> _persianToEnglish = {
  "ا": "a",
  "آ": "a",
  "ب": "b",
  "پ": "p",
  "ت": "t",
  "ث": "s",
  "ج": "j",
  "چ": "ch",
  "ح": "h",
  "خ": "kh",
  "د": "d",
  "ذ": "z",
  "ر": "r",
  "ز": "z",
  "ژ": "zh",
  "س": "s",
  "ش": "sh",
  "ص": "s",
  "ض": "z",
  "ط": "t",
  "ظ": "z",
  "ع": "a",
  "غ": "gh",
  "ف": "f",
  "ق": "gh",
  "ک": "k",
  "گ": "g",
  "ل": "l",
  "م": "m",
  "ن": "n",
  "و": "v",
  "ه": "h",
  "ی": "y",
  "ة": "h",
  "ى": "a",
  "ئ": "y",
  "ؤ": "o"
};

  /// Converts a Persian word to English transliteration
  /// 
  /// [persianWord] - The Persian word to convert
  /// [preserveUnknown] - If true, keeps unknown characters as-is, otherwise removes them
  /// 
  /// Returns the English transliteration of the Persian word
  static String convertToEnglish(String persianWord, {bool preserveUnknown = false}) {
    if (persianWord.isEmpty) return '';
    
    StringBuffer result = StringBuffer();
    
    for (int i = 0; i < persianWord.length; i++) {
      String char = persianWord[i];
      
      if (_persianToEnglish.containsKey(char)) {
        result.write(_persianToEnglish[char]);
      } else if (preserveUnknown) {
        result.write(char);
      }
      // If preserveUnknown is false, unknown characters are simply skipped
    }
    
    return result.toString();
  }

  /// Converts multiple Persian words to English
  /// 
  /// [persianWords] - List of Persian words to convert
  /// [preserveUnknown] - If true, keeps unknown characters as-is
  /// 
  /// Returns a list of English transliterations
  static List<String> convertMultiple(List<String> persianWords, {bool preserveUnknown = false}) {
    return persianWords.map((word) => convertToEnglish(word, preserveUnknown: preserveUnknown)).toList();
  }

  /// Converts a Persian sentence (with spaces) to English
  /// 
  /// [persianSentence] - The Persian sentence to convert
  /// [preserveUnknown] - If true, keeps unknown characters as-is
  /// 
  /// Returns the English transliteration of the sentence
  static String convertSentence(String persianSentence, {bool preserveUnknown = false}) {
    return convertToEnglish(persianSentence, preserveUnknown: preserveUnknown);
  }
}