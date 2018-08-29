from nltk.stem.wordnet import WordNetLemmatizer
from nltk.tokenize import word_tokenize
import string
from nltk.corpus import stopwords 
import re

stop = set(stopwords.words('english'))
exclude = set(string.punctuation) 
lemma = WordNetLemmatizer()
def clean(doc):
    #doc = re.sub("\d+", " xxnumxx ", doc)
    doc = re.sub("\W+", " ", doc)
    words = [i for i in doc.lower().split()]
    
    punc_free = [ch for ch in words if ch not in exclude]
    #stop_free = [i for i in punc_free if i not in stop]
    normalized = [lemma.lemmatize(word) for word in punc_free]

    return ' '.join(normalized)
    #tokens = ' '.join(ch for ch in word_tokenize(" ".join(normalized)) if len(ch)>2)
    #tokens = word_tokenize(punc_free)
    #tokens = re.sub("(xxnumxx ){2,}", "xxdatexx ", tokens)
    #return tokens

    #normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    #return normalized


#######################################################################################33
import fileinput
for line in fileinput.input():
    result = clean(line)
    print(result)

